from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import or_, func
from app.core.database import get_db
from app.core.auth import get_current_user, get_user_difusoras
from app.models.auth import Usuario
from typing import List
from app.models.programacion import (
    PoliticaProgramacion as PoliticaProgramacionModel, 
    Reloj as RelojModel, 
    EventoReloj as EventoRelojModel, 
    DiaModelo as DiaModeloModel, 
    RelojDiaModelo as RelojDiaModeloModel
)
from app.schemas.programacion import (
    PoliticaProgramacionCreate, PoliticaProgramacionUpdate, PoliticaProgramacion,
    RelojCreate, RelojUpdate, Reloj, RelojConEventos,
    EventoRelojCreate, EventoRelojUpdate, EventoReloj,
    DiaModeloCreate, DiaModeloUpdate, DiaModelo,
    RelojDiaModeloCreate, RelojDiaModeloUpdate, RelojDiaModelo,
    OrdenAsignacionCreate, OrdenAsignacionUpdate, OrdenAsignacion,
    PoliticaCompleta, PoliticasStats, RelojesStats
)
from typing import List, Optional

router = APIRouter()



# ============================================================================
# POLÍTICAS DE PROGRAMACIÓN
# ============================================================================

@router.get("/", response_model=List[PoliticaProgramacion])
async def get_politicas(
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras),
    skip: int = Query(0, ge=0, description="Número de registros a omitir"),
    limit: int = Query(100, ge=1, le=1000, description="Número máximo de registros a retornar"),
    search: Optional[str] = Query(None, description="Término de búsqueda"),
    habilitada: Optional[bool] = Query(None, description="Filtrar por estado habilitado"),
    difusora: Optional[str] = Query(None, description="Filtrar por difusora")
):
    """Obtener lista de políticas de programación con filtros opcionales"""
    try:
        query = db.query(PoliticaProgramacionModel)
        
        # Filtrar por difusoras permitidas (todos los usuarios, incluyendo admins)
        # Cada admin solo ve las políticas de sus propias difusoras asignadas (multi-tenancy)
        if difusoras_allowed:
            query = query.filter(PoliticaProgramacionModel.difusora.in_(difusoras_allowed))
        else:
            # Si no tiene difusoras asignadas, retornar lista vacía
            # Esto asegura el aislamiento por organización
            return []
        
        if search:
            search_term = f"%{search}%"
            query = query.filter(
                or_(
                    PoliticaProgramacionModel.clave.ilike(search_term),
                    PoliticaProgramacionModel.nombre.ilike(search_term),
                    PoliticaProgramacionModel.descripcion.ilike(search_term)
                )
            )
        
        if habilitada is not None:
            query = query.filter(PoliticaProgramacionModel.habilitada == habilitada)
        
        if difusora:
            query = query.filter(PoliticaProgramacionModel.difusora == difusora)
        
        politicas = query.offset(skip).limit(limit).all()
        return politicas
        
    except Exception as e:
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.get("/{politica_id}", response_model=PoliticaCompleta)
async def get_politica(
    politica_id: int, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Obtener una política específica con todos sus datos relacionados"""
    try:
        politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == politica_id).first()
        if not politica:
            raise HTTPException(status_code=404, detail="Política no encontrada")
        
        # Verificar que el usuario tiene acceso a la difusora de esta política
        if politica.difusora not in difusoras_allowed:
            raise HTTPException(
                status_code=403, 
                detail="No tienes permiso para acceder a esta política"
            )
        
        return politica
        
    except HTTPException:
        raise
    except Exception as e:

        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.post("/", response_model=PoliticaProgramacion)
async def create_politica(
    politica: PoliticaProgramacionCreate, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Crear una nueva política de programación (solo para difusoras del usuario y de su organización)"""
    try:
        from app.models.catalogos import Difusora
        from sqlalchemy import and_
        
        # Verificar que el usuario tiene acceso a la difusora
        if not difusoras_allowed:
            raise HTTPException(
                status_code=403,
                detail="No tienes difusoras asignadas. Contacta a un administrador."
            )
        
        if politica.difusora not in difusoras_allowed:
            raise HTTPException(
                status_code=403, 
                detail="No tienes permiso para crear políticas para esta difusora"
            )
        
        # Verificar que la difusora pertenece a la organización del usuario
        difusora_obj = db.query(Difusora).filter(
            Difusora.siglas == politica.difusora,
            Difusora.organizacion_id == usuario.organizacion_id
        ).first()
        
        if not difusora_obj:
            raise HTTPException(
                status_code=403,
                detail="La difusora no pertenece a tu organización"
            )
        
        # Verificar si ya existe una política con la misma clave
        existing = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.clave == politica.clave).first()
        if existing:
            raise HTTPException(status_code=400, detail="Ya existe una política con esa clave")
        
        db_politica = PoliticaProgramacionModel(**politica.dict())
        db.add(db_politica)
        db.commit()
        db.refresh(db_politica)
        return db_politica
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()

        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.put("/{politica_id}", response_model=PoliticaProgramacion)
