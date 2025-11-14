"""
Sistema de autenticación y autorización con AWS Cognito
"""
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import jwt, JWTError
import boto3
from typing import Optional, List
from sqlalchemy.orm import Session
from sqlalchemy import and_, text
import requests
import json
from functools import wraps

from app.core.database import get_db
from app.core.config import settings
from app.models.auth import Usuario, UsuarioDifusora
from app.models.catalogos import Difusora

security = HTTPBearer()


class CognitoAuth:
    """Clase para manejar autenticación con AWS Cognito"""
    
    def __init__(self):
        self.user_pool_id = settings.COGNITO_USER_POOL_ID
        self.client_id = settings.COGNITO_CLIENT_ID
        self.region = settings.COGNITO_REGION or "us-east-1"
        self.init_error = None  # Almacenar el error de inicialización para debugging
        
        if not self.user_pool_id or not self.client_id:
            self.enabled = False
            self.cognito_client = None
            self.ses_client = None
            missing = []
            if not self.user_pool_id:
                missing.append("COGNITO_USER_POOL_ID")
            if not self.client_id:
                missing.append("COGNITO_CLIENT_ID")
            self.init_error = f"Variables de entorno faltantes: {', '.join(missing)}"
        else:
            self.enabled = True
            self.jwks_url = f"https://cognito-idp.{self.region}.amazonaws.com/{self.user_pool_id}/.well-known/jwks.json"
            try:
                # Intentar crear el cliente de Cognito
                # En ECS, las credenciales se obtienen automáticamente del IAM role
                self.cognito_client = boto3.client('cognito-idp', region_name=self.region)
                
                # Inicializar cliente de SES para envío de emails
                try:
                    self.ses_client = boto3.client('ses', region_name=self.region)
                except Exception as e:
                    self.ses_client = None
                    # SES es opcional, no fallar si no está disponible
                
                # Verificar que las credenciales funcionan intentando describir el user pool
                try:
                    self.cognito_client.describe_user_pool(UserPoolId=self.user_pool_id)
                except Exception as e:
                    # Si falla, puede ser por falta de permisos en el IAM role
                    self.cognito_client = None
                    self.ses_client = None
                    error_msg = str(e)
                    if "AccessDenied" in error_msg or "UnauthorizedOperation" in error_msg:
                        self.init_error = f"El IAM role del task no tiene permisos para acceder a Cognito. Error: {error_msg}"
                    elif "NoCredentialsError" in error_msg or "Unable to locate credentials" in error_msg:
                        self.init_error = f"No se encontraron credenciales de AWS. En ECS, asegúrate de que el task tenga un IAM role asignado. Error: {error_msg}"
                    else:
                        self.init_error = f"Error al verificar acceso a Cognito: {error_msg}"
            except Exception as e:
                # Error al crear el cliente de boto3
                self.cognito_client = None
                self.ses_client = None
                error_msg = str(e)
                if "NoCredentialsError" in error_msg or "Unable to locate credentials" in error_msg:
                    self.init_error = f"No se encontraron credenciales de AWS. En ECS, asegúrate de que el task tenga un IAM role asignado con permisos para Cognito. Error: {error_msg}"
                else:
                    self.init_error = f"Error al inicializar cliente de Cognito: {error_msg}"
    
    def get_jwks(self) -> dict:
        """Obtiene las claves públicas de Cognito (JWKS)"""
        try:
            response = requests.get(self.jwks_url, timeout=5)
            response.raise_for_status()
            return response.json()
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                detail="Error de configuración de autenticación"
            )
    
    def verify_token(self, token: str) -> dict:
        """Verifica el token JWT de Cognito"""
        if not self.enabled:
            # En desarrollo, si Cognito no está configurado, permitir acceso
            return {
                "sub": "dev-user",
                "email": "dev@example.com",
                "cognito:groups": ["admin"]
            }
        
        try:
            # Obtener el header del token sin verificar
            unverified_header = jwt.get_unverified_header(token)
            kid = unverified_header.get("kid")
            
            if not kid:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Token inválido: falta kid en el header"
                )
            
            # Obtener JWKS
            jwks = self.get_jwks()
            
            # Buscar la clave correspondiente
            key = None
            for jwk in jwks.get("keys", []):
                if jwk.get("kid") == kid:
                    key = jwk
                    break
            
            if not key:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Token inválido: clave pública no encontrada"
                )
            
            # Convertir JWK a formato para verificación usando jose
            from jose import jwk
            from jose.constants import ALGORITHMS
            
            # Construir clave pública desde JWK
            public_key = jwk.construct(key, algorithm=ALGORITHMS.RS256)
            
            # Verificar y decodificar el token con la clave pública
            expected_issuer = f"https://cognito-idp.{self.region}.amazonaws.com/{self.user_pool_id}"
            
            try:
                # Verificar el token (esto valida firma, expiración, issuer, etc.)
                # jose.decode necesita la clave pública construida
                payload = jwt.decode(
                    token,
                    public_key,  # Usar la clave pública construida desde JWK
                    algorithms=["RS256"],
                    audience=None,  # Los access tokens no siempre tienen aud, desactivamos verificación
                    issuer=expected_issuer,
                    options={
                        "verify_signature": True,
                        "verify_exp": True,
                        "verify_iat": True,
                        "verify_aud": False,  # Los access tokens no siempre tienen aud
                        "verify_iss": True
                    }
                )
            except jwt.ExpiredSignatureError:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Token expirado. Por favor, inicia sesión nuevamente."
                )
            except jwt.InvalidIssuerError:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Token inválido: issuer incorrecto"
                )
            except jwt.InvalidTokenError as e:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail=f"Token inválido: {str(e)}"
                )
            
            # Validar que el token es un access token o id token
            token_use = payload.get("token_use")
            if token_use not in ["access", "id"]:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail=f"Token inválido: tipo de token no soportado ({token_use})"
                )
            
            # Verificar que el token es de nuestro user pool (doble verificación)
            if payload.get("iss") != expected_issuer:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Token inválido: issuer incorrecto"
                )
            
            return payload
            
        except HTTPException:
            raise
        except JWTError as e:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail=f"Token inválido o expirado: {str(e)}"
            )
        except Exception as e:
            import logging
            logger = logging.getLogger(__name__)
            logger.error(f"Error verificando token: {str(e)}", exc_info=True)
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Error verificando token. Contacta al administrador."
            )
    
    def create_user(
        self,
        email: str,
        nombre: str,
        rol: str,
        temporary_password: Optional[str] = None
    ) -> dict:
        """
        Crea un usuario en Cognito y lo asigna al grupo correspondiente
        
        Returns:
            dict con cognito_user_id y otros datos del usuario creado
        """
        if not self.enabled or not self.cognito_client:
            raise HTTPException(
                status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                detail="Cognito no está configurado o no hay credenciales de AWS. Configura las variables de entorno COGNITO_USER_POOL_ID, COGNITO_CLIENT_ID, COGNITO_REGION y las credenciales de AWS (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY) o configura el perfil de AWS."
            )
        
        try:
            import secrets
            import string
            
            # Generar contraseña temporal si no se proporciona
            if not temporary_password:
                # Generar contraseña segura que cumpla con la política de Cognito:
                # - Mínimo 12 caracteres
                # - Al menos una mayúscula
                # - Al menos una minúscula
                # - Al menos un número
                # - Al menos un símbolo
                uppercase = string.ascii_uppercase
                lowercase = string.ascii_lowercase
                digits = string.digits
                symbols = "!@#$%^&*()_+-=[]{}|;:,.<>?"
                
                # Asegurar al menos un carácter de cada tipo
                password_chars = [
                    secrets.choice(uppercase),
                    secrets.choice(lowercase),
                    secrets.choice(digits),
                    secrets.choice(symbols)
                ]
                
                # Completar hasta 16 caracteres con caracteres aleatorios
                all_chars = uppercase + lowercase + digits + symbols
                for _ in range(12):
                    password_chars.append(secrets.choice(all_chars))
                
                # Mezclar los caracteres
                secrets.SystemRandom().shuffle(password_chars)
                temporary_password = ''.join(password_chars)
            
            # Crear usuario en Cognito
            # NO usar MessageAction='SUPPRESS' para que Cognito envíe el código de verificación automáticamente
            # Cuando email_verified='false', Cognito envía el código de verificación automáticamente
            response = self.cognito_client.admin_create_user(
                UserPoolId=self.user_pool_id,
                Username=email,
                UserAttributes=[
                    {'Name': 'email', 'Value': email},
                    {'Name': 'email_verified', 'Value': 'false'},  # false para que Cognito envíe código de verificación
                    {'Name': 'name', 'Value': nombre},
                ],
                TemporaryPassword=temporary_password,
                # NO especificar MessageAction para que Cognito envíe el código automáticamente
                DesiredDeliveryMediums=['EMAIL']
            )
            
            cognito_user_id = response['User']['Username']

            
            # Asignar al grupo correspondiente según el rol
            group_name = rol.lower()  # admin, manager, operador
            try:
                self.cognito_client.admin_add_user_to_group(
                    UserPoolId=self.user_pool_id,
                    Username=cognito_user_id,
                    GroupName=group_name
                )

            except self.cognito_client.exceptions.ResourceNotFoundException:
                try:
                    self.cognito_client.create_group(
                        GroupName=group_name,
                        UserPoolId=self.user_pool_id,
                        Description=f"Grupo para usuarios con rol {rol}"
                    )
                    self.cognito_client.admin_add_user_to_group(
                        UserPoolId=self.user_pool_id,
                        Username=cognito_user_id,
                        GroupName=group_name
                    )
                except Exception as e:
                     pass
            return {
                'cognito_user_id': cognito_user_id,
                'temporary_password': temporary_password,
                'email': email
            }
            
        except self.cognito_client.exceptions.UsernameExistsException:
            # Verificar su estado y reenviar código de verificación si no está verificado
            try:
                user_info = self.cognito_client.admin_get_user(
                    UserPoolId=self.user_pool_id,
                    Username=email
                )
                
                # Verificar si el email está verificado
                email_verified = False
                for attr in user_info.get('UserAttributes', []):
                    if attr['Name'] == 'email_verified':
                        email_verified = attr['Value'] == 'true'
                        break
                
                # Si no está verificado, necesitamos obtener o generar una contraseña temporal
                if not email_verified:
                    # Para usuarios existentes no verificados, necesitamos establecer una nueva contraseña temporal
                    # para que puedan iniciar sesión
                    try:
                        import secrets
                        import string
                        
                        # Generar nueva contraseña temporal que cumpla con la política
                        uppercase = string.ascii_uppercase
                        lowercase = string.ascii_lowercase
                        digits = string.digits
                        symbols = "!@#$%^&*()_+-=[]{}|;:,.<>?"
                        
                        password_chars = [
                            secrets.choice(uppercase),
                            secrets.choice(lowercase),
                            secrets.choice(digits),
                            secrets.choice(symbols)
                        ]
                        
                        all_chars = uppercase + lowercase + digits + symbols
                        for _ in range(12):
                            password_chars.append(secrets.choice(all_chars))
                        
                        secrets.SystemRandom().shuffle(password_chars)
                        new_temporary_password = ''.join(password_chars)
                        
                        # Establecer nueva contraseña temporal
                        self.cognito_client.admin_set_user_password(
                            UserPoolId=self.user_pool_id,
                            Username=email,
                            Password=new_temporary_password,
                            Permanent=False  # Temporal, el usuario debe cambiarla
                        )
                        

                        
                        return {
                            'cognito_user_id': email,
                            'temporary_password': new_temporary_password,
                            'email': email,
                            'user_exists': True,
                            'email_verified': False
                        }
                    except Exception as e:
                        raise HTTPException(
                            status_code=status.HTTP_400_BAD_REQUEST,
                            detail=f"El usuario ya existe en Cognito pero no se pudo establecer una contraseña temporal: {str(e)}. El usuario debe usar 'Reenviar código' desde la página de login."
                        )
                else:
                    # Usuario ya verificado
                    raise HTTPException(
                        status_code=status.HTTP_400_BAD_REQUEST,
                        detail="El usuario ya existe en Cognito y está verificado. El usuario puede iniciar sesión directamente."
                    )
            except HTTPException:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="El usuario ya existe en Cognito. Si no has verificado tu email, intenta iniciar sesión y solicita un nuevo código de verificación."
                )
        except self.cognito_client.exceptions.InvalidParameterException as e:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Error en parámetros: {str(e)}"
            )
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Error creando usuario: {str(e)}"
            )
    
    def update_user_role(self, cognito_user_id: str, old_rol: str, new_rol: str):
        """
        Actualiza el rol de un usuario moviéndolo entre grupos de Cognito
        """
        if not self.enabled or not self.cognito_client:
            # Si Cognito no está habilitado, solo actualizar en RDS (ya se hace en el endpoint)
            return
        
        try:
            old_group = old_rol.lower()
            new_group = new_rol.lower()
            
            # Verificar que el usuario existe en Cognito
            username = cognito_user_id
            try:
                self.cognito_client.admin_get_user(
                    UserPoolId=self.user_pool_id,
                    Username=cognito_user_id
                )
            except self.cognito_client.exceptions.UserNotFoundException:
                # El cognito_user_id puede ser el sub (UUID) o el email
                # Si no se encuentra, intentar buscar por email
                # Esto puede pasar si el usuario se creó con email como username
                # pero se guardó el sub en la BD
                
                # Si cognito_user_id parece un email, usarlo directamente
                if '@' in cognito_user_id:
                    username = cognito_user_id
                else:
                    # Si no, no podemos actualizar el rol en Cognito
                    # Solo se actualizará en RDS
                    import logging
                    logger = logging.getLogger(__name__)
                    logger.warning(f"Usuario {cognito_user_id} no encontrado en Cognito. Solo se actualizará en RDS.")
                    return
            
            # Remover del grupo anterior
            try:
                self.cognito_client.admin_remove_user_from_group(
                    UserPoolId=self.user_pool_id,
                    Username=username,
                    GroupName=old_group
                )
            except Exception as e:
                # No es crítico si falla, el usuario puede no estar en el grupo
                pass
            
            # Agregar al nuevo grupo
            try:
                self.cognito_client.admin_add_user_to_group(
                    UserPoolId=self.user_pool_id,
                    Username=username,
                    GroupName=new_group
                )
            except self.cognito_client.exceptions.ResourceNotFoundException:
                # El grupo no existe, crearlo
                try:
                    self.cognito_client.create_group(
                        GroupName=new_group,
                        UserPoolId=self.user_pool_id,
                        Description=f"Grupo para usuarios con rol {new_rol}"
                    )
                    self.cognito_client.admin_add_user_to_group(
                        UserPoolId=self.user_pool_id,
                        Username=username,
                        GroupName=new_group
                    )
                except Exception as e:
                    # Si falla la creación del grupo, loguear pero no fallar
                    import logging
                    logger = logging.getLogger(__name__)
                    logger.error(f"Error creando grupo {new_group}: {str(e)}")
                    
        except Exception as e:
            # No lanzar excepción, solo loguear
            # El rol ya se actualizó en RDS, que es lo más importante
            import logging
            logger = logging.getLogger(__name__)
            logger.error(f"Error actualizando rol en Cognito: {str(e)}")
            # No lanzar HTTPException, permitir que continúe
    
    def send_invitation_email(self, email: str, temporary_password: str, nombre: str):
        """
        Envía email de invitación al usuario usando Amazon SES
        Returns:
            dict con 'sent' (bool), 'message' (str), 'reason' (str opcional)
        """
        if not self.ses_client:


            return {
                'sent': False,
                'message': 'SES no está configurado',
                'reason': 'SES no disponible'
            }
        
        try:
            # Verificar que el email remitente esté verificado en SES
            from_email = settings.SES_FROM_EMAIL
            
            # Obtener estado de verificación del remitente
            remitente_attrs = self.ses_client.get_identity_verification_attributes(
                Identities=[from_email]
            )
            remitente_status = remitente_attrs.get('VerificationAttributes', {}).get(from_email, {}).get('VerificationStatus', 'NotFound')
            
            if remitente_status != 'Success':
                if remitente_status == 'Pending':
                    pass
                else:
                    pass

                return {
                    'sent': False,
                    'message': f'Email remitente {from_email} no verificado en SES (estado: {remitente_status})',
                    'reason': 'remitente_no_verificado',
                    'status': remitente_status,
                    'instructions': f'Revisa la bandeja de entrada de {from_email} y haz clic en el link de verificación de Amazon SES'
                }
            
            # En modo sandbox, el email destino también debe estar verificado
            # En producción con dominio verificado o salida del sandbox, esto no es necesario
            if not settings.SES_PRODUCTION_MODE:
                destino_attrs = self.ses_client.get_identity_verification_attributes(
                    Identities=[email]
                )
                destino_status = destino_attrs.get('VerificationAttributes', {}).get(email, {}).get('VerificationStatus', 'NotFound')
                
                if destino_status != 'Success':



                    return {
                        'sent': False,
                        'message': f'Email destino {email} no verificado en SES (modo sandbox, estado: {destino_status})',
                        'reason': 'destino_no_verificado',
                        'status': destino_status,
                        'instructions': f'Verifica el email {email} en la sección "Verificar Emails" antes de invitar, o activa SES_PRODUCTION_MODE=true en backend/.env'
                    }
            
            # Contenido del email corporativo profesional
            subject = "Bienvenido a Programador Musical - Credenciales de Acceso"
            frontend_url = settings.FRONTEND_URL
            body_html = f"""
            <!DOCTYPE html>
            <html lang="es">
            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <title>Bienvenido a Programador Musical</title>
                <style>
                    * {{ margin: 0; padding: 0; box-sizing: border-box; }}
                    body {{ font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, 'Noto Sans', sans-serif; line-height: 1.7; color: #1a1a1a; margin: 0; padding: 0; background-color: #f4f6f9; -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale; }}
                    .email-wrapper {{ max-width: 650px; margin: 0 auto; background-color: #ffffff; }}
                    .email-header {{ background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); color: #ffffff; padding: 50px 40px; text-align: center; }}
                    .email-header h1 {{ font-size: 32px; font-weight: 700; letter-spacing: -0.5px; margin: 0 0 8px 0; }}
                    .email-header p {{ font-size: 16px; opacity: 0.95; margin: 0; font-weight: 400; }}
                    .email-body {{ padding: 50px 40px; background-color: #ffffff; }}
                    .email-body h2 {{ font-size: 24px; font-weight: 600; color: #1e293b; margin: 0 0 20px 0; line-height: 1.3; }}
                    .email-body p {{ font-size: 16px; color: #475569; margin: 0 0 20px 0; line-height: 1.7; }}
                    .info-box {{ background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%); border-left: 4px solid #3b82f6; padding: 24px; margin: 30px 0; border-radius: 6px; }}
                    .info-box strong {{ display: block; font-size: 16px; color: #1e40af; margin-bottom: 8px; font-weight: 600; }}
                    .info-box p {{ margin: 0; font-size: 15px; color: #1e40af; line-height: 1.6; }}
                    .credentials-container {{ background: #f8fafc; border: 2px solid #e2e8f0; border-radius: 8px; padding: 28px; margin: 32px 0; }}
                    .credentials-container h3 {{ font-size: 18px; font-weight: 600; color: #1e293b; margin: 0 0 20px 0; }}
                    .credential-row {{ display: flex; justify-content: space-between; align-items: center; padding: 16px 0; border-bottom: 1px solid #e2e8f0; }}
                    .credential-row:last-child {{ border-bottom: none; }}
                    .credential-label {{ font-size: 14px; font-weight: 600; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px; }}
                    .credential-value {{ font-family: 'SF Mono', 'Monaco', 'Cascadia Code', 'Roboto Mono', monospace; font-size: 16px; font-weight: 600; color: #1e3a8a; background: #ffffff; padding: 8px 16px; border-radius: 6px; border: 1px solid #cbd5e1; }}
                    .warning-box {{ background: #fffbeb; border-left: 4px solid #f59e0b; padding: 24px; margin: 30px 0; border-radius: 6px; }}
                    .warning-box strong {{ display: block; font-size: 16px; color: #92400e; margin-bottom: 8px; font-weight: 600; }}
                    .warning-box p {{ margin: 0; font-size: 15px; color: #78350f; line-height: 1.6; }}
                    .cta-button {{ display: inline-block; padding: 16px 40px; background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); color: #ffffff; text-decoration: none; border-radius: 8px; margin: 32px 0; font-weight: 600; font-size: 16px; text-align: center; box-shadow: 0 4px 12px rgba(30, 58, 138, 0.25); transition: all 0.3s ease; }}
                    .cta-button:hover {{ box-shadow: 0 6px 20px rgba(30, 58, 138, 0.35); transform: translateY(-1px); }}
                    .help-box {{ background: #f0fdf4; border-left: 4px solid #22c55e; padding: 24px; margin: 30px 0; border-radius: 6px; }}
                    .help-box strong {{ display: block; font-size: 16px; color: #166534; margin-bottom: 8px; font-weight: 600; }}
                    .help-box p {{ margin: 0; font-size: 15px; color: #15803d; line-height: 1.6; }}
                    .email-footer {{ background-color: #f8fafc; padding: 40px; text-align: center; border-top: 1px solid #e2e8f0; }}
                    .email-footer p {{ font-size: 13px; color: #64748b; margin: 8px 0; line-height: 1.6; }}
                    .email-footer .copyright {{ font-weight: 600; color: #475569; }}
                    .divider {{ height: 1px; background: linear-gradient(90deg, transparent, #e2e8f0, transparent); margin: 40px 0; }}
                    @media only screen and (max-width: 600px) {{
                        .email-body {{ padding: 40px 30px; }}
                        .email-header {{ padding: 40px 30px; }}
                        .email-header h1 {{ font-size: 28px; }}
                        .email-body h2 {{ font-size: 22px; }}
                        .credential-row {{ flex-direction: column; align-items: flex-start; gap: 8px; }}
                        .credential-value {{ width: 100%; }}
                    }}
                </style>
            </head>
            <body>
                <div style="background-color: #f4f6f9; padding: 40px 20px;">
                    <div class="email-wrapper">
                        <div class="email-header">
                            <h1>Programador Musical</h1>
                            <p>Sistema Profesional de Programación Musical</p>
                        </div>
                        <div class="email-body">
                            <h2>Estimado/a {nombre},</h2>
                            <p>Nos complace darle la bienvenida a <strong>Programador Musical</strong>, la plataforma empresarial líder para la gestión y programación de contenido musical.</p>
                            
                            <div class="info-box">
                                <strong>Cuenta Creada Exitosamente</strong>
                                <p>Su cuenta ha sido configurada y está lista para usar. Ya puede acceder al sistema y comenzar a gestionar su programación musical de manera profesional.</p>
                            </div>
                            
                            <div class="credentials-container">
                                <h3>Credenciales de Acceso</h3>
                                <div class="credential-row">
                                    <span class="credential-label">Correo Electrónico</span>
                                    <span class="credential-value">{email}</span>
                                </div>
                                <div class="credential-row">
                                    <span class="credential-label">Contraseña Temporal</span>
                                    <span class="credential-value">{temporary_password}</span>
                                </div>
                            </div>
                            
                            <div class="warning-box">
                                <strong>Importante - Seguridad</strong>
                                <p>Por razones de seguridad, debe cambiar esta contraseña temporal en su primer inicio de sesión. Esta contraseña es temporal y expirará en 7 días. Le recomendamos crear una contraseña segura y única.</p>
                            </div>
                            
                            <div style="text-align: center;">
                                <a href="{frontend_url}/auth/login" class="cta-button">Iniciar Sesión</a>
                            </div>
                            
                            <div class="divider"></div>
                            
                            <div class="help-box">
                                <strong>¿Necesita Asistencia?</strong>
                                <p>Si tiene alguna pregunta, necesita ayuda con la configuración inicial, o tiene alguna consulta sobre el sistema, nuestro equipo de soporte está disponible para asistirle. No dude en contactar al administrador del sistema.</p>
                            </div>
                        </div>
                        <div class="email-footer">
                            <p class="copyright">© 2025 Programador Musical. Todos los derechos reservados.</p>
                            <p>Este es un mensaje automático generado por el sistema. Por favor, no responda a este correo electrónico.</p>
                            <p style="margin-top: 20px; font-size: 12px; color: #94a3b8;">Si recibió este correo por error, por favor ignore este mensaje.</p>
                        </div>
                    </div>
                </div>
            </body>
            </html>
            """
            
            body_text = f"""
Bienvenido a Programador Musical - Credenciales de Acceso

Estimado/a {nombre},

Nos complace darle la bienvenida a Programador Musical, la plataforma empresarial líder para la gestión y programación de contenido musical.

CUENTA CREADA EXITOSAMENTE
Su cuenta ha sido configurada y está lista para usar. Ya puede acceder al sistema y comenzar a gestionar su programación musical de manera profesional.

CREDENCIALES DE ACCESO:

Correo Electrónico: {email}
Contraseña Temporal: {temporary_password}

IMPORTANTE - SEGURIDAD
Por razones de seguridad, debe cambiar esta contraseña temporal en su primer inicio de sesión. Esta contraseña es temporal y expirará en 7 días. Le recomendamos crear una contraseña segura y única.

Para acceder al sistema, visite: {frontend_url}/auth/login

¿NECESITA ASISTENCIA?
Si tiene alguna pregunta, necesita ayuda con la configuración inicial, o tiene alguna consulta sobre el sistema, nuestro equipo de soporte está disponible para asistirle. No dude en contactar al administrador del sistema.

© 2025 Programador Musical. Todos los derechos reservados.

Este es un mensaje automático generado por el sistema. Por favor, no responda a este correo electrónico.
Si recibió este correo por error, por favor ignore este mensaje.
            """
            
            # Enviar email usando SES
            response = self.ses_client.send_email(
                Source=from_email,  # Usar el email remitente configurado
                Destination={'ToAddresses': [email]},
                Message={
                    'Subject': {'Data': subject, 'Charset': 'UTF-8'},
                    'Body': {
                        'Text': {'Data': body_text, 'Charset': 'UTF-8'},
                        'Html': {'Data': body_html, 'Charset': 'UTF-8'}
                    }
                }
            )
            

            return {
                'sent': True,
                'message': f'Email de invitación enviado exitosamente a {email}',
                'message_id': response['MessageId']
            }
            
        except self.ses_client.exceptions.MessageRejected as e:
            return {
                'sent': False,
                'message': 'Email rechazado por SES',
                'reason': 'message_rejected',
                'error': str(e)
            }
        except Exception as e:
            return {
                'sent': False,
                'message': f'Error enviando email: {str(e)}',
                'reason': 'error_envio',
                'error': str(e)
            }
    
    def send_account_deletion_email(self, email: str, nombre: str):
        """
        Envía email de confirmación cuando se elimina una cuenta
        """
        if not self.ses_client:

            return
        
        try:
            # Verificar que el email remitente esté verificado en SES
            from_email = settings.SES_FROM_EMAIL
            verified_emails = self.ses_client.list_verified_email_addresses()
            verified_list = verified_emails.get('VerifiedEmailAddresses', [])
            
            if from_email not in verified_list:

                return
            
            # En modo sandbox, el email destino también debe estar verificado
            if email not in verified_list:

                return
            
            subject = "Confirmación: Cuenta Eliminada - Programador Musical"
            body_html = f"""
            <!DOCTYPE html>
            <html lang="es">
            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <title>Cuenta Eliminada - Programador Musical</title>
                <style>
                    * {{ margin: 0; padding: 0; box-sizing: border-box; }}
                    body {{ font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, 'Noto Sans', sans-serif; line-height: 1.7; color: #1a1a1a; margin: 0; padding: 0; background-color: #f4f6f9; -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale; }}
                    .email-wrapper {{ max-width: 650px; margin: 0 auto; background-color: #ffffff; }}
                    .email-header {{ background: linear-gradient(135deg, #6b7280 0%, #9ca3af 100%); color: #ffffff; padding: 50px 40px; text-align: center; }}
                    .email-header h1 {{ font-size: 32px; font-weight: 700; letter-spacing: -0.5px; margin: 0 0 8px 0; }}
                    .email-header p {{ font-size: 16px; opacity: 0.95; margin: 0; font-weight: 400; }}
                    .email-body {{ padding: 50px 40px; background-color: #ffffff; }}
                    .email-body h2 {{ font-size: 24px; font-weight: 600; color: #1e293b; margin: 0 0 20px 0; line-height: 1.3; }}
                    .email-body p {{ font-size: 16px; color: #475569; margin: 0 0 20px 0; line-height: 1.7; }}
                    .warning-box {{ background: #fef2f2; border-left: 4px solid #dc2626; padding: 24px; margin: 30px 0; border-radius: 6px; }}
                    .warning-box strong {{ display: block; font-size: 16px; color: #991b1b; margin-bottom: 12px; font-weight: 600; }}
                    .warning-box p {{ margin: 0; font-size: 15px; color: #7f1d1d; line-height: 1.6; }}
                    .info-box {{ background: #f8fafc; border-left: 4px solid #64748b; padding: 24px; margin: 30px 0; border-radius: 6px; }}
                    .info-box p {{ margin: 0; font-size: 15px; color: #475569; line-height: 1.6; }}
                    .email-footer {{ background-color: #f8fafc; padding: 40px; text-align: center; border-top: 1px solid #e2e8f0; }}
                    .email-footer p {{ font-size: 13px; color: #64748b; margin: 8px 0; line-height: 1.6; }}
                    .email-footer .copyright {{ font-weight: 600; color: #475569; }}
                    @media only screen and (max-width: 600px) {{
                        .email-body {{ padding: 40px 30px; }}
                        .email-header {{ padding: 40px 30px; }}
                        .email-header h1 {{ font-size: 28px; }}
                        .email-body h2 {{ font-size: 22px; }}
                    }}
                </style>
            </head>
            <body>
                <div style="background-color: #f4f6f9; padding: 40px 20px;">
                    <div class="email-wrapper">
                        <div class="email-header">
                            <h1>Programador Musical</h1>
                            <p>Sistema Profesional de Programación Musical</p>
                        </div>
                        <div class="email-body">
                            <h2>Estimado/a {nombre},</h2>
                            <p>Le confirmamos que su cuenta en <strong>Programador Musical</strong> ha sido eliminada exitosamente del sistema.</p>
                            
                            <div class="warning-box">
                                <strong>Eliminación Completa de Datos</strong>
                                <p>Todos sus datos personales, configuraciones y contenido asociado a su cuenta han sido eliminados permanentemente del sistema. Esta acción no puede ser revertida.</p>
                            </div>
                            
                            <div class="info-box">
                                <p>Si necesita recuperar su cuenta o tiene alguna consulta sobre esta eliminación, debe contactar inmediatamente al administrador del sistema. Tenga en cuenta que la recuperación de datos puede no ser posible una vez completada la eliminación.</p>
                            </div>
                            
                            <p>Agradecemos haber sido parte de nuestra plataforma y le deseamos lo mejor en sus proyectos futuros.</p>
                            
                            <p style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #e2e8f0; color: #dc2626; font-weight: 600;">Si no solicitó esta eliminación, contacte inmediatamente al administrador del sistema para reportar esta actividad.</p>
                        </div>
                        <div class="email-footer">
                            <p class="copyright">© 2025 Programador Musical. Todos los derechos reservados.</p>
                            <p>Este es un mensaje automático generado por el sistema. Por favor, no responda a este correo electrónico.</p>
                            <p style="margin-top: 20px; font-size: 12px; color: #94a3b8;">Si no solicitó esta eliminación, contacte inmediatamente al administrador del sistema.</p>
                        </div>
                    </div>
                </div>
            </body>
            </html>
            """
            
            body_text = f"""
Confirmación: Cuenta Eliminada - Programador Musical

Estimado/a {nombre},

Le confirmamos que su cuenta en Programador Musical ha sido eliminada exitosamente del sistema.

ELIMINACIÓN COMPLETA DE DATOS
Todos sus datos personales, configuraciones y contenido asociado a su cuenta han sido eliminados permanentemente del sistema. Esta acción no puede ser revertida.

Si necesita recuperar su cuenta o tiene alguna consulta sobre esta eliminación, debe contactar inmediatamente al administrador del sistema. Tenga en cuenta que la recuperación de datos puede no ser posible una vez completada la eliminación.

Agradecemos haber sido parte de nuestra plataforma y le deseamos lo mejor en sus proyectos futuros.

IMPORTANTE: Si no solicitó esta eliminación, contacte inmediatamente al administrador del sistema para reportar esta actividad.

© 2025 Programador Musical. Todos los derechos reservados.

Este es un mensaje automático generado por el sistema. Por favor, no responda a este correo electrónico.
Si no solicitó esta eliminación, contacte inmediatamente al administrador del sistema.
            """
            
            # Enviar email usando SES
            from_email = settings.SES_FROM_EMAIL
            response = self.ses_client.send_email(
                Source=from_email,  # Debe estar verificado en SES
                Destination={'ToAddresses': [email]},
                Message={
                    'Subject': {'Data': subject, 'Charset': 'UTF-8'},
                    'Body': {
                        'Text': {'Data': body_text, 'Charset': 'UTF-8'},
                        'Html': {'Data': body_html, 'Charset': 'UTF-8'}
                    }
                }
            )
            

            
        except Exception as e:
             pass
    
    def send_password_reset_email(self, email: str, nombre: str, reset_code: str):
        """
        Envía email de recuperación de contraseña usando Amazon SES
        """
        if not self.ses_client:
            return {
                'sent': False,
                'message': 'SES no está configurado',
                'reason': 'SES no disponible'
            }
        
        try:
            from_email = settings.SES_FROM_EMAIL
            
            # Verificar remitente
            remitente_attrs = self.ses_client.get_identity_verification_attributes(
                Identities=[from_email]
            )
            remitente_status = remitente_attrs.get('VerificationAttributes', {}).get(from_email, {}).get('VerificationStatus', 'NotFound')
            
            if remitente_status != 'Success':
                return {
                    'sent': False,
                    'message': f'Email remitente {from_email} no verificado en SES',
                    'reason': 'remitente_no_verificado'
                }
            
            # Verificar destino en modo sandbox
            if not settings.SES_PRODUCTION_MODE:
                destino_attrs = self.ses_client.get_identity_verification_attributes(
                    Identities=[email]
                )
                destino_status = destino_attrs.get('VerificationAttributes', {}).get(email, {}).get('VerificationStatus', 'NotFound')
                
                if destino_status != 'Success':
                    return {
                        'sent': False,
                        'message': f'Email destino {email} no verificado en SES (modo sandbox)',
                        'reason': 'destino_no_verificado'
                    }
            
            frontend_url = settings.FRONTEND_URL
            subject = "Recuperación de Contraseña - Programador Musical"
            
            body_html = f"""
            <!DOCTYPE html>
            <html lang="es">
            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <title>Recuperación de Contraseña - Programador Musical</title>
                <style>
                    * {{ margin: 0; padding: 0; box-sizing: border-box; }}
                    body {{ font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, 'Noto Sans', sans-serif; line-height: 1.7; color: #1a1a1a; margin: 0; padding: 0; background-color: #f4f6f9; -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale; }}
                    .email-wrapper {{ max-width: 650px; margin: 0 auto; background-color: #ffffff; }}
                    .email-header {{ background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); color: #ffffff; padding: 50px 40px; text-align: center; }}
                    .email-header h1 {{ font-size: 32px; font-weight: 700; letter-spacing: -0.5px; margin: 0 0 8px 0; }}
                    .email-header p {{ font-size: 16px; opacity: 0.95; margin: 0; font-weight: 400; }}
                    .email-body {{ padding: 50px 40px; background-color: #ffffff; }}
                    .email-body h2 {{ font-size: 24px; font-weight: 600; color: #1e293b; margin: 0 0 20px 0; line-height: 1.3; }}
                    .email-body p {{ font-size: 16px; color: #475569; margin: 0 0 20px 0; line-height: 1.7; }}
                    .info-box {{ background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%); border-left: 4px solid #3b82f6; padding: 24px; margin: 30px 0; border-radius: 6px; }}
                    .info-box strong {{ display: block; font-size: 16px; color: #1e40af; margin-bottom: 8px; font-weight: 600; }}
                    .info-box p {{ margin: 0; font-size: 15px; color: #1e40af; line-height: 1.6; }}
                    .warning-box {{ background: #fffbeb; border-left: 4px solid #f59e0b; padding: 24px; margin: 30px 0; border-radius: 6px; }}
                    .warning-box strong {{ display: block; font-size: 16px; color: #92400e; margin-bottom: 8px; font-weight: 600; }}
                    .warning-box p {{ margin: 0; font-size: 15px; color: #78350f; line-height: 1.6; }}
                    .cta-button {{ display: inline-block; padding: 16px 40px; background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); color: #ffffff; text-decoration: none; border-radius: 8px; margin: 32px 0; font-weight: 600; font-size: 16px; text-align: center; box-shadow: 0 4px 12px rgba(30, 58, 138, 0.25); transition: all 0.3s ease; }}
                    .cta-button:hover {{ box-shadow: 0 6px 20px rgba(30, 58, 138, 0.35); transform: translateY(-1px); }}
                    .email-footer {{ background-color: #f8fafc; padding: 40px; text-align: center; border-top: 1px solid #e2e8f0; }}
                    .email-footer p {{ font-size: 13px; color: #64748b; margin: 8px 0; line-height: 1.6; }}
                    .email-footer .copyright {{ font-weight: 600; color: #475569; }}
                    .link-text {{ color: #3b82f6; text-decoration: none; word-break: break-all; }}
                    @media only screen and (max-width: 600px) {{
                        .email-body {{ padding: 40px 30px; }}
                        .email-header {{ padding: 40px 30px; }}
                        .email-header h1 {{ font-size: 28px; }}
                        .email-body h2 {{ font-size: 22px; }}
                    }}
                </style>
            </head>
            <body>
                <div style="background-color: #f4f6f9; padding: 40px 20px;">
                    <div class="email-wrapper">
                        <div class="email-header">
                            <h1>Programador Musical</h1>
                            <p>Sistema Profesional de Programación Musical</p>
                        </div>
                        <div class="email-body">
                            <h2>Estimado/a {nombre},</h2>
                            <p>Hemos recibido una solicitud para restablecer la contraseña de su cuenta en <strong>Programador Musical</strong>.</p>
                            
                            <div class="info-box">
                                <strong>Instrucciones para Restablecer su Contraseña</strong>
                                <p>Para completar el proceso de recuperación, revise su bandeja de entrada (incluyendo la carpeta de spam) para encontrar el código de verificación enviado por nuestro sistema. El código de verificación es de 6 dígitos y ha sido enviado a esta dirección de correo electrónico.</p>
                            </div>
                            
                            <div class="warning-box">
                                <strong>Importante - Seguridad</strong>
                                <p>El código de verificación expirará en 15 minutos por razones de seguridad. Si no solicitó este cambio de contraseña, ignore este correo electrónico y contacte inmediatamente al administrador del sistema para reportar esta actividad sospechosa.</p>
                            </div>
                            
                            <div style="text-align: center;">
                                <a href="{frontend_url}/auth/login?mode=reset-password" class="cta-button">Restablecer Contraseña</a>
                            </div>
                            
                            <p style="color: #64748b; font-size: 14px; margin-top: 30px;">Si el botón no funciona, copie y pegue el siguiente enlace en su navegador:<br>
                            <a href="{frontend_url}/auth/login?mode=reset-password" class="link-text">{frontend_url}/auth/login?mode=reset-password</a></p>
                        </div>
                        <div class="email-footer">
                            <p class="copyright">© 2025 Programador Musical. Todos los derechos reservados.</p>
                            <p>Este es un mensaje automático generado por el sistema. Por favor, no responda a este correo electrónico.</p>
                            <p style="margin-top: 20px; font-size: 12px; color: #94a3b8;">Si no solicitó este cambio, ignore este mensaje o contacte al administrador del sistema.</p>
                        </div>
                    </div>
                </div>
            </body>
            </html>
            """
            
            body_text = f"""
Recuperación de Contraseña - Programador Musical

Estimado/a {nombre},

Hemos recibido una solicitud para restablecer la contraseña de su cuenta en Programador Musical.

INSTRUCCIONES PARA RESTABLECER SU CONTRASEÑA
Para completar el proceso de recuperación, revise su bandeja de entrada (incluyendo la carpeta de spam) para encontrar el código de verificación enviado por nuestro sistema. El código de verificación es de 6 dígitos y ha sido enviado a esta dirección de correo electrónico.

IMPORTANTE - SEGURIDAD
El código de verificación expirará en 15 minutos por razones de seguridad. Si no solicitó este cambio de contraseña, ignore este correo electrónico y contacte inmediatamente al administrador del sistema para reportar esta actividad sospechosa.

Para restablecer su contraseña, visite: {frontend_url}/auth/login?mode=reset-password

© 2025 Programador Musical. Todos los derechos reservados.

Este es un mensaje automático generado por el sistema. Por favor, no responda a este correo electrónico.
Si no solicitó este cambio, ignore este mensaje o contacte al administrador del sistema.
            """
            
            response = self.ses_client.send_email(
                Source=from_email,
                Destination={'ToAddresses': [email]},
                Message={
                    'Subject': {'Data': subject, 'Charset': 'UTF-8'},
                    'Body': {
                        'Text': {'Data': body_text, 'Charset': 'UTF-8'},
                        'Html': {'Data': body_html, 'Charset': 'UTF-8'}
                    }
                }
            )
            
            return {
                'sent': True,
                'message': f'Email de recuperación enviado exitosamente a {email}',
                'message_id': response['MessageId']
            }
            
        except Exception as e:
            return {
                'sent': False,
                'message': f'Error enviando email: {str(e)}',
                'reason': 'error_envio',
                'error': str(e)
            }
    
    def send_account_deactivation_email(self, email: str, nombre: str):
        """
        Envía email de notificación cuando se desactiva una cuenta
        """
        if not self.ses_client:
            return {
                'sent': False,
                'message': 'SES no está configurado',
                'reason': 'SES no disponible'
            }
        
        try:
            from_email = settings.SES_FROM_EMAIL
            
            # Verificar remitente
            remitente_attrs = self.ses_client.get_identity_verification_attributes(
                Identities=[from_email]
            )
            remitente_status = remitente_attrs.get('VerificationAttributes', {}).get(from_email, {}).get('VerificationStatus', 'NotFound')
            
            if remitente_status != 'Success':
                return {
                    'sent': False,
                    'message': f'Email remitente {from_email} no verificado en SES',
                    'reason': 'remitente_no_verificado'
                }
            
            # Verificar destino en modo sandbox
            if not settings.SES_PRODUCTION_MODE:
                destino_attrs = self.ses_client.get_identity_verification_attributes(
                    Identities=[email]
                )
                destino_status = destino_attrs.get('VerificationAttributes', {}).get(email, {}).get('VerificationStatus', 'NotFound')
                
                if destino_status != 'Success':
                    return {
                        'sent': False,
                        'message': f'Email destino {email} no verificado en SES (modo sandbox)',
                        'reason': 'destino_no_verificado'
                    }
            
            frontend_url = settings.FRONTEND_URL
            subject = "Notificación: Cuenta Desactivada - Programador Musical"
            
            body_html = f"""
            <!DOCTYPE html>
            <html lang="es">
            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <title>Cuenta Desactivada - Programador Musical</title>
                <style>
                    * {{ margin: 0; padding: 0; box-sizing: border-box; }}
                    body {{ font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, 'Noto Sans', sans-serif; line-height: 1.7; color: #1a1a1a; margin: 0; padding: 0; background-color: #f4f6f9; -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale; }}
                    .email-wrapper {{ max-width: 650px; margin: 0 auto; background-color: #ffffff; }}
                    .email-header {{ background: linear-gradient(135deg, #dc2626 0%, #ef4444 100%); color: #ffffff; padding: 50px 40px; text-align: center; }}
                    .email-header h1 {{ font-size: 32px; font-weight: 700; letter-spacing: -0.5px; margin: 0 0 8px 0; }}
                    .email-header p {{ font-size: 16px; opacity: 0.95; margin: 0; font-weight: 400; }}
                    .email-body {{ padding: 50px 40px; background-color: #ffffff; }}
                    .email-body h2 {{ font-size: 24px; font-weight: 600; color: #1e293b; margin: 0 0 20px 0; line-height: 1.3; }}
                    .email-body p {{ font-size: 16px; color: #475569; margin: 0 0 20px 0; line-height: 1.7; }}
                    .warning-box {{ background: #fef2f2; border-left: 4px solid #dc2626; padding: 24px; margin: 30px 0; border-radius: 6px; }}
                    .warning-box strong {{ display: block; font-size: 16px; color: #991b1b; margin-bottom: 12px; font-weight: 600; }}
                    .warning-box p {{ margin: 0 0 12px 0; font-size: 15px; color: #7f1d1d; line-height: 1.6; }}
                    .info-box {{ background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%); border-left: 4px solid #3b82f6; padding: 24px; margin: 30px 0; border-radius: 6px; }}
                    .info-box strong {{ display: block; font-size: 16px; color: #1e40af; margin-bottom: 12px; font-weight: 600; }}
                    .info-box ul {{ margin: 0; padding-left: 20px; }}
                    .info-box li {{ margin: 8px 0; font-size: 15px; color: #1e40af; line-height: 1.6; }}
                    .email-footer {{ background-color: #f8fafc; padding: 40px; text-align: center; border-top: 1px solid #e2e8f0; }}
                    .email-footer p {{ font-size: 13px; color: #64748b; margin: 8px 0; line-height: 1.6; }}
                    .email-footer .copyright {{ font-weight: 600; color: #475569; }}
                    @media only screen and (max-width: 600px) {{
                        .email-body {{ padding: 40px 30px; }}
                        .email-header {{ padding: 40px 30px; }}
                        .email-header h1 {{ font-size: 28px; }}
                        .email-body h2 {{ font-size: 22px; }}
                    }}
                </style>
            </head>
            <body>
                <div style="background-color: #f4f6f9; padding: 40px 20px;">
                    <div class="email-wrapper">
                        <div class="email-header">
                            <h1>Programador Musical</h1>
                            <p>Sistema Profesional de Programación Musical</p>
                        </div>
                        <div class="email-body">
                            <h2>Estimado/a {nombre},</h2>
                            <p>Le informamos que su cuenta en <strong>Programador Musical</strong> ha sido desactivada por un administrador del sistema.</p>
                            
                            <div class="warning-box">
                                <strong>Acceso Restringido</strong>
                                <p>Su cuenta ha sido desactivada y ya no podrá iniciar sesión en el sistema hasta que un administrador reactive su cuenta.</p>
                            </div>
                            
                            <div class="info-box">
                                <strong>¿Qué significa esto?</strong>
                                <ul>
                                    <li>Su información permanece almacenada en el sistema de forma segura</li>
                                    <li>No podrá acceder a ninguna funcionalidad del sistema hasta la reactivación</li>
                                    <li>Para reactivar su cuenta, debe contactar al administrador del sistema</li>
                                    <li>Si considera que esto es un error, contacte inmediatamente al equipo de soporte</li>
                                </ul>
                            </div>
                            
                            <p>Si tiene alguna pregunta sobre esta acción o necesita asistencia, no dude en contactar al administrador del sistema o al equipo de soporte técnico.</p>
                        </div>
                        <div class="email-footer">
                            <p class="copyright">© 2025 Programador Musical. Todos los derechos reservados.</p>
                            <p>Este es un mensaje automático generado por el sistema. Por favor, no responda a este correo electrónico.</p>
                            <p style="margin-top: 20px; font-size: 12px; color: #94a3b8;">Si considera que esta acción es un error, contacte inmediatamente al administrador del sistema.</p>
                        </div>
                    </div>
                </div>
            </body>
            </html>
            """
            
            body_text = f"""
Notificación: Cuenta Desactivada - Programador Musical

Estimado/a {nombre},

Le informamos que su cuenta en Programador Musical ha sido desactivada por un administrador del sistema.

ACCESO RESTRINGIDO
Su cuenta ha sido desactivada y ya no podrá iniciar sesión en el sistema hasta que un administrador reactive su cuenta.

¿QUÉ SIGNIFICA ESTO?
• Su información permanece almacenada en el sistema de forma segura
• No podrá acceder a ninguna funcionalidad del sistema hasta la reactivación
• Para reactivar su cuenta, debe contactar al administrador del sistema
• Si considera que esto es un error, contacte inmediatamente al equipo de soporte

Si tiene alguna pregunta sobre esta acción o necesita asistencia, no dude en contactar al administrador del sistema o al equipo de soporte técnico.

© 2025 Programador Musical. Todos los derechos reservados.

Este es un mensaje automático generado por el sistema. Por favor, no responda a este correo electrónico.
Si considera que esta acción es un error, contacte inmediatamente al administrador del sistema.
            """
            
            response = self.ses_client.send_email(
                Source=from_email,
                Destination={'ToAddresses': [email]},
                Message={
                    'Subject': {'Data': subject, 'Charset': 'UTF-8'},
                    'Body': {
                        'Text': {'Data': body_text, 'Charset': 'UTF-8'},
                        'Html': {'Data': body_html, 'Charset': 'UTF-8'}
                    }
                }
            )
            
            return {
                'sent': True,
                'message': f'Email de desactivación enviado exitosamente a {email}',
                'message_id': response['MessageId']
            }
            
        except Exception as e:
            return {
                'sent': False,
                'message': f'Error enviando email: {str(e)}',
                'reason': 'error_envio',
                'error': str(e)
            }
    
    def update_user_attributes(self, cognito_user_id: str, attributes: dict):
        """
        Actualiza atributos del usuario en Cognito
        attributes: dict con nombres de atributos de Cognito (name, email, etc.)
        """
        if not self.enabled:
            raise HTTPException(
                status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                detail="Cognito no está configurado"
            )
        
        try:
            user_attributes = [
                {'Name': key, 'Value': str(value)}
                for key, value in attributes.items()
            ]
            
            if not user_attributes:
                return
            
            self.cognito_client.admin_update_user_attributes(
                UserPoolId=self.user_pool_id,
                Username=cognito_user_id,
                UserAttributes=user_attributes
            )
            

            
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Error actualizando atributos: {str(e)}"
            )
    
    def change_user_password(self, cognito_user_id: str, new_password: str, permanent: bool = True):
        """
        Cambia la contraseña de un usuario en Cognito (requiere permisos de admin)
        """
        if not self.enabled:
            raise HTTPException(
                status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                detail="Cognito no está configurado"
            )
        
        try:
            self.cognito_client.admin_set_user_password(
                UserPoolId=self.user_pool_id,
                Username=cognito_user_id,
                Password=new_password,
                Permanent=permanent
            )
            

            
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Error cambiando contraseña: {str(e)}"
            )
    
    def delete_user(self, cognito_user_id: str):
        """
        Elimina un usuario de Cognito
        """
        if not self.enabled:
            raise HTTPException(
                status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                detail="Cognito no está configurado"
            )
        
        try:
            self.cognito_client.admin_delete_user(
                UserPoolId=self.user_pool_id,
                Username=cognito_user_id
            )
            

            
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Error eliminando usuario: {str(e)}"
            )


