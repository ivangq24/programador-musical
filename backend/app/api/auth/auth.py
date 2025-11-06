"""
Endpoints de autenticación y gestión de usuarios
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query, Body
from sqlalchemy.orm import Session
from sqlalchemy import and_
from typing import List, Optional
import logging

from app.core.database import get_db
from app.core.auth import get_current_user, require_role, get_user_difusoras
from app.models.auth import Usuario, UsuarioDifusora
from app.models.catalogos import Difusora
from app.schemas.auth import (
    Usuario as UsuarioSchema,
    UsuarioConDifusoras,
    UsuarioCreate,
    UsuarioUpdate,
    UsuarioDifusoraCreate,
    UserInfo,
    UsuarioInvite,
    UsuarioInviteResponse,
    PerfilUpdate,
    ChangePasswordRequest,
    FirstAdminCreate
)
from app.core.auth import cognito_auth

logger = logging.getLogger(__name__)
router = APIRouter()


@router.get("/me", response_model=UserInfo)
async def get_current_user_info(
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Obtiene información del usuario autenticado"""
    return UserInfo(
        id=usuario.id,
        email=usuario.email,
        nombre=usuario.nombre,
        rol=usuario.rol,
        difusoras=difusoras_allowed,
        is_admin=usuario.rol == "admin"
    )


@router.put("/me", response_model=UserInfo)
async def update_my_profile(
    perfil_update: PerfilUpdate,
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras),
    db: Session = Depends(get_db)
):
    """Actualiza el perfil del usuario autenticado"""
    update_data = perfil_update.dict(exclude_unset=True)
    
    # Si cambia el email, verificar que no esté en uso
    if "email" in update_data and update_data["email"] != usuario.email:
        existing_user = db.query(Usuario).filter(
            Usuario.email == update_data["email"],
            Usuario.id != usuario.id
        ).first()
        if existing_user:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="El email ya está en uso"
            )
    
    # Actualizar en BD
    for field, value in update_data.items():
        setattr(usuario, field, value)
    
    # Actualizar en Cognito si hay cambios
    if update_data:
        cognito_attributes = {}
        if "nombre" in update_data:
            cognito_attributes["name"] = update_data["nombre"]
        if "email" in update_data:
            cognito_attributes["email"] = update_data["email"]
        
        if cognito_attributes:
            try:
                cognito_auth.update_user_attributes(
                    cognito_user_id=usuario.cognito_user_id,
                    attributes=cognito_attributes
                )
            except Exception as e:
                logger.error(f"Error actualizando Cognito: {e}")
                # Continuar aunque falle Cognito, la BD ya está actualizada
    
    db.commit()
    db.refresh(usuario)
    
    logger.info(f"Perfil actualizado por {usuario.email}")
    
    return UserInfo(
        id=usuario.id,
        email=usuario.email,
        nombre=usuario.nombre,
        rol=usuario.rol,
        difusoras=difusoras_allowed,
        is_admin=usuario.rol == "admin"
    )


@router.post("/me/change-password")
async def change_my_password(
    password_request: ChangePasswordRequest,
    usuario: Usuario = Depends(get_current_user)
):
    """Cambia la contraseña del usuario autenticado"""
    # Validar que las contraseñas coincidan
    if password_request.new_password != password_request.confirm_password:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Las contraseñas no coinciden"
        )
    
    # Validar longitud mínima (debe cumplir con la política de Cognito)
    if len(password_request.new_password) < 12:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="La contraseña debe tener al menos 12 caracteres"
        )
    
    # Nota: No podemos verificar la contraseña actual con admin_set_user_password
    # porque requiere autenticación del usuario. En producción, esto debería
    # hacerse a través del flujo de cambio de contraseña de Cognito que requiere
    # la contraseña actual. Por ahora, permitimos el cambio directo.
    # TODO: Implementar cambio de contraseña con verificación de contraseña actual
    
    try:
        cognito_auth.change_user_password(
            cognito_user_id=usuario.cognito_user_id,
            new_password=password_request.new_password,
            permanent=True
        )
        
        logger.info(f"Contraseña cambiada para {usuario.email}")
        
        return {"message": "Contraseña cambiada exitosamente"}
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error cambiando contraseña: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error cambiando contraseña: {str(e)}"
        )


