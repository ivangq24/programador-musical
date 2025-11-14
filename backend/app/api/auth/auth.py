"""
Endpoints de autenticación y gestión de usuarios
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query, Body
from sqlalchemy.orm import Session
from sqlalchemy import and_
from typing import List, Optional

from app.core.database import get_db
from app.core.auth import get_current_user, require_role, get_user_difusoras
from app.models.auth import Usuario, UsuarioDifusora, Organizacion
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
    FirstAdminCreate,
    ForgotPasswordRequest,
    ResetPasswordRequest
)
from app.core.auth import cognito_auth

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
            # Cognito usa 'name' como atributo estándar
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
                # Log el error pero continuar, la BD ya está actualizada
                import logging
                logger = logging.getLogger(__name__)
                logger.warning(f"Error actualizando Cognito: {str(e)}")
    
    db.commit()
    db.refresh(usuario)
    
    # Retornar información actualizada del usuario
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
        

        
        return {"message": "Contraseña cambiada exitosamente"}
        
    except HTTPException:
        raise
    except Exception as e:
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
    
    # Guardar nombre y email antes de desactivar
    usuario_nombre = usuario.nombre
    usuario_email = usuario.email
    was_active = usuario.activo
    
    # Desactivar usuario en BD
    usuario.activo = False
    db.commit()
    
    # Enviar email de notificación de desactivación
    if was_active:
        try:
            cognito_auth.send_account_deactivation_email(
                email=usuario_email,
                nombre=usuario_nombre
            )
        except Exception as e:
            # No fallar la eliminación si el email falla
            pass
    
    # Enviar email de confirmación de eliminación
    try:
        cognito_auth.send_account_deletion_email(email=email, nombre=nombre)
    except Exception as e:
        # Continuar aunque falle el envío de email
        pass
    
    # Eliminar de Cognito
    try:
        cognito_auth.delete_user(usuario.cognito_user_id)

    except Exception as e:
        # Continuar aunque falle Cognito
        pass
    
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
    """Obtiene lista de usuarios con sus difusoras (solo admin) - Solo usuarios de la misma organización"""
    if usuario.rol != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Solo administradores pueden ver usuarios"
        )
    
    # Verificar que organizacion_id existe
    if not hasattr(usuario, 'organizacion_id') or not usuario.organizacion_id:
        raise HTTPException(
            status_code=500,
            detail="Error de configuración: La migración de base de datos no se ha ejecutado. Contacta al administrador."
        )
    
    # Filtrar solo usuarios de la misma organización (multi-tenancy)
    query = db.query(Usuario).filter(Usuario.organizacion_id == usuario.organizacion_id)
    
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
    4. Asigna difusoras si se proporcionan (NO para admins nuevos)
    
    IMPORTANTE: Solo el primer admin puede invitar a otros administradores.
    Los nuevos administradores deben venir sin difusoras asignadas (datos en blanco).
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
    
    # Si se está intentando invitar a un admin, verificar que el usuario actual sea el primer admin
    if usuario_invite.rol == "admin":
        # Contar cuántos admins activos hay
        admin_count = db.query(Usuario).filter(
            Usuario.rol == "admin",
            Usuario.activo == True
        ).count()
        
        # Obtener el primer admin (el más antiguo por ID)
        primer_admin = db.query(Usuario).filter(
            Usuario.rol == "admin",
            Usuario.activo == True
        ).order_by(Usuario.id.asc()).first()
        
        # Solo el primer admin puede invitar a otros admins
        if not primer_admin or primer_admin.id != usuario.id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Solo el primer administrador puede invitar a otros administradores. Si necesitas agregar otro administrador a tu organización, contacta al primer administrador del sistema."
            )
        
        # Cuando un admin invita a otro admin, el nuevo admin debe heredar las difusoras del admin que lo invita
        # Obtener las difusoras del admin actual
        difusoras_admin_actual = db.query(UsuarioDifusora).filter(
            UsuarioDifusora.usuario_id == usuario.id
        ).join(Difusora).filter(Difusora.activa == True).all()
        
        # Si el admin actual tiene difusoras, asignarlas automáticamente al nuevo admin
        if difusoras_admin_actual:
            # Reemplazar las difusoras_ids con las del admin actual
            usuario_invite.difusoras_ids = [d.difusora_id for d in difusoras_admin_actual]
        else:
            # Si el admin actual no tiene difusoras, el nuevo admin tampoco las tendrá
            usuario_invite.difusoras_ids = []
    
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
            # Crear registro en BD con la organización del admin que invita
            nuevo_usuario = Usuario(
                cognito_user_id=cognito_user_id,
                email=usuario_invite.email,
                nombre=usuario_invite.nombre,
                rol=usuario_invite.rol,
                activo=True,
                organizacion_id=usuario.organizacion_id  # ← ASIGNAR ORGANIZACIÓN DEL ADMIN QUE INVITA
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
            # Asegurar que el usuario pertenece a la organización del admin que invita
            if nuevo_usuario.organizacion_id != usuario.organizacion_id:
                nuevo_usuario.organizacion_id = usuario.organizacion_id
            db.commit()
            db.refresh(nuevo_usuario)
        
        # Asignar difusoras si se proporcionan (solo difusoras de la misma organización)
        # Para admins: se asignan automáticamente las difusoras del admin que los invita
        # Para otros roles: se asignan las difusoras proporcionadas
        if usuario_invite.difusoras_ids:
            for difusora_id in usuario_invite.difusoras_ids:
                # Verificar que la difusora existe y pertenece a la misma organización
                difusora = db.query(Difusora).filter(
                    Difusora.id == difusora_id,
                    Difusora.organizacion_id == usuario.organizacion_id  # ← FILTRO POR ORGANIZACIÓN
                ).first()
                if not difusora:
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
        
        # Enviar email de bienvenida usando SES (si hay contraseña temporal)
        email_sent = False
        email_message = ""
        if temporary_password:
            try:
                email_result = cognito_auth.send_invitation_email(
                    email=usuario_invite.email,
                    temporary_password=temporary_password,
                    nombre=usuario_invite.nombre
                )
                email_sent = email_result.get('sent', False)
                if email_sent:
                    email_message = "Email de bienvenida enviado exitosamente con credenciales de acceso."
                else:
                    email_message = f"Email no enviado: {email_result.get('message', 'Error desconocido')}. Cognito enviará el link de verificación."
            except Exception as e:
                email_message = f"Error enviando email de bienvenida: {str(e)}. Cognito enviará el link de verificación."
        
        # Mensaje según si el usuario ya existía o es nuevo
        if user_exists:
            message = f"Usuario {usuario_invite.email} ya existe en Cognito pero no está verificado. Se ha establecido una nueva contraseña temporal."
        else:
            message = f"Usuario {usuario_invite.email} invitado exitosamente."
        
        if email_sent:
            message += " Se ha enviado un email de bienvenida con las credenciales de acceso."
        else:
            message += " El usuario recibirá un email de Cognito con un link de verificación."
        
        return UsuarioInviteResponse(
            usuario=UsuarioConDifusoras(
                **nuevo_usuario.__dict__,
                difusoras=difusoras_siglas
            ),
            temporary_password=temporary_password or "No disponible",
            message=message,
            email_sent=email_sent,
            email_message=email_message
        )
        
    except HTTPException:
        raise
    except Exception as e:

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
    """Obtiene un usuario específico con sus difusoras (solo de la misma organización)"""
    if usuario.rol != "admin" and usuario.id != usuario_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permiso para ver este usuario"
        )
    
    # Verificar que organizacion_id existe
    if not hasattr(usuario, 'organizacion_id') or not usuario.organizacion_id:
        raise HTTPException(
            status_code=500,
            detail="Error de configuración: La migración de base de datos no se ha ejecutado. Contacta al administrador."
        )
    
    # Filtrar por organización (multi-tenancy)
    usuario_obj = db.query(Usuario).filter(
        Usuario.id == usuario_id,
        Usuario.organizacion_id == usuario.organizacion_id  # ← FILTRO POR ORGANIZACIÓN
    ).first()
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
    """Actualiza un usuario (solo admin, solo de la misma organización). Si cambia el rol, actualiza Cognito también."""
    if usuario.rol != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Solo administradores pueden actualizar usuarios"
        )
    
    # Verificar que organizacion_id existe
    if not hasattr(usuario, 'organizacion_id') or not usuario.organizacion_id:
        raise HTTPException(
            status_code=500,
            detail="Error de configuración: La migración de base de datos no se ha ejecutado. Contacta al administrador."
        )
    
    # Filtrar por organización (multi-tenancy)
    usuario_obj = db.query(Usuario).filter(
        Usuario.id == usuario_id,
        Usuario.organizacion_id == usuario.organizacion_id  # ← FILTRO POR ORGANIZACIÓN
    ).first()
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

        except HTTPException:
            raise
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Error actualizando rol en Cognito: {str(e)}"
            )
    
    # Guardar estado anterior de activo
    was_active = usuario_obj.activo
    
    # Actualizar campos en BD
    for field, value in update_data.items():
        setattr(usuario_obj, field, value)
    
    db.commit()
    db.refresh(usuario_obj)
    
    # Si el usuario fue desactivado, enviar email de notificación
    if was_active and not usuario_obj.activo:
        try:
            cognito_auth.send_account_deactivation_email(
                email=usuario_obj.email,
                nombre=usuario_obj.nombre
            )
        except Exception as e:
            # No fallar la actualización si el email falla
            pass
    
    # Si el usuario cambió a rol ADMIN, asignarle automáticamente TODAS las difusoras de la organización
    if "rol" in update_data and update_data["rol"] == "admin" and old_rol != "admin":
        try:
            # Obtener todas las difusoras activas de la organización
            todas_difusoras = db.query(Difusora).filter(
                Difusora.activa == True,
                Difusora.organizacion_id == usuario.organizacion_id
            ).all()
            
            # Asignar cada difusora al nuevo admin
            difusoras_asignadas = 0
            for difusora in todas_difusoras:
                # Verificar si ya está asignada
                asignacion_existente = db.query(UsuarioDifusora).filter(
                    and_(
                        UsuarioDifusora.usuario_id == usuario_id,
                        UsuarioDifusora.difusora_id == difusora.id
                    )
                ).first()
                
                if not asignacion_existente:
                    nueva_asignacion = UsuarioDifusora(
                        usuario_id=usuario_id,
                        difusora_id=difusora.id
                    )
                    db.add(nueva_asignacion)
                    difusoras_asignadas += 1
            
            if difusoras_asignadas > 0:
                db.commit()
                
        except Exception as e:
            # Si falla la asignación automática, loguear pero no fallar la actualización
            import logging
            logger = logging.getLogger(__name__)
            logger.error(f"Error asignando difusoras automáticamente al nuevo admin: {str(e)}")
            db.rollback()
            # No lanzar excepción, el usuario ya es admin en RDS
    
    # Obtener difusoras para la respuesta
    asignaciones = db.query(UsuarioDifusora).filter(
        UsuarioDifusora.usuario_id == usuario_id
    ).join(Difusora).all()
    difusoras_siglas = [a.difusora.siglas for a in asignaciones]
    
    # Construir respuesta sin usar __dict__ para evitar campos internos de SQLAlchemy
    return UsuarioConDifusoras(
        id=usuario_obj.id,
        cognito_user_id=usuario_obj.cognito_user_id,
        email=usuario_obj.email,
        nombre=usuario_obj.nombre,
        rol=usuario_obj.rol,
        activo=usuario_obj.activo,
        organizacion_id=usuario_obj.organizacion_id,
        nombre_empresa=usuario_obj.nombre_empresa,
        telefono=usuario_obj.telefono,
        direccion=usuario_obj.direccion,
        ciudad=usuario_obj.ciudad,
        created_at=usuario_obj.created_at,
        updated_at=usuario_obj.updated_at,
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
    
    # Verificar que el usuario existe y pertenece a la misma organización
    usuario_obj = db.query(Usuario).filter(
        Usuario.id == usuario_id,
        Usuario.organizacion_id == usuario.organizacion_id  # ← FILTRO POR ORGANIZACIÓN
    ).first()
    if not usuario_obj:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    
    # Verificar que la difusora existe y pertenece a la misma organización
    difusora_obj = db.query(Difusora).filter(
        Difusora.id == difusora_id,
        Difusora.organizacion_id == usuario.organizacion_id  # ← FILTRO POR ORGANIZACIÓN
    ).first()
    if not difusora_obj:
        raise HTTPException(status_code=404, detail="Difusora no encontrada o no pertenece a tu organización")
    
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
    
    # Verificar que el usuario existe y pertenece a la misma organización
    usuario_obj = db.query(Usuario).filter(
        Usuario.id == usuario_id,
        Usuario.organizacion_id == usuario.organizacion_id  # ← FILTRO POR ORGANIZACIÓN
    ).first()
    if not usuario_obj:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    
    # Asignar cada difusora (solo de la misma organización)
    for difusora_id in difusoras_ids:
        # Verificar que la difusora existe y pertenece a la misma organización
        difusora_obj = db.query(Difusora).filter(
            Difusora.id == difusora_id,
            Difusora.organizacion_id == usuario.organizacion_id  # ← FILTRO POR ORGANIZACIÓN
        ).first()
        if not difusora_obj:
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
    """Remueve una difusora de un usuario (solo admin, solo de la misma organización)"""
    if usuario.rol != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Solo administradores pueden remover difusoras"
        )
    
    # Verificar que el usuario pertenece a la misma organización
    usuario_obj = db.query(Usuario).filter(
        Usuario.id == usuario_id,
        Usuario.organizacion_id == usuario.organizacion_id  # ← FILTRO POR ORGANIZACIÓN
    ).first()
    if not usuario_obj:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    
    # Verificar que la difusora pertenece a la misma organización
    difusora_obj = db.query(Difusora).filter(
        Difusora.id == difusora_id,
        Difusora.organizacion_id == usuario.organizacion_id  # ← FILTRO POR ORGANIZACIÓN
    ).first()
    if not difusora_obj:
        raise HTTPException(status_code=404, detail="Difusora no encontrada o no pertenece a tu organización")
    
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
    Crea una cuenta de administrador. Permite múltiples administradores,
    cada uno puede ser dueño de su propio grupo de radiodifusoras.
    """
    
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
    
    # Verificar que Cognito esté configurado y tenga credenciales
    if not cognito_auth.enabled or not cognito_auth.cognito_client:
        error_detail = "Cognito no está configurado correctamente."
        
        if cognito_auth.init_error:
            error_detail += f"\n\nDetalles del error: {cognito_auth.init_error}"
        else:
            error_detail += "\n\nPosibles causas:"
            error_detail += "\n1. Variables de entorno faltantes: COGNITO_USER_POOL_ID, COGNITO_CLIENT_ID, COGNITO_REGION"
            error_detail += "\n2. El IAM role del task ECS no tiene permisos para Cognito"
            error_detail += "\n3. Las credenciales de AWS no están disponibles (en ECS, esto se maneja automáticamente con IAM roles)"
        
        error_detail += "\n\nSolución:"
        error_detail += "\n- Verifica que las variables de entorno estén configuradas en el task definition de ECS"
        error_detail += "\n- Asegúrate de que el IAM role del task tenga permisos para:"
        error_detail += "\n  * cognito-idp:AdminCreateUser"
        error_detail += "\n  * cognito-idp:AdminSetUserPassword"
        error_detail += "\n  * cognito-idp:AdminConfirmSignUp"
        error_detail += "\n  * cognito-idp:ListUsers"
        error_detail += "\n  * cognito-idp:DescribeUserPool"
        
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail=error_detail
        )
    
    # Verificar que el email no esté en uso en Cognito primero
    try:
        cognito_users = cognito_auth.cognito_client.list_users(
            UserPoolId=cognito_auth.user_pool_id,
            Filter=f'email = "{admin_data.email}"'
        )
        if cognito_users.get('Users'):
            # El usuario existe en Cognito
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="El email ya está registrado en Cognito. Si olvidaste tu contraseña, usa la opción '¿Olvidaste tu contraseña?' en la página de login."
            )
    except HTTPException:
        raise
    except Exception as e:
        # Si falla la verificación de Cognito, continuar (puede ser un problema temporal)
        pass
    
    # Verificar que el email no esté en uso en RDS
    existing_user = db.query(Usuario).filter(Usuario.email == admin_data.email).first()
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="El email ya está registrado en la base de datos"
        )
    
    try:
        # Crear usuario en Cognito
        cognito_result = cognito_auth.create_user(
            email=admin_data.email,
            nombre=admin_data.nombre,
            rol="admin",
            temporary_password=admin_data.password
        )
        
        cognito_user_id = cognito_result['cognito_user_id']
        user_exists = cognito_result.get('user_exists', False)
        
        # Si el usuario ya existía, verificar su estado
        if user_exists:
            # El usuario ya existía en Cognito, establecer la contraseña directamente
            try:
                cognito_auth.change_user_password(
                    cognito_user_id=cognito_user_id,
                    new_password=admin_data.password,
                    permanent=True
                )
            except Exception as e:
                # Si falla, intentar establecer la contraseña con admin_set_user_password
                try:
                    import boto3
                    cognito_client = boto3.client('cognito-idp', region_name=cognito_auth.region)
                    cognito_client.admin_set_user_password(
                        UserPoolId=cognito_auth.user_pool_id,
                        Username=cognito_user_id,
                        Password=admin_data.password,
                        Permanent=True
                    )
                except Exception:
                    pass
        else:
            # Usuario nuevo, establecer contraseña permanente
            cognito_auth.change_user_password(
                cognito_user_id=cognito_user_id,
                new_password=admin_data.password,
                permanent=True
            )
        
        # Confirmar usuario en Cognito y cambiar estado de FORCE_CHANGE_PASSWORD a CONFIRMED
        try:
            import boto3
            cognito_client = boto3.client('cognito-idp', region_name=cognito_auth.region)
            
            # Confirmar usuario
            try:
                cognito_client.admin_confirm_sign_up(
                    UserPoolId=cognito_auth.user_pool_id,
                    Username=cognito_user_id
                )
            except Exception as e:
                # Si el usuario ya está confirmado, está bien
                if "already confirmed" not in str(e).lower():
                    pass
            
            # Verificar estado del usuario
            user_info = cognito_client.admin_get_user(
                UserPoolId=cognito_auth.user_pool_id,
                Username=cognito_user_id
            )
            
            # Si el usuario está en FORCE_CHANGE_PASSWORD, establecer la contraseña como permanente
            # Esto cambiará el estado a CONFIRMED
            if user_info.get('UserStatus') == 'FORCE_CHANGE_PASSWORD':
                cognito_client.admin_set_user_password(
                    UserPoolId=cognito_auth.user_pool_id,
                    Username=cognito_user_id,
                    Password=admin_data.password,
                    Permanent=True
                )
        except Exception as e:
            # Continuar aunque falle la confirmación
            pass
        
        # Crear organización nueva para este administrador
        nueva_organizacion = Organizacion(
            nombre=admin_data.nombre_empresa or f"Organización de {admin_data.nombre}",
            nombre_empresa=admin_data.nombre_empresa,
            telefono=admin_data.telefono,
            direccion=admin_data.direccion,
            ciudad=admin_data.ciudad,
            activa=True
        )
        db.add(nueva_organizacion)
        db.commit()
        db.refresh(nueva_organizacion)
        
        # Crear registro en BD con organizacion_id
        usuario = Usuario(
            cognito_user_id=cognito_result['cognito_user_id'],
            email=admin_data.email,
            nombre=admin_data.nombre,
            rol="admin",
            activo=True,
            organizacion_id=nueva_organizacion.id,
            nombre_empresa=admin_data.nombre_empresa,  # Mantener por compatibilidad
            telefono=admin_data.telefono,
            direccion=admin_data.direccion,
            ciudad=admin_data.ciudad
        )
        db.add(usuario)
        db.commit()
        db.refresh(usuario)
        
        # Asignar automáticamente TODAS las difusoras de la organización al nuevo admin
        # Esto asegura que el admin tenga acceso completo desde el inicio
        todas_difusoras = db.query(Difusora).filter(
            Difusora.activa == True,
            Difusora.organizacion_id == nueva_organizacion.id
        ).all()
        
        for difusora in todas_difusoras:
            nueva_asignacion = UsuarioDifusora(
                usuario_id=usuario.id,
                difusora_id=difusora.id
            )
            db.add(nueva_asignacion)
        
        if todas_difusoras:
            db.commit()
        
        # Enviar email de bienvenida
        try:
            cognito_auth.send_invitation_email(
                email=admin_data.email,
                temporary_password=admin_data.password,
                nombre=admin_data.nombre
            )
        except Exception as e:
            # Continuar aunque falle el envío de email
            pass
        

        
        return {
            "message": "Administrador creado exitosamente",
            "email": admin_data.email,
            "nombre": admin_data.nombre
        }
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error creando administrador: {str(e)}"
        )