async def update_politica(
    politica_id: int, 
    politica_update: PoliticaProgramacionUpdate, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Actualizar una política existente"""
    try:
        db_politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == politica_id).first()
        if not db_politica:
            raise HTTPException(status_code=404, detail="Política no encontrada")
        
        # Verificar que el usuario tiene acceso a la difusora de esta política
        if db_politica.difusora not in difusoras_allowed:
            raise HTTPException(
                status_code=403, 
                detail="No tienes permiso para modificar esta política"
            )
        
        # Si se está cambiando la difusora, verificar que el usuario tiene acceso a la nueva difusora
        update_data = politica_update.dict(exclude_unset=True)
        if 'difusora' in update_data and update_data['difusora'] not in difusoras_allowed:
            raise HTTPException(
                status_code=403, 
                detail="No tienes permiso para asignar políticas a esta difusora"
            )
        
        for field, value in update_data.items():
            setattr(db_politica, field, value)
        
        db.commit()
        db.refresh(db_politica)
        return db_politica
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()

        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.delete("/{politica_id}")
async def delete_politica(
    politica_id: int, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Eliminar una política y todos sus datos relacionados"""
    try:
        db_politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == politica_id).first()
        if not db_politica:
            raise HTTPException(status_code=404, detail="Política no encontrada")
        
        # Verificar que el usuario tiene acceso a la difusora de esta política
        if db_politica.difusora not in difusoras_allowed:
            raise HTTPException(
                status_code=403, 
                detail="No tienes permiso para eliminar esta política"
            )
        
        db.delete(db_politica)
        db.commit()
        return {"message": "Política eliminada correctamente"}
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()

        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.get("/stats/summary", response_model=PoliticasStats)
async def get_politicas_stats(
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Obtener estadísticas de políticas de programación (solo de las difusoras del usuario)"""
    try:
        # Filtrar por difusoras permitidas
        query = db.query(PoliticaProgramacionModel)
        if difusoras_allowed:
            query = query.filter(PoliticaProgramacionModel.difusora.in_(difusoras_allowed))
        else:
            # Si no tiene difusoras asignadas, retornar estadísticas vacías
            return PoliticasStats(
                total=0,
                habilitadas=0,
                deshabilitadas=0,
                por_difusora={}
            )
        
        total = query.count()
        habilitadas = query.filter(PoliticaProgramacionModel.habilitada == True).count()
        deshabilitadas = total - habilitadas
        
        # Estadísticas por difusora (solo de las difusoras permitidas)
        por_difusora = {}
        difusoras = query.with_entities(
            PoliticaProgramacionModel.difusora, 
            func.count(PoliticaProgramacionModel.id)
        ).group_by(PoliticaProgramacionModel.difusora).all()
        for difusora, count in difusoras:
            por_difusora[difusora] = count
        
        return PoliticasStats(
            total=total,
            habilitadas=habilitadas,
            deshabilitadas=deshabilitadas,
            por_difusora=por_difusora
        )
        
    except Exception as e:

        raise HTTPException(status_code=500, detail="Error interno del servidor")

# ============================================================================
# RELOJES
# ============================================================================

@router.get("/{politica_id}/relojes", response_model=List[RelojConEventos])
async def get_relojes_by_politica(
    politica_id: int, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Obtener todos los relojes de una política específica (solo si la política pertenece a las difusoras del usuario)"""
    try:
        # Verificar que la política pertenece a una difusora del usuario
        politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == politica_id).first()
        if not politica:
            raise HTTPException(status_code=404, detail="Política no encontrada")
        
        if politica.difusora not in difusoras_allowed:
            raise HTTPException(
                status_code=403,
                detail="No tienes permiso para acceder a esta política"
            )
        
        relojes = db.query(RelojModel).filter(RelojModel.politica_id == politica_id).all()
        return relojes
        
    except Exception as e:

        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.post("/{politica_id}/relojes", response_model=Reloj)