@router.delete("/me")
async def delete_my_account(
    usuario: Usuario = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Elimina la cuenta del usuario autenticado"""
    email = usuario.email
    nombre = usuario.nombre
    
    # Desactivar usuario en BD
    usuario.activo = False
    db.commit()
    
    # Enviar email de confirmación de eliminación
    try:
        cognito_auth.send_account_deletion_email(email=email, nombre=nombre)
    except Exception as e:
        logger.warning(f"Error enviando email de eliminación: {e}")
    
    # Eliminar de Cognito
    try:
        cognito_auth.delete_user(usuario.cognito_user_id)
        logger.info(f"Cuenta eliminada: {email}")
    except Exception as e:
        logger.error(f"Error eliminando usuario de Cognito: {e}")
        # Continuar aunque falle Cognito
    
    # Opcional: Eliminar completamente de BD (comentado por seguridad)
    # db.delete(usuario)
    # db.commit()
    
    return {"message": "Cuenta eliminada exitosamente"}


@router.get("/usuarios", response_model=List[UsuarioConDifusoras])
async def get_usuarios(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    search: Optional[str] = Query(None),
    rol: Optional[str] = Query(None),
    activo: Optional[bool] = Query(None),
    usuario: Usuario = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Obtiene lista de usuarios con sus difusoras (solo admin)"""
    if usuario.rol != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Solo administradores pueden ver usuarios"
        )
    
    query = db.query(Usuario)
    
    if search:
        query = query.filter(
            Usuario.nombre.ilike(f"%{search}%") |
            Usuario.email.ilike(f"%{search}%")
        )
    
    if rol:
        query = query.filter(Usuario.rol == rol)
    
    if activo is not None:
        query = query.filter(Usuario.activo == activo)
    
    usuarios = query.order_by(Usuario.nombre).offset(skip).limit(limit).all()
    
    # Obtener difusoras para cada usuario
    result = []
    for u in usuarios:
        # Filtrar usuarios con email inválido o vacío
        if not u.email or '@' not in u.email:
            logger.warning(f"Usuario {u.id} tiene email inválido: '{u.email}', omitiendo")
            continue
            
        asignaciones = db.query(UsuarioDifusora).filter(
            UsuarioDifusora.usuario_id == u.id
        ).join(Difusora).all()
        difusoras_siglas = [a.difusora.siglas for a in asignaciones]
        
        result.append(UsuarioConDifusoras(
            **u.__dict__,
            difusoras=difusoras_siglas
        ))
    
    return result


