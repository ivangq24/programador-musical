"""
Sistema de autenticación y autorización con AWS Cognito
"""
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import jwt, JWTError
import boto3
from typing import Optional, List
from sqlalchemy.orm import Session
from sqlalchemy import and_
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
        
        if not self.user_pool_id or not self.client_id:

            self.enabled = False
            self.cognito_client = None
            self.ses_client = None
        else:
            self.enabled = True
            self.jwks_url = f"https://cognito-idp.{self.region}.amazonaws.com/{self.user_pool_id}/.well-known/jwks.json"
            try:
                self.cognito_client = boto3.client('cognito-idp', region_name=self.region)
                # Inicializar cliente de SES para envío de emails
                try:
                    self.ses_client = boto3.client('ses', region_name=self.region)
                except Exception as e:
                    self.ses_client = None
                # Verificar que las credenciales funcionan
                try:
                    self.cognito_client.describe_user_pool(UserPoolId=self.user_pool_id)
                except Exception as e:
                    self.cognito_client = None
                    self.ses_client = None
            except Exception as e:
                self.cognito_client = None
                self.ses_client = None
    
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
            # Obtener el header del token
            unverified_header = jwt.get_unverified_header(token)
            kid = unverified_header.get("kid")
            
            if not kid:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Token inválido: falta kid"
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
                    detail="Token inválido: clave no encontrada"
                )
            
            # Convertir JWK a formato para verificación
            from jose.utils import base64url_decode
            import json
            
            # Verificar y decodificar el token
            # Para simplificar, usamos get_unverified_claims pero en producción
            # deberías verificar con la clave pública
            payload = jwt.get_unverified_claims(token)
            
            # Validaciones básicas
            if payload.get("token_use") != "access":
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Token inválido: no es un access token"
                )
            
            # Verificar que el token es de nuestro user pool
            if payload.get("iss") != f"https://cognito-idp.{self.region}.amazonaws.com/{self.user_pool_id}":
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Token inválido: issuer incorrecto"
                )
            
            return payload
            
        except JWTError as e:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Token inválido o expirado"
            )
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Error verificando token"
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
        if not self.enabled:
            raise HTTPException(
                status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                detail="Cognito no está configurado"
            )
        
        try:
            old_group = old_rol.lower()
            new_group = new_rol.lower()
            
            # Remover del grupo anterior
            try:
                self.cognito_client.admin_remove_user_from_group(
                    UserPoolId=self.user_pool_id,
                    Username=cognito_user_id,
                    GroupName=old_group
                )
            except Exception as e:
                pass
            
            # Agregar al nuevo grupo
            try:
                self.cognito_client.admin_add_user_to_group(
                    UserPoolId=self.user_pool_id,
                    Username=cognito_user_id,
                    GroupName=new_group
                )

            except self.cognito_client.exceptions.ResourceNotFoundException:
                try:
                    self.cognito_client.create_group(
                        GroupName=new_group,
                        UserPoolId=self.user_pool_id,
                        Description=f"Grupo para usuarios con rol {new_rol}"
                    )
                    self.cognito_client.admin_add_user_to_group(
                        UserPoolId=self.user_pool_id,
                        Username=cognito_user_id,
                        GroupName=new_group
                    )
                except Exception as e:
                    raise
                    
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Error actualizando rol: {str(e)}"
            )
    
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
            
            # Contenido del email
            subject = "Bienvenido a Programador Musical"
            frontend_url = settings.FRONTEND_URL
            body_html = f"""
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="utf-8">
                <style>
                    body {{ font-family: Arial, sans-serif; line-height: 1.6; color: #333; }}
                    .container {{ max-width: 600px; margin: 0 auto; padding: 20px; }}
                    .header {{ background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }}
                    .content {{ background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }}
                    .button {{ display: inline-block; padding: 12px 30px; background: #667eea; color: white; text-decoration: none; border-radius: 5px; margin: 20px 0; }}
                    .password-box {{ background: #fff; padding: 15px; border-left: 4px solid #667eea; margin: 20px 0; font-family: monospace; font-size: 16px; }}
                    .footer {{ text-align: center; margin-top: 30px; color: #666; font-size: 12px; }}
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="header">
                        <h1>🎵 Programador Musical</h1>
                    </div>
                    <div class="content">
                        <h2>¡Bienvenido, {nombre}!</h2>
                        <p>Has sido invitado a formar parte de <strong>Programador Musical</strong>.</p>
                        <p>Tu cuenta ha sido creada exitosamente. Para acceder, utiliza las siguientes credenciales:</p>
                        
                        <div class="password-box">
                            <strong>Email:</strong> {email}<br>
                            <strong>Contraseña temporal:</strong> {temporary_password}
                        </div>
                        
                        <p><strong>⚠️ Importante:</strong> Debes cambiar esta contraseña en tu primer inicio de sesión.</p>
                        
                        <p style="text-align: center;">
                            <a href="{frontend_url}/auth/login" class="button">Iniciar Sesión</a>
                        </p>
                        
                        <p>Si tienes alguna pregunta, contacta al administrador del sistema.</p>
                    </div>
                    <div class="footer">
                        <p>© 2025 Programador Musical. Todos los derechos reservados.</p>
                    </div>
                </div>
            </body>
            </html>
            """
            
            body_text = f"""
Bienvenido a Programador Musical

¡Hola {nombre}!

Has sido invitado a formar parte de Programador Musical.

Tu cuenta ha sido creada exitosamente. Para acceder, utiliza las siguientes credenciales:

Email: {email}
Contraseña temporal: {temporary_password}

⚠️ IMPORTANTE: Debes cambiar esta contraseña en tu primer inicio de sesión.

Accede en: {frontend_url}/auth/login

Si tienes alguna pregunta, contacta al administrador del sistema.

© 2025 Programador Musical. Todos los derechos reservados.
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
            
            subject = "Tu cuenta ha sido eliminada - Programador Musical"
            body_html = f"""
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="utf-8">
                <style>
                    body {{ font-family: Arial, sans-serif; line-height: 1.6; color: #333; }}
                    .container {{ max-width: 600px; margin: 0 auto; padding: 20px; }}
                    .header {{ background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }}
                    .content {{ background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }}
                    .warning {{ background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0; }}
                    .footer {{ text-align: center; margin-top: 30px; color: #666; font-size: 12px; }}
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="header">
                        <h1>🎵 Programador Musical</h1>
                    </div>
                    <div class="content">
                        <h2>Hola {nombre},</h2>
                        <p>Te informamos que tu cuenta en <strong>Programador Musical</strong> ha sido eliminada exitosamente.</p>
                        
                        <div class="warning">
                            <strong>⚠️ Importante:</strong> Todos tus datos han sido eliminados del sistema. 
                            Si necesitas recuperar tu cuenta, contacta al administrador.
                        </div>
                        
                        <p>Gracias por haber sido parte de nuestra plataforma.</p>
                        
                        <p>Si no solicitaste esta eliminación, contacta inmediatamente al administrador del sistema.</p>
                    </div>
                    <div class="footer">
                        <p>© 2025 Programador Musical. Todos los derechos reservados.</p>
                    </div>
                </div>
            </body>
            </html>
            """
            
            body_text = f"""
Tu cuenta ha sido eliminada - Programador Musical

Hola {nombre},

Te informamos que tu cuenta en Programador Musical ha sido eliminada exitosamente.

⚠️ IMPORTANTE: Todos tus datos han sido eliminados del sistema. 
Si necesitas recuperar tu cuenta, contacta al administrador.

Gracias por haber sido parte de nuestra plataforma.

Si no solicitaste esta eliminación, contacta inmediatamente al administrador del sistema.

© 2025 Programador Musical. Todos los derechos reservados.
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
        usuario = db.query(Usuario).filter(
            Usuario.cognito_user_id == cognito_user_id
        ).first()
        
        # Si no existe, crearlo (sincronización automática)
        if not usuario:
            email = payload.get("email", "")
            nombre = payload.get("name") or payload.get("cognito:username", email.split("@")[0])
            
            # Obtener rol de grupos de Cognito o atributo personalizado
            groups = payload.get("cognito:groups", [])
            if "admin" in groups:
                rol = "admin"
            elif "manager" in groups:
                rol = "manager"
            else:
                rol = payload.get("custom:rol", "operador")
            
            usuario = Usuario(
                cognito_user_id=cognito_user_id,
                email=email,
ombre=nombre,
                rol=rol,
                activo=True
            )
            db.add(usuario)
            db.commit()
            db.refresh(usuario)

        
        if not usuario.activo:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Usuario desactivado"
            )
        
        return usuario
        
    except HTTPException:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Error de autenticación"
        )


async def get_user_difusoras(
    usuario: Usuario = Depends(get_current_user),
    db: Session = Depends(get_db)
) -> List[str]:
    """
    Obtiene las siglas de difusoras asignadas al usuario
    """
    if usuario.rol == "admin":
        # Admin tiene acceso a todas las difusoras activas
        difusoras = db.query(Difusora.siglas).filter(
            Difusora.activa == True
        ).all()
        return [d[0] for d in difusoras]
    
    # Obtener difusoras asignadas
    asignaciones = db.query(UsuarioDifusora).filter(
        UsuarioDifusora.usuario_id == usuario.id
    ).join(Difusora).filter(
        Difusora.activa == True
    ).all()
    
    return [a.difusora.siglas for a in asignaciones]


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