async def create_reloj(
    politica_id: int, 
    reloj: RelojCreate, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Crear un nuevo reloj para una política (solo si la política pertenece a las difusoras del usuario)"""
    try:
        # Verificar que la política existe y pertenece a una difusora del usuario
        politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == politica_id).first()
        if not politica:
            raise HTTPException(status_code=404, detail="Política no encontrada")
        
        if politica.difusora not in difusoras_allowed:
            raise HTTPException(
                status_code=403,
                detail="No tienes permiso para crear relojes para esta política"
            )
        
        # Verificar si ya existe un reloj con la misma clave
        existing = db.query(RelojModel).filter(RelojModel.clave == reloj.clave).first()
        if existing:
            raise HTTPException(status_code=400, detail="Ya existe un reloj con esa clave")
        
        reloj_data = reloj.dict()
        reloj_data['politica_id'] = politica_id
        db_reloj = RelojModel(**reloj_data)
        db.add(db_reloj)
        db.commit()
        db.refresh(db_reloj)
        return db_reloj
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()

        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.put("/relojes/{reloj_id}", response_model=Reloj)
async def update_reloj(
    reloj_id: int, 
    reloj_update: RelojUpdate, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Actualizar un reloj existente (solo si la política pertenece a las difusoras del usuario)"""
    try:
        db_reloj = db.query(RelojModel).filter(RelojModel.id == reloj_id).first()
        if not db_reloj:
            raise HTTPException(status_code=404, detail="Reloj no encontrado")
        
        # Verificar que la política del reloj pertenece a una difusora del usuario
        politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == db_reloj.politica_id).first()
        if not politica or politica.difusora not in difusoras_allowed:
            raise HTTPException(
                status_code=403,
                detail="No tienes permiso para actualizar este reloj"
            )
        
        update_data = reloj_update.dict(exclude_unset=True)
        for field, value in update_data.items():
            setattr(db_reloj, field, value)
        
        db.commit()
        db.refresh(db_reloj)
        return db_reloj
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()

        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.delete("/relojes/{reloj_id}")
async def delete_reloj(
    reloj_id: int, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Eliminar un reloj y todos sus eventos (solo si la política pertenece a las difusoras del usuario)"""
    try:
        db_reloj = db.query(RelojModel).filter(RelojModel.id == reloj_id).first()
        if not db_reloj:
            raise HTTPException(status_code=404, detail="Reloj no encontrado")
        
        # Verificar que la política del reloj pertenece a una difusora del usuario
        politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == db_reloj.politica_id).first()
        if not politica or politica.difusora not in difusoras_allowed:
            raise HTTPException(
                status_code=403,
                detail="No tienes permiso para eliminar este reloj"
            )
        
        db.delete(db_reloj)
        db.commit()
        return {"message": "Reloj eliminado correctamente"}
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()

        raise HTTPException(status_code=500, detail="Error interno del servidor")

# ============================================================================
# EVENTOS DE RELOJ
# ============================================================================

@router.get("/relojes/{reloj_id}/eventos", response_model=List[EventoReloj])
async def get_eventos_by_reloj(
    reloj_id: int, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Obtener todos los eventos de un reloj específico (solo si la política pertenece a las difusoras del usuario)"""
    try:
        reloj = db.query(RelojModel).filter(RelojModel.id == reloj_id).first()
        if not reloj:
            raise HTTPException(status_code=404, detail="Reloj no encontrado")
        
        # Verificar que la política del reloj pertenece a una difusora del usuario
        politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == reloj.politica_id).first()
        if not politica or politica.difusora not in difusoras_allowed:
            raise HTTPException(
                status_code=403,
                detail="No tienes permiso para acceder a este reloj"
            )
        
        eventos = db.query(EventoRelojModel).filter(EventoRelojModel.reloj_id == reloj_id).order_by(EventoRelojModel.orden).all()
        return eventos
        
    except HTTPException:
        raise
    except Exception as e:

        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.post("/relojes/{reloj_id}/eventos", response_model=EventoReloj)