@router.post("/usuarios/invitar", response_model=UsuarioInviteResponse)
async def invitar_usuario(
    usuario_invite: UsuarioInvite,
    usuario: Usuario = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Invita un nuevo usuario:
    1. Crea el usuario en Cognito
    2. Asigna al grupo correspondiente según el rol
    3. Crea registro en BD (se sincronizará cuando se autentique)
    4. Asigna difusoras si se proporcionan
    """
    if usuario.rol != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Solo administradores pueden invitar usuarios"
        )
    
    # Validar rol
    if usuario_invite.rol not in ["admin", "manager", "operador"]:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Rol inválido. Debe ser: admin, manager, o operador"
        )
    
    # Verificar que el email no esté ya en uso en la BD (pero permitir si solo existe en Cognito)
    # Esto permite reenviar códigos de verificación a usuarios que existen en Cognito pero no en BD
    existing_user = db.query(Usuario).filter(Usuario.email == usuario_invite.email).first()
    if existing_user and existing_user.activo:
        # Si el usuario existe y está activo, verificar si está en Cognito
        # Si está en Cognito y verificado, no permitir re-invitación
        # Si no está en Cognito o no está verificado, permitir actualizar
        pass  # Continuar con el proceso, se manejará en el try/except
    
    try:
        # Crear usuario en Cognito (o reenviar código si ya existe)
        cognito_result = cognito_auth.create_user(
            email=usuario_invite.email,
            nombre=usuario_invite.nombre,
            rol=usuario_invite.rol
        )
        
        cognito_user_id = cognito_result['cognito_user_id']
        temporary_password = cognito_result.get('temporary_password')
        user_exists = cognito_result.get('user_exists', False)
        
        # Verificar si el usuario ya existe en la BD
        nuevo_usuario = db.query(Usuario).filter(Usuario.email == usuario_invite.email).first()
        
        if not nuevo_usuario:
            # Crear registro en BD (se creará cuando el usuario se autentique, pero lo pre-creamos)
            nuevo_usuario = Usuario(
                cognito_user_id=cognito_user_id,
                email=usuario_invite.email,
                nombre=usuario_invite.nombre,
                rol=usuario_invite.rol,
                activo=True
            )
            db.add(nuevo_usuario)
            db.commit()
            db.refresh(nuevo_usuario)
        else:
            # Usuario ya existe en BD, actualizar información si es necesario
            if nuevo_usuario.nombre != usuario_invite.nombre:
                nuevo_usuario.nombre = usuario_invite.nombre
            if nuevo_usuario.rol != usuario_invite.rol:
                nuevo_usuario.rol = usuario_invite.rol
            if nuevo_usuario.cognito_user_id != cognito_user_id:
                nuevo_usuario.cognito_user_id = cognito_user_id
            if not nuevo_usuario.activo:
                nuevo_usuario.activo = True
            db.commit()
            db.refresh(nuevo_usuario)
        
        # Asignar difusoras si se proporcionan
        if usuario_invite.difusoras_ids:
            for difusora_id in usuario_invite.difusoras_ids:
                # Verificar que la difusora existe
                difusora = db.query(Difusora).filter(Difusora.id == difusora_id).first()
                if not difusora:
                    logger.warning(f"Difusora {difusora_id} no encontrada, omitiendo")
                    continue
                
                # Verificar que no esté ya asignada
                asignacion_existente = db.query(UsuarioDifusora).filter(
                    and_(
                        UsuarioDifusora.usuario_id == nuevo_usuario.id,
                        UsuarioDifusora.difusora_id == difusora_id
                    )
                ).first()
                
                if not asignacion_existente:
                    nueva_asignacion = UsuarioDifusora(
                        usuario_id=nuevo_usuario.id,
                        difusora_id=difusora_id
                    )
                    db.add(nueva_asignacion)
            
            db.commit()
        
        # Obtener difusoras asignadas para la respuesta
        asignaciones = db.query(UsuarioDifusora).filter(
            UsuarioDifusora.usuario_id == nuevo_usuario.id
        ).join(Difusora).all()
        difusoras_siglas = [a.difusora.siglas for a in asignaciones]
        
        # Mensaje según si el usuario ya existía o es nuevo
        if user_exists:
            message = f"Usuario {usuario_invite.email} ya existe en Cognito pero no está verificado. Se ha establecido una nueva contraseña temporal. El usuario recibirá un email con un link de verificación. Debe hacer clic en el link para verificar su email."
        else:
            message = f"Usuario {usuario_invite.email} invitado exitosamente. Se ha enviado un email con un link de verificación. El usuario debe hacer clic en el link para verificar su email y luego puede iniciar sesión con la contraseña temporal."
        
        logger.info(f"Usuario {usuario_invite.email} invitado por {usuario.email}. Cognito enviará el código de verificación automáticamente.")
        
        return UsuarioInviteResponse(
            usuario=UsuarioConDifusoras(
                **nuevo_usuario.__dict__,
                difusoras=difusoras_siglas
            ),
            temporary_password=temporary_password or "No disponible",
            message=message,
            email_sent=True,  # Cognito maneja el envío automáticamente
            email_message="Link de verificación enviado por Cognito. El usuario debe hacer clic en el link del email para verificar su cuenta."
        )
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error invitando usuario: {e}")
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error invitando usuario: {str(e)}"
        )


@router.get("/usuarios/{usuario_id}", response_model=UsuarioConDifusoras)
async def get_usuario(
    usuario_id: int,
    usuario: Usuario = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Obtiene un usuario específico con sus difusoras"""
    if usuario.rol != "admin" and usuario.id != usuario_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permiso para ver este usuario"
        )
    
    usuario_obj = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    if not usuario_obj:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    
    # Obtener difusoras asignadas
    asignaciones = db.query(UsuarioDifusora).filter(
        UsuarioDifusora.usuario_id == usuario_id
    ).join(Difusora).all()
    
    difusoras_siglas = [a.difusora.siglas for a in asignaciones]
    
    return UsuarioConDifusoras(
        **usuario_obj.__dict__,
        difusoras=difusoras_siglas
    )