# Instancia global de CognitoAuth
cognito_auth = CognitoAuth()


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
) -> Usuario:
    """
    Dependencia para obtener el usuario actual desde el token de Cognito
    """
    try:
        token = credentials.credentials
        
        # Verificar token con Cognito
        payload = cognito_auth.verify_token(token)
        cognito_user_id = payload.get("sub")
        
        if not cognito_user_id:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Token inválido: falta sub"
            )
        
        # Buscar usuario en BD
        # Manejar caso cuando organizacion_id no existe en la base de datos
        try:
            usuario = db.query(Usuario).filter(
                Usuario.cognito_user_id == cognito_user_id
            ).first()
        except Exception as db_error:
            # Si falla porque organizacion_id no existe, intentar consulta sin ese campo
            # Esto puede ocurrir durante la migración
            import traceback
            error_str = str(db_error).lower()
            error_trace = traceback.format_exc().lower()
            
            # Verificar si el error es por columna faltante
            if 'organizacion_id' in error_str or 'organizacion_id' in error_trace or 'column' in error_str:
                # La columna no existe, intentar consulta básica
                try:
                    # Consulta directa sin usar el modelo completo
                    # Usar text() para evitar SQL injection
                    result = db.execute(
                        text("SELECT id, cognito_user_id, email, nombre, rol, activo FROM usuarios WHERE cognito_user_id = :cognito_user_id"),
                        {"cognito_user_id": cognito_user_id}
                    ).first()
                    if result:
                        # Crear objeto Usuario manualmente sin organizacion_id
                        # Usar setattr para evitar problemas con campos requeridos
                        usuario = Usuario.__new__(Usuario)
                        usuario.id = result[0]
                        usuario.cognito_user_id = result[1]
                        usuario.email = result[2]
                        usuario.nombre = result[3]
                        usuario.rol = result[4]
                        usuario.activo = result[5]
                        # organizacion_id no existe, no asignarlo
                    else:
                        usuario = None
                except Exception as inner_error:
                    # Si también falla, el usuario no existe o hay otro problema
                    import logging
                    logger = logging.getLogger(__name__)
                    logger.error(f"Error consultando usuario sin organizacion_id: {str(inner_error)}")
                    usuario = None
            else:
                # Otro tipo de error, re-lanzarlo
                raise
        
        # Si no existe, crearlo (sincronización automática)
        if not usuario:
            # En access tokens, el email puede no estar presente
            # Intentar obtenerlo de diferentes campos
            email = payload.get("email") or payload.get("cognito:username") or payload.get("username")
            
            # Si el email no es válido (no contiene @), intentar obtenerlo del username
            if email and "@" not in email:
                # El username puede ser el email si el usuario se registró con email
                # Intentar obtener el email real desde Cognito usando el username
                try:
                    if cognito_auth.enabled and cognito_auth.cognito_client:
                        user_info = cognito_auth.cognito_client.admin_get_user(
                            UserPoolId=cognito_auth.user_pool_id,
                            Username=cognito_user_id
                        )
                        # Buscar el atributo email en los atributos del usuario
                        for attr in user_info.get("UserAttributes", []):
                            if attr.get("Name") == "email":
                                email = attr.get("Value")
                                break
                except Exception:
                    pass  # Si falla, usar el username como email
            
            if not email or "@" not in email:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="Token inválido: no se pudo obtener el email del usuario"
                )
            
            nombre = payload.get("name") or payload.get("cognito:username") or email.split("@")[0]
            
            # Obtener rol de grupos de Cognito o atributo personalizado
            groups = payload.get("cognito:groups", [])
            if isinstance(groups, str):
                groups = [groups]
            elif not isinstance(groups, list):
                groups = []
            
            if "admin" in groups:
                rol = "admin"
            elif "manager" in groups:
                rol = "manager"
            else:
                rol = payload.get("custom:rol", "operador")
            
            try:
                # Intentar obtener o crear organización para el usuario
                # Si la tabla organizaciones no existe, la migración aún no se ha ejecutado
                from app.models.auth import Organizacion
                try:
                    # Intentar consultar la tabla organizaciones
                    # Si no existe, esto lanzará una excepción
                    test_org = db.query(Organizacion).first()
                    
                    # Si llegamos aquí, la tabla existe, proceder normalmente
                    organizacion = db.query(Organizacion).filter(
                        Organizacion.nombre == "Organización Default"
                    ).first()
                    
                    if not organizacion:
                        # Si no existe organización default, crear una nueva para este usuario
                        # (esto solo debería pasar en casos edge)
                        if rol == "admin":
                            organizacion = Organizacion(
                                nombre=f"Organización de {nombre}",
                                activa=True
                            )
                            db.add(organizacion)
                            db.flush()  # Para obtener el ID sin commit
                        else:
                            # Usuarios no-admin deben ser invitados primero
                            raise HTTPException(
                                status_code=status.HTTP_403_FORBIDDEN,
                                detail="Tu cuenta no está completamente configurada. Contacta al administrador para que te invite al sistema."
                            )
                    
                    # Crear el usuario con organizacion_id
                    usuario = Usuario(
                        cognito_user_id=cognito_user_id,
                        email=email,
                        nombre=nombre,
                        rol=rol,
                        activo=True,
                        organizacion_id=organizacion.id
                    )
                except Exception as org_error:
                    # Si falla al consultar organizaciones, la migración no se ha ejecutado
                    # Crear usuario sin organizacion_id (durante migración)
                    usuario = Usuario(
                        cognito_user_id=cognito_user_id,
                        email=email,
                        nombre=nombre,
                        rol=rol,
                        activo=True
                    )
                
                db.add(usuario)
                db.commit()
                db.refresh(usuario)
            except Exception as e:
                db.rollback()
                # Si falla por duplicado (email o cognito_user_id), intentar obtenerlo
                # Esto puede pasar si el usuario se creó entre la primera búsqueda y el commit
                usuario = db.query(Usuario).filter(
                    (Usuario.cognito_user_id == cognito_user_id) | (Usuario.email == email)
                ).first()
                
                if not usuario:
                    # Log del error para debugging (sin exponer detalles sensibles)
                    import logging
                    logger = logging.getLogger(__name__)
                    logger.error(f"Error sincronizando usuario {email}: {str(e)}")
                    
                    raise HTTPException(
                        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                        detail="Error sincronizando usuario con la base de datos. Contacta al administrador."
                    )
        
        if not usuario.activo:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Usuario desactivado"
            )
        
        return usuario
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error de autenticación: {str(e)}"
        )