async def create_evento(
    reloj_id: int, 
    evento: EventoRelojCreate, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Crear un nuevo evento para un reloj (solo si la política pertenece a las difusoras del usuario)"""
    try:
        # Verificar que el reloj existe y su política pertenece a una difusora del usuario
        reloj = db.query(RelojModel).filter(RelojModel.id == reloj_id).first()
        if not reloj:
            raise HTTPException(status_code=404, detail="Reloj no encontrado")
        
        # Verificar que la política del reloj pertenece a una difusora del usuario
        politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == reloj.politica_id).first()
        if not politica or politica.difusora not in difusoras_allowed:
            raise HTTPException(
                status_code=403,
                detail="No tienes permiso para crear eventos en este reloj"
            )
        
        evento_data = evento.dict()
        evento_data['reloj_id'] = reloj_id
        db_evento = EventoRelojModel(**evento_data)
        db.add(db_evento)
        db.commit()
        db.refresh(db_evento)
        return db_evento
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()

        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.put("/eventos/{evento_id}", response_model=EventoReloj)
async def update_evento(
    evento_id: int, 
    evento_update: EventoRelojUpdate, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Actualizar un evento existente (solo si la política pertenece a las difusoras del usuario)"""
    try:
        db_evento = db.query(EventoRelojModel).filter(EventoRelojModel.id == evento_id).first()
        if not db_evento:
            raise HTTPException(status_code=404, detail="Evento no encontrado")
        
        # Verificar que el reloj del evento pertenece a una política del usuario
        reloj = db.query(RelojModel).filter(RelojModel.id == db_evento.reloj_id).first()
        if reloj:
            politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == reloj.politica_id).first()
            if not politica or politica.difusora not in difusoras_allowed:
                raise HTTPException(
                    status_code=403,
                    detail="No tienes permiso para actualizar este evento"
                )
        
        update_data = evento_update.dict(exclude_unset=True)
        for field, value in update_data.items():
            setattr(db_evento, field, value)
        
        db.commit()
        db.refresh(db_evento)
        return db_evento
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()

        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.delete("/eventos/{evento_id}")
async def delete_evento(
    evento_id: int, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Eliminar un evento (solo si la política pertenece a las difusoras del usuario)"""
    try:
        db_evento = db.query(EventoRelojModel).filter(EventoRelojModel.id == evento_id).first()
        if not db_evento:
            raise HTTPException(status_code=404, detail="Evento no encontrado")
        
        # Verificar que el reloj del evento pertenece a una política del usuario
        reloj = db.query(RelojModel).filter(RelojModel.id == db_evento.reloj_id).first()
        if reloj:
            politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == reloj.politica_id).first()
            if not politica or politica.difusora not in difusoras_allowed:
                raise HTTPException(
                    status_code=403,
                    detail="No tienes permiso para eliminar este evento"
                )
        
        db.delete(db_evento)
        db.commit()
        return {"message": "Evento eliminado correctamente"}
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()

        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.put("/relojes/{reloj_id}/eventos/reordenar")
async def reordenar_eventos(
    reloj_id: int, 
    eventos_orden: List[dict], 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Reordenar eventos de un reloj (solo si la política pertenece a las difusoras del usuario)"""
    try:
        # Verificar que el reloj existe y su política pertenece a una difusora del usuario
        reloj = db.query(RelojModel).filter(RelojModel.id == reloj_id).first()
        if not reloj:
            raise HTTPException(status_code=404, detail="Reloj no encontrado")
        
        # Verificar que la política del reloj pertenece a una difusora del usuario
        politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == reloj.politica_id).first()
        if not politica or politica.difusora not in difusoras_allowed:
            raise HTTPException(
                status_code=403,
                detail="No tienes permiso para reordenar eventos de este reloj"
            )
        
        # Actualizar el orden de cada evento
        for i, evento_data in enumerate(eventos_orden):
            evento_id = evento_data.get('id')
            if evento_id:
                db_evento = db.query(EventoRelojModel).filter(EventoRelojModel.id == evento_id).first()
                if db_evento:
                    db_evento.orden = i + 1
        
        db.commit()
        return {"message": "Eventos reordenados correctamente"}
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()

        raise HTTPException(status_code=500, detail="Error interno del servidor")

# ============================================================================
# DÍAS MODELO
# ============================================================================