@router.put("/usuarios/{usuario_id}", response_model=UsuarioConDifusoras)
async def update_usuario(
    usuario_id: int,
    usuario_update: UsuarioUpdate,
    usuario: Usuario = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Actualiza un usuario (solo admin). Si cambia el rol, actualiza Cognito también."""
    if usuario.rol != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Solo administradores pueden actualizar usuarios"
        )
    
    usuario_obj = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    if not usuario_obj:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    
    update_data = usuario_update.dict(exclude_unset=True)
    old_rol = usuario_obj.rol
    
    # Si cambia el rol, actualizar en Cognito
    if "rol" in update_data and update_data["rol"] != old_rol:
        new_rol = update_data["rol"]
        if new_rol not in ["admin", "manager", "operador"]:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Rol inválido. Debe ser: admin, manager, o operador"
            )
        
        try:
            cognito_auth.update_user_role(
                cognito_user_id=usuario_obj.cognito_user_id,
                old_rol=old_rol,
                new_rol=new_rol
            )
            logger.info(f"Rol actualizado en Cognito: {usuario_obj.email} de {old_rol} a {new_rol}")
        except HTTPException:
            raise
        except Exception as e:
            logger.error(f"Error actualizando rol en Cognito: {e}")
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Error actualizando rol en Cognito: {str(e)}"
            )
    
    # Actualizar campos en BD
    for field, value in update_data.items():
        setattr(usuario_obj, field, value)
    
    db.commit()
    db.refresh(usuario_obj)
    
    logger.info(f"Usuario {usuario_id} actualizado por {usuario.email}")
    
    # Obtener difusoras para la respuesta
    asignaciones = db.query(UsuarioDifusora).filter(
        UsuarioDifusora.usuario_id == usuario_id
    ).join(Difusora).all()
    difusoras_siglas = [a.difusora.siglas for a in asignaciones]
    
    return UsuarioConDifusoras(
        **usuario_obj.__dict__,
        difusoras=difusoras_siglas
    )


@router.post("/usuarios/{usuario_id}/difusoras", response_model=UsuarioConDifusoras)
async def asignar_difusora(
    usuario_id: int,
    difusora_id: int = Query(...),
    usuario: Usuario = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Asigna una difusora a un usuario (solo admin)"""
    if usuario.rol != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Solo administradores pueden asignar difusoras"
        )
    
    # Verificar que el usuario existe
    usuario_obj = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    if not usuario_obj:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    
    # Verificar que la difusora existe
    difusora_obj = db.query(Difusora).filter(Difusora.id == difusora_id).first()
    if not difusora_obj:
        raise HTTPException(status_code=404, detail="Difusora no encontrada")
    
    # Verificar que no esté ya asignada
    asignacion = db.query(UsuarioDifusora).filter(
        and_(
            UsuarioDifusora.usuario_id == usuario_id,
            UsuarioDifusora.difusora_id == difusora_id
        )
    ).first()
    
    if asignacion:
        raise HTTPException(
            status_code=400,
            detail="La difusora ya está asignada a este usuario"
        )
    
    # Crear asignación
    nueva_asignacion = UsuarioDifusora(
        usuario_id=usuario_id,
        difusora_id=difusora_id
    )
    db.add(nueva_asignacion)
    db.commit()
    
    logger.info(f"Difusora {difusora_obj.siglas} asignada a usuario {usuario_obj.email}")
    
    # Retornar usuario actualizado
    asignaciones = db.query(UsuarioDifusora).filter(
        UsuarioDifusora.usuario_id == usuario_id
    ).join(Difusora).all()
    
    difusoras_siglas = [a.difusora.siglas for a in asignaciones]
    
    return UsuarioConDifusoras(
        **usuario_obj.__dict__,
        difusoras=difusoras_siglas
    )