async def get_user_difusoras(
    usuario: Usuario = Depends(get_current_user),
    db: Session = Depends(get_db)
) -> List[str]:
    """
    Obtiene las siglas de difusoras asignadas al usuario.
    Solo retorna difusoras de la organización del usuario (multi-tenancy).
    
    IMPORTANTE: Los administradores tienen acceso automático a TODAS las difusoras
    de su organización, sin necesidad de asignación manual.
    """
    # Manejar caso cuando organizacion_id no existe aún (durante migración)
    try:
        # Intentar acceder a organizacion_id
        # Si no existe en la base de datos, esto lanzará AttributeError
        org_id = usuario.organizacion_id
        
        if not org_id:
            # Si organizacion_id es None, retornar lista vacía
            return []
        
        # Si el usuario es ADMIN, retornar TODAS las difusoras de su organización
        # Los admins no necesitan asignación manual de difusoras
        if usuario.rol == "admin":
            todas_difusoras = db.query(Difusora).filter(
                Difusora.activa == True,
                Difusora.organizacion_id == org_id
            ).all()
            
            difusoras = [d.siglas for d in todas_difusoras]
            return difusoras
        
        # Para usuarios NO-ADMIN (manager, operador), obtener solo las asignadas
        asignaciones = db.query(UsuarioDifusora).filter(
            UsuarioDifusora.usuario_id == usuario.id
        ).join(Difusora).filter(
            Difusora.activa == True,
            Difusora.organizacion_id == org_id  # ← FILTRO POR ORGANIZACIÓN
        ).all()
        
        difusoras = [a.difusora.siglas for a in asignaciones]
        
        # Si el usuario no tiene difusoras asignadas, retornar lista vacía
        # Esto asegura que solo vea datos de su organización
        return difusoras
    except (AttributeError, KeyError):
        # Si organizacion_id no existe en la base de datos, retornar lista vacía
        # Esto evita errores durante la migración
        return []


async def get_user_organizacion(
    usuario: Usuario = Depends(get_current_user)
) -> int:
    """
    Obtiene el ID de la organización del usuario.
    Útil para filtrar datos por organización en endpoints.
    """
    # Manejar caso cuando organizacion_id no existe aún (durante migración)
    if not hasattr(usuario, 'organizacion_id') or not usuario.organizacion_id:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Error de configuración: La migración de base de datos no se ha ejecutado. Contacta al administrador."
        )
    return usuario.organizacion_id


def require_role(*allowed_roles: str):
    """
    Decorador para requerir roles específicos
    """
    def decorator(func):
        async def wrapper(
            usuario: Usuario = Depends(get_current_user),
            *args,
            **kwargs
        ):
            if usuario.rol not in allowed_roles:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail=f"Se requiere uno de los roles: {allowed_roles}"
                )
            return await func(usuario=usuario, *args, **kwargs)
        return wrapper
    return decorator


def filter_by_difusora(
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
) -> List[str]:
    """
    Dependency para obtener las difusoras permitidas para el usuario
    """
    return difusoras_allowed

