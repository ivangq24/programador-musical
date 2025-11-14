from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import or_
from app.core.database import get_db
from app.core.auth import get_current_user, get_user_difusoras
from app.models.auth import Usuario
from app.models.catalogos import Difusora
from app.schemas.catalogos import DifusoraCreate, DifusoraUpdate, Difusora as DifusoraSchema
from typing import List, Optional

router = APIRouter()

@router.get("/", response_model=List[DifusoraSchema])
async def get_difusoras(
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras),
    skip: int = Query(0, ge=0, description="Número de registros a omitir"),
    limit: int = Query(100, ge=1, le=1000, description="Número máximo de registros a retornar"),
    search: Optional[str] = Query(None, description="Término de búsqueda"),
    activa: Optional[bool] = Query(None, description="Filtrar por estado activo")
):
    """
    Obtener lista de difusoras con filtros opcionales
    Solo muestra las difusoras asignadas al usuario (cada admin solo ve sus propias difusoras)
    """
    try:
        # Filtrar por organización del usuario (multi-tenancy)
        if hasattr(usuario, 'organizacion_id') and usuario.organizacion_id:
            query = db.query(Difusora).filter(Difusora.organizacion_id == usuario.organizacion_id)
        else:
            # Si organizacion_id no existe, la migración aún no se ha ejecutado
            # Retornar lista vacía para evitar mostrar datos incorrectos
            return []
        
        # Filtrar por difusoras permitidas (solo difusoras asignadas al usuario)
        if difusoras_allowed:
            query = query.filter(Difusora.siglas.in_(difusoras_allowed))
        else:
            # Si no tiene difusoras asignadas, retornar lista vacía
            # Esto puede ocurrir si el usuario no tiene difusoras asignadas o si organizacion_id no existe
            import logging
            logger = logging.getLogger(__name__)
            logger.warning(f"Usuario {usuario.email} (ID: {usuario.id}) no tiene difusoras asignadas. organizacion_id: {getattr(usuario, 'organizacion_id', 'NO EXISTE')}")
            return []
        
        # Aplicar filtro de estado activo
        if activa is not None:
            query = query.filter(Difusora.activa == activa)
        
        # Aplicar búsqueda
        if search:
            search_term = f"%{search}%"
            query = query.filter(
                or_(
                    Difusora.nombre.ilike(search_term),
                    Difusora.siglas.ilike(search_term),
                    Difusora.slogan.ilike(search_term),
                    Difusora.descripcion.ilike(search_term)
                )
            )
        
        # Ordenar por orden y luego por nombre
        query = query.order_by(Difusora.orden, Difusora.nombre)
        
        # Aplicar paginación
        difusoras = query.offset(skip).limit(limit).all()
        
        return difusoras
        
    except Exception as e:

        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.get("/{difusora_id}", response_model=DifusoraSchema)
async def get_difusora(
    difusora_id: int, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user)
):
    """
    Obtener una difusora específica por ID (solo de la organización del usuario)
    """
    try:
        if hasattr(usuario, 'organizacion_id') and usuario.organizacion_id:
            difusora = db.query(Difusora).filter(
                Difusora.id == difusora_id,
                Difusora.organizacion_id == usuario.organizacion_id  # ← FILTRO POR ORGANIZACIÓN
            ).first()
        else:
            # Si organizacion_id no existe, la migración aún no se ha ejecutado
            raise HTTPException(
                status_code=500,
                detail="Error de configuración: La migración de base de datos no se ha ejecutado. Contacta al administrador."
            )
        if not difusora:
            raise HTTPException(status_code=404, detail="Difusora no encontrada")
        return difusora
        
    except HTTPException:
        raise
    except Exception as e:

        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.post("/", response_model=DifusoraSchema)