@router.post("/forgot-password")
async def forgot_password(
    request: ForgotPasswordRequest,
    db: Session = Depends(get_db)
):
    """
    Solicita recuperación de contraseña. Envía un código por email usando SES.
    """
    try:
        # Buscar usuario en BD
        usuario = db.query(Usuario).filter(Usuario.email == request.email).first()
        
        # Por seguridad, siempre devolvemos éxito aunque el usuario no exista
        # Esto previene user enumeration attacks
        if not usuario:
            return {
                "message": "Si el email está registrado, recibirás un código de recuperación por email.",
                "email_sent": False
            }
        
        # Verificar que el usuario esté activo
        if not usuario.activo:
            return {
                "message": "Si el email está registrado, recibirás un código de recuperación por email.",
                "email_sent": False
            }
        
        # Generar código de verificación usando Cognito
        try:
            import boto3
            from botocore.exceptions import ClientError
            
            cognito_client = boto3.client('cognito-idp', region_name=cognito_auth.region)
            
            # Iniciar el flujo de forgot password en Cognito
            # Cognito enviará el código automáticamente por email
            response = cognito_client.forgot_password(
                ClientId=cognito_auth.client_id,
                Username=request.email
            )
            
            # Cognito ya envió el código por email
            # También intentamos enviar un email informativo adicional con SES
            # (aunque el código real viene de Cognito)
            try:
                # Enviar email informativo adicional (sin código, solo instrucciones)
                # Nota: El código real viene en el email de Cognito
                email_result = cognito_auth.send_password_reset_email(
                    email=usuario.email,
                    nombre=usuario.nombre,
                    reset_code="XXXXXX"  # Placeholder, el código real viene de Cognito
                )
            except Exception:
                # Si falla SES, no es crítico, Cognito ya envió el código
                pass
            
            return {
                "message": "Se ha enviado un código de recuperación a tu email. Revisa tu bandeja de entrada y spam.",
                "email_sent": True
            }
                
        except ClientError as e:
            error_code = e.response.get('Error', {}).get('Code', '')
            
            if error_code == 'UserNotFoundException':
                # Por seguridad, no revelamos si el usuario existe
                return {
                    "message": "Si el email está registrado, recibirás un código de recuperación por email.",
                    "email_sent": False
                }
            elif error_code == 'LimitExceededException':
                raise HTTPException(
                    status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                    detail="Has excedido el límite de intentos. Espera unos minutos e intenta nuevamente."
                )
            elif error_code == 'TooManyRequestsException':
                raise HTTPException(
                    status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                    detail="Demasiadas solicitudes. Por favor, espera unos minutos."
                )
            else:
                # Por seguridad, siempre devolvemos éxito
                return {
                    "message": "Si el email está registrado, recibirás un código de recuperación por email.",
                    "email_sent": False
                }
        except Exception as e:
            # Por seguridad, siempre devolvemos éxito
            return {
                "message": "Si el email está registrado, recibirás un código de recuperación por email.",
                "email_sent": False
            }
            
    except Exception as e:
        # Por seguridad, siempre devolvemos éxito
        return {
            "message": "Si el email está registrado, recibirás un código de recuperación por email.",
            "email_sent": False
        }