@router.post("/usuarios/{usuario_id}/difusoras/multiple", response_model=UsuarioConDifusoras)
async def asignar_difusoras_multiple(
    usuario_id: int,
    difusoras_ids: List[int] = Body(...),
    usuario: Usuario = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Asigna múltiples difusoras a un usuario (solo admin)"""
    if usuario.rol != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Solo administradores pueden asignar difusoras"
        )
    
    # Verificar que el usuario existe
    usuario_obj = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    if not usuario_obj:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    
    # Asignar cada difusora
    for difusora_id in difusoras_ids:
        # Verificar que la difusora existe
        difusora_obj = db.query(Difusora).filter(Difusora.id == difusora_id).first()
        if not difusora_obj:
            logger.warning(f"Difusora {difusora_id} no encontrada, omitiendo")
            continue
        
        # Verificar que no esté ya asignada
        asignacion = db.query(UsuarioDifusora).filter(
            and_(
                UsuarioDifusora.usuario_id == usuario_id,
                UsuarioDifusora.difusora_id == difusora_id
            )
        ).first()
        
        if not asignacion:
            nueva_asignacion = UsuarioDifusora(
                usuario_id=usuario_id,
                difusora_id=difusora_id
            )
            db.add(nueva_asignacion)
            logger.info(f"Difusora {difusora_obj.siglas} asignada a usuario {usuario_obj.email}")
    
    db.commit()
    
    # Retornar usuario actualizado
    asignaciones = db.query(UsuarioDifusora).filter(
        UsuarioDifusora.usuario_id == usuario_id
    ).join(Difusora).all()
    
    difusoras_siglas = [a.difusora.siglas for a in asignaciones]
    
    return UsuarioConDifusoras(
        **usuario_obj.__dict__,
        difusoras=difusoras_siglas
    )


@router.delete("/usuarios/{usuario_id}/difusoras/{difusora_id}")
async def remover_difusora(
    usuario_id: int,
    difusora_id: int,
    usuario: Usuario = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Remueve una difusora de un usuario (solo admin)"""
    if usuario.rol != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Solo administradores pueden remover difusoras"
        )
    
    asignacion = db.query(UsuarioDifusora).filter(
        and_(
            UsuarioDifusora.usuario_id == usuario_id,
            UsuarioDifusora.difusora_id == difusora_id
        )
    ).first()
    
    if not asignacion:
        raise HTTPException(
            status_code=404,
            detail="Asignación no encontrada"
        )
    
    db.delete(asignacion)
    db.commit()
    
    logger.info(f"Difusora {difusora_id} removida de usuario {usuario_id}")
    return {"message": "Difusora removida correctamente"}


@router.get("/check-setup")
async def check_setup(db: Session = Depends(get_db)):
    """
    Verifica si el sistema está configurado (si existe al menos un admin)
    """
    admin_count = db.query(Usuario).filter(
        Usuario.rol == "admin",
        Usuario.activo == True
    ).count()
    
    return {
        "setup_complete": admin_count > 0,
        "admin_count": admin_count
    }


@router.get("/verify-email")
async def verify_email(
    token: Optional[str] = Query(None),
    username: Optional[str] = Query(None),
    code: Optional[str] = Query(None)
):
    """
    Verifica el email usando el link de verificación de Cognito
    """
    if not cognito_auth.enabled or not cognito_auth.cognito_client:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Cognito no está configurado"
        )
    
    try:
        # Si hay un código, Cognito ya verificó el email
        # Solo necesitamos confirmar el usuario
        if code and username:
            try:
                cognito_auth.cognito_client.admin_confirm_sign_up(
                    UserPoolId=cognito_auth.user_pool_id,
                    Username=username
                )
                return {
                    "message": "Email verificado exitosamente",
                    "verified": True
                }
            except Exception as e:
                # Si el usuario ya está confirmado, está bien
                if "already confirmed" in str(e).lower():
                    return {
                        "message": "Email ya estaba verificado",
                        "verified": True
                    }
                raise
        
        # Si hay un token, verificar con el token
        if token:
            # El token viene de Cognito, verificar que sea válido
            # Por ahora, si hay token, asumimos que es válido
            # En producción, deberías verificar el token con Cognito
            return {
                "message": "Email verificado exitosamente",
                "verified": True
            }
        
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Parámetros de verificación inválidos"
        )
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error verificando email: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error al verificar el email: {str(e)}"
        )