async def create_difusora(
    difusora: DifusoraCreate, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user)
):
    """
    Crear una nueva difusora (asignada automáticamente a la organización del usuario)
    """
    try:
        # Verificar si ya existe una difusora con las mismas siglas en la misma organización
        existing_difusora = db.query(Difusora).filter(
            Difusora.siglas == difusora.siglas,
            Difusora.organizacion_id == usuario.organizacion_id  # ← FILTRO POR ORGANIZACIÓN
        ).first()
        if existing_difusora:
            raise HTTPException(status_code=400, detail="Ya existe una difusora con esas siglas en tu organización")
        
        # Crear nueva difusora con organizacion_id del usuario
        difusora_data = difusora.dict()
        # Asignar organizacion_id del usuario
        try:
            if hasattr(usuario, 'organizacion_id') and usuario.organizacion_id:
                difusora_data['organizacion_id'] = usuario.organizacion_id
            else:
                # Si organizacion_id no existe, la migración aún no se ha ejecutado
                raise HTTPException(
                    status_code=500,
                    detail="Error de configuración: La migración de base de datos no se ha ejecutado. Contacta al administrador."
                )
        except AttributeError:
            raise HTTPException(
                status_code=500,
                detail="Error de configuración: La migración de base de datos no se ha ejecutado. Contacta al administrador."
            )
        db_difusora = Difusora(**difusora_data)
        db.add(db_difusora)
        db.commit()
        db.refresh(db_difusora)
        

        return db_difusora
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()

        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.put("/{difusora_id}", response_model=DifusoraSchema)
async def update_difusora(
    difusora_id: int, 
    difusora_update: DifusoraUpdate, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user)
):
    """
    Actualizar una difusora existente (solo de la organización del usuario)
    """
    try:
        # Buscar la difusora de la organización del usuario
        db_difusora = db.query(Difusora).filter(
            Difusora.id == difusora_id,
            Difusora.organizacion_id == usuario.organizacion_id  # ← FILTRO POR ORGANIZACIÓN
        ).first()
        if not db_difusora:
            raise HTTPException(status_code=404, detail="Difusora no encontrada")
        
        # Verificar si las siglas ya existen en otra difusora de la misma organización
        if difusora_update.siglas and difusora_update.siglas != db_difusora.siglas:
            existing_difusora = db.query(Difusora).filter(
                Difusora.siglas == difusora_update.siglas,
                Difusora.id != difusora_id,
                Difusora.organizacion_id == usuario.organizacion_id  # ← FILTRO POR ORGANIZACIÓN
            ).first()
            if existing_difusora:
                raise HTTPException(status_code=400, detail="Ya existe una difusora con esas siglas en tu organización")
        
        # Actualizar solo los campos proporcionados
        update_data = difusora_update.dict(exclude_unset=True)
        for field, value in update_data.items():
            setattr(db_difusora, field, value)
        
        db.commit()
        db.refresh(db_difusora)
        

        return db_difusora
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()

        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.delete("/{difusora_id}")
async def delete_difusora(
    difusora_id: int, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user)
):
    """
    Eliminar una difusora (solo de la organización del usuario)
    """
    try:
        # Buscar la difusora de la organización del usuario
        db_difusora = db.query(Difusora).filter(
            Difusora.id == difusora_id,
            Difusora.organizacion_id == usuario.organizacion_id  # ← FILTRO POR ORGANIZACIÓN
        ).first()
        if not db_difusora:
            raise HTTPException(status_code=404, detail="Difusora no encontrada")
        
        # Eliminar la difusora
        db.delete(db_difusora)
        db.commit()
        

        return {"message": "Difusora eliminada correctamente"}
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()

        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.get("/stats/summary")
async def get_difusoras_stats(
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user)
):
    """
    Obtener estadísticas de difusoras (solo de la organización del usuario)
    """
    try:
        # Filtrar por organización
        query = db.query(Difusora).filter(Difusora.organizacion_id == usuario.organizacion_id)
        total = query.count()
        activas = query.filter(Difusora.activa == True).count()
        inactivas = total - activas
        
        return {
            "total": total,
            "activas": activas,
            "inactivas": inactivas
        }
        
    except Exception as e:

        raise HTTPException(status_code=500, detail="Error interno del servidor")