@router.get("/{politica_id}/dias-modelo", response_model=List[DiaModelo])
async def get_dias_modelo_by_politica(
    politica_id: int, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Obtener todos los días modelo de una política específica (solo si la política pertenece a las difusoras del usuario)"""
    try:
        politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == politica_id).first()
        if not politica:
            raise HTTPException(status_code=404, detail="Política no encontrada")
        
        if politica.difusora not in difusoras_allowed:
            raise HTTPException(
                status_code=403,
                detail="No tienes permiso para acceder a esta política"
            )
        
        dias_modelo = db.query(DiaModeloModel).filter(DiaModeloModel.politica_id == politica_id).all()
        
        # Cargar relojes asociados para cada día modelo
        for dia in dias_modelo:
            relojes_relacion = db.query(RelojDiaModeloModel).filter(RelojDiaModeloModel.dia_modelo_id == dia.id).all()
            relojes_ids = [rel.reloj_id for rel in relojes_relacion]
            
            # Obtener los objetos Reloj completos
            relojes = db.query(RelojModel).filter(RelojModel.id.in_(relojes_ids)).all()
            dia.relojes = relojes
        
        return dias_modelo
        
    except HTTPException:
        raise
    except Exception as e:

        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.post("/{politica_id}/dias-modelo", response_model=DiaModelo)
async def create_dia_modelo(
    politica_id: int, 
    dia_modelo: DiaModeloCreate, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Crear un nuevo día modelo para una política (solo si la política pertenece a las difusoras del usuario)"""
    try:
        # Verificar que la política existe y pertenece a una difusora del usuario
        politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == politica_id).first()
        if not politica:
            raise HTTPException(status_code=404, detail="Política no encontrada")
        
        if politica.difusora not in difusoras_allowed:
            raise HTTPException(
                status_code=403,
                detail="No tienes permiso para crear días modelo para esta política"
            )
        
        # Verificar si ya existe un día modelo con la misma clave
        existing = db.query(DiaModeloModel).filter(DiaModeloModel.clave == dia_modelo.clave).first()
        if existing:
            raise HTTPException(status_code=400, detail="Ya existe un día modelo con esa clave")
        
        dia_modelo_data = dia_modelo.dict()
        
        # Manejar relojes por separado
        relojes_ids = dia_modelo_data.pop('relojes', None)
        
        # Crear el día modelo
        dia_modelo_data['politica_id'] = politica_id
        db_dia_modelo = DiaModeloModel(**dia_modelo_data)
        db.add(db_dia_modelo)
        db.commit()
        db.refresh(db_dia_modelo)
        
        # Crear relaciones con relojes si se proporcionan
        if relojes_ids:
            for reloj_id in relojes_ids:
                reloj_dia_modelo = RelojDiaModeloModel(
                    dia_modelo_id=db_dia_modelo.id,
                    reloj_id=reloj_id
                )
                db.add(reloj_dia_modelo)
            db.commit()
        
        # Cargar relojes asociados
        relojes_relacion = db.query(RelojDiaModeloModel).filter(RelojDiaModeloModel.dia_modelo_id == db_dia_modelo.id).all()
        relojes_ids = [rel.reloj_id for rel in relojes_relacion]
        
        # Obtener los objetos Reloj completos
        relojes = db.query(RelojModel).filter(RelojModel.id.in_(relojes_ids)).all()
        db_dia_modelo.relojes = relojes
        
        return db_dia_modelo
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()

        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.put("/dias-modelo/{dia_modelo_id}", response_model=DiaModelo)