@router.post("/reset-password")
async def reset_password(
    request: ResetPasswordRequest,
    db: Session = Depends(get_db)
):
    """
    Restablece la contraseña usando el código de verificación.
    """
    # Validar contraseñas
    if request.new_password != request.confirm_password:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Las contraseñas no coinciden"
        )
    
    # Validar longitud mínima
    if len(request.new_password) < 12:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="La contraseña debe tener al menos 12 caracteres"
        )
    
    try:
        import boto3
        from botocore.exceptions import ClientError
        
        cognito_client = boto3.client('cognito-idp', region_name=cognito_auth.region)
        
        # Confirmar el código y establecer nueva contraseña
        cognito_client.confirm_forgot_password(
            ClientId=cognito_auth.client_id,
            Username=request.email,
            ConfirmationCode=request.code,
            Password=request.new_password
        )
        
        return {
            "message": "Contraseña restablecida exitosamente. Ya puedes iniciar sesión con tu nueva contraseña."
        }
        
    except ClientError as e:
        error_code = e.response.get('Error', {}).get('Code', '')
        
        if error_code == 'CodeMismatchException':
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Código de verificación inválido o expirado. Solicita un nuevo código."
            )
        elif error_code == 'ExpiredCodeException':
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="El código de verificación ha expirado. Solicita un nuevo código."
            )
        elif error_code == 'UserNotFoundException':
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Usuario no encontrado"
            )
        elif error_code == 'InvalidPasswordException':
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="La contraseña no cumple con los requisitos de seguridad."
            )
        else:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Error al restablecer contraseña: {str(e)}"
            )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error al restablecer contraseña: {str(e)}"
        )