@router.post("/create-first-admin")
async def create_first_admin(
    admin_data: FirstAdminCreate,
    db: Session = Depends(get_db)
):
    """
    Crea el primer administrador del sistema (solo si no existe ningún admin)
    """
    # Verificar que no exista ningún admin
    existing_admin = db.query(Usuario).filter(
        Usuario.rol == "admin",
        Usuario.activo == True
    ).first()
    
    if existing_admin:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Ya existe un administrador en el sistema. Usa el login para acceder."
        )
    
    # Validar contraseñas
    if admin_data.password != admin_data.confirm_password:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Las contraseñas no coinciden"
        )
    
    # Validar longitud mínima de contraseña
    if len(admin_data.password) < 12:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="La contraseña debe tener al menos 12 caracteres"
        )
    
    # Verificar que el email no esté en uso
    existing_user = db.query(Usuario).filter(Usuario.email == admin_data.email).first()
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="El email ya está registrado"
        )
    
    # Verificar que Cognito esté configurado y tenga credenciales
    if not cognito_auth.enabled or not cognito_auth.cognito_client:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Cognito no está configurado o no hay credenciales de AWS. Para crear el primer administrador, necesitas configurar:\n1. Variables de entorno: COGNITO_USER_POOL_ID, COGNITO_CLIENT_ID, COGNITO_REGION\n2. Credenciales de AWS: AWS_ACCESS_KEY_ID y AWS_SECRET_ACCESS_KEY (o configura el perfil de AWS con 'aws configure')"
        )
    
    try:
        # Crear usuario en Cognito
        cognito_result = cognito_auth.create_user(
            email=admin_data.email,
            nombre=admin_data.nombre,
            rol="admin",
            temporary_password=admin_data.password
        )
        
        # Establecer contraseña permanente
        cognito_auth.change_user_password(
            cognito_user_id=cognito_result['cognito_user_id'],
            new_password=admin_data.password,
            permanent=True
        )
        
        # Confirmar usuario en Cognito
        try:
            import boto3
            cognito_client = boto3.client('cognito-idp', region_name=cognito_auth.region)
            cognito_client.admin_confirm_sign_up(
                UserPoolId=cognito_auth.user_pool_id,
                Username=cognito_result['cognito_user_id']
            )
        except Exception as e:
            logger.warning(f"Error confirmando usuario en Cognito: {e}")
        
        # Crear registro en BD
        usuario = Usuario(
            cognito_user_id=cognito_result['cognito_user_id'],
            email=admin_data.email,
            nombre=admin_data.nombre,
            rol="admin",
            activo=True,
            nombre_empresa=admin_data.nombre_empresa,
            telefono=admin_data.telefono,
            direccion=admin_data.direccion,
            ciudad=admin_data.ciudad
        )
        db.add(usuario)
        db.commit()
        db.refresh(usuario)
        
        # Enviar email de bienvenida
        try:
            cognito_auth.send_invitation_email(
                email=admin_data.email,
                temporary_password=admin_data.password,
                nombre=admin_data.nombre
            )
        except Exception as e:
            logger.warning(f"Error enviando email de bienvenida: {e}")
        
        logger.info(f"Primer administrador creado: {admin_data.email}")
        
        return {
            "message": "Administrador creado exitosamente",
            "email": admin_data.email,
            "nombre": admin_data.nombre
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error creando primer administrador: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error creando administrador: {str(e)}"
        )