async def update_dia_modelo(
    dia_modelo_id: int, 
    dia_modelo_update: DiaModeloUpdate, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Actualizar un día modelo existente (solo si la política pertenece a las difusoras del usuario)"""
    try:
        db_dia_modelo = db.query(DiaModeloModel).filter(DiaModeloModel.id == dia_modelo_id).first()
        if not db_dia_modelo:
            raise HTTPException(status_code=404, detail="Día modelo no encontrado")
        
        # Verificar que la política del día modelo pertenece a una difusora del usuario
        politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == db_dia_modelo.politica_id).first()
        if not politica or politica.difusora not in difusoras_allowed:
            raise HTTPException(
                status_code=403,
                detail="No tienes permiso para actualizar este día modelo"
            )
        
        update_data = dia_modelo_update.dict(exclude_unset=True)
        
        # Manejar relojes por separado
        relojes_ids = update_data.pop('relojes', None)
        
        # Actualizar campos del día modelo
        for field, value in update_data.items():
            setattr(db_dia_modelo, field, value)
        
        # Actualizar relojes si se proporcionan
        if relojes_ids is not None:
            # Eliminar relaciones existentes
            db.query(RelojDiaModeloModel).filter(RelojDiaModeloModel.dia_modelo_id == dia_modelo_id).delete()
            
            # Crear nuevas relaciones
            for reloj_id in relojes_ids:
                reloj_dia_modelo = RelojDiaModeloModel(
                    dia_modelo_id=dia_modelo_id,
                    reloj_id=reloj_id
                )
                db.add(reloj_dia_modelo)
        
        db.commit()
        db.refresh(db_dia_modelo)
        
        # Cargar relojes asociados
        relojes_relacion = db.query(RelojDiaModeloModel).filter(RelojDiaModeloModel.dia_modelo_id == dia_modelo_id).all()
        relojes_ids = [rel.reloj_id for rel in relojes_relacion]
        
        # Obtener los objetos Reloj completos
        relojes = db.query(RelojModel).filter(RelojModel.id.in_(relojes_ids)).all()
        db_dia_modelo.relojes = relojes
        
        return db_dia_modelo
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()

        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.delete("/dias-modelo/{dia_modelo_id}")
async def delete_dia_modelo(
    dia_modelo_id: int, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Eliminar un día modelo (solo si la política pertenece a las difusoras del usuario)"""
    try:
        db_dia_modelo = db.query(DiaModeloModel).filter(DiaModeloModel.id == dia_modelo_id).first()
        if not db_dia_modelo:
            raise HTTPException(status_code=404, detail="Día modelo no encontrado")
        
        # Verificar que la política del día modelo pertenece a una difusora del usuario
        politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == db_dia_modelo.politica_id).first()
        if not politica or politica.difusora not in difusoras_allowed:
            raise HTTPException(
                status_code=403,
                detail="No tienes permiso para eliminar este día modelo"
            )
        
        db.delete(db_dia_modelo)
        db.commit()
        return {"message": "Día modelo eliminado correctamente"}
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()

        raise HTTPException(status_code=500, detail="Error interno del servidor")

# ============================================================================
# ESTADÍSTICAS DE RELOJES
# ============================================================================

@router.get("/relojes/stats/summary", response_model=RelojesStats)
async def get_relojes_stats(
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Obtener estadísticas de relojes (solo de políticas de las difusoras del usuario)"""
    try:
        # Filtrar relojes por políticas de las difusoras del usuario
        if not difusoras_allowed:
            return RelojesStats(
                total=0,
                habilitados=0,
                deshabilitados=0,
                con_eventos=0,
                sin_eventos=0,
                por_politica={}
            )
        
        # Obtener IDs de políticas de las difusoras permitidas
        politicas_ids = db.query(PoliticaProgramacionModel.id).filter(
            PoliticaProgramacionModel.difusora.in_(difusoras_allowed)
        ).all()
        politicas_ids_list = [p[0] for p in politicas_ids]
        
        if not politicas_ids_list:
            return RelojesStats(
                total=0,
                habilitados=0,
                deshabilitados=0,
                con_eventos=0,
                sin_eventos=0,
                por_politica={}
            )
        
        query = db.query(RelojModel).filter(RelojModel.politica_id.in_(politicas_ids_list))
        total = query.count()
        habilitados = query.filter(RelojModel.habilitado == True).count()
        deshabilitados = total - habilitados
        con_eventos = query.filter(RelojModel.con_evento == True).count()
        sin_eventos = total - con_eventos
        
        # Estadísticas por política (solo de las políticas permitidas)
        por_politica = {}
        politicas = query.with_entities(
            RelojModel.politica_id, 
            func.count(RelojModel.id)
        ).group_by(RelojModel.politica_id).all()
        for politica_id, count in politicas:
            por_politica[str(politica_id)] = count
        
        return RelojesStats(
            total=total,
            habilitados=habilitados,
            deshabilitados=deshabilitados,
            con_eventos=con_eventos,
            sin_eventos=sin_eventos,
            por_politica=por_politica
        )
        
    except Exception as e:

        raise HTTPException(status_code=500, detail="Error interno del servidor")




