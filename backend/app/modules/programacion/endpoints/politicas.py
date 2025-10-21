from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import or_, func
from app.core.database import get_db
from app.modules.programacion.models.programacion import (
    PoliticaProgramacion as PoliticaProgramacionModel, 
    Reloj as RelojModel, 
    EventoReloj as EventoRelojModel, 
    DiaModelo as DiaModeloModel, 
    RelojDiaModelo as RelojDiaModeloModel, 
    SetRegla as SetReglaModel, 
    Regla as ReglaModel
)
from app.modules.programacion.schemas.programacion import (
    PoliticaProgramacionCreate, PoliticaProgramacionUpdate, PoliticaProgramacion,
    RelojCreate, RelojUpdate, Reloj, RelojConEventos,
    EventoRelojCreate, EventoRelojUpdate, EventoReloj,
    DiaModeloCreate, DiaModeloUpdate, DiaModelo,
    RelojDiaModeloCreate, RelojDiaModeloUpdate, RelojDiaModelo,
    SetReglaCreate, SetReglaUpdate, SetRegla,
    ReglaCreate, ReglaUpdate, Regla,
    OrdenAsignacionCreate, OrdenAsignacionUpdate, OrdenAsignacion,
    PoliticaCompleta, PoliticasStats, RelojesStats
)
from typing import List, Optional
import logging

logger = logging.getLogger(__name__)
router = APIRouter()



# ============================================================================
# POLÍTICAS DE PROGRAMACIÓN
# ============================================================================

@router.get("/", response_model=List[PoliticaProgramacion])
async def get_politicas(
    db: Session = Depends(get_db),
    skip: int = Query(0, ge=0, description="Número de registros a omitir"),
    limit: int = Query(100, ge=1, le=1000, description="Número máximo de registros a retornar"),
    search: Optional[str] = Query(None, description="Término de búsqueda"),
    habilitada: Optional[bool] = Query(None, description="Filtrar por estado habilitado"),
    difusora: Optional[str] = Query(None, description="Filtrar por difusora")
):
    """Obtener lista de políticas de programación con filtros opcionales"""
    try:
        query = db.query(PoliticaProgramacionModel)
        
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
        logger.error(f"Error al obtener políticas: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.get("/{politica_id}", response_model=PoliticaCompleta)
async def get_politica(politica_id: int, db: Session = Depends(get_db)):
    """Obtener una política específica con todos sus datos relacionados"""
    try:
        politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == politica_id).first()
        if not politica:
            raise HTTPException(status_code=404, detail="Política no encontrada")
        return politica
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error al obtener política {politica_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.post("/", response_model=PoliticaProgramacion)
async def create_politica(politica: PoliticaProgramacionCreate, db: Session = Depends(get_db)):
    """Crear una nueva política de programación"""
    try:
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
        logger.error(f"Error al crear política: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.put("/{politica_id}", response_model=PoliticaProgramacion)
async def update_politica(politica_id: int, politica_update: PoliticaProgramacionUpdate, db: Session = Depends(get_db)):
    """Actualizar una política existente"""
    try:
        db_politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == politica_id).first()
        if not db_politica:
            raise HTTPException(status_code=404, detail="Política no encontrada")
        
        update_data = politica_update.dict(exclude_unset=True)
        for field, value in update_data.items():
            setattr(db_politica, field, value)
        
        db.commit()
        db.refresh(db_politica)
        return db_politica
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error al actualizar política {politica_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.delete("/{politica_id}")
async def delete_politica(politica_id: int, db: Session = Depends(get_db)):
    """Eliminar una política y todos sus datos relacionados"""
    try:
        db_politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == politica_id).first()
        if not db_politica:
            raise HTTPException(status_code=404, detail="Política no encontrada")
        
        db.delete(db_politica)
        db.commit()
        return {"message": "Política eliminada correctamente"}
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error al eliminar política {politica_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.get("/stats/summary", response_model=PoliticasStats)
async def get_politicas_stats(db: Session = Depends(get_db)):
    """Obtener estadísticas de políticas de programación"""
    try:
        total = db.query(PoliticaProgramacionModel).count()
        habilitadas = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.habilitada == True).count()
        deshabilitadas = total - habilitadas
        
        # Estadísticas por difusora
        por_difusora = {}
        difusoras = db.query(PoliticaProgramacionModel.difusora, func.count(PoliticaProgramacionModel.id)).group_by(PoliticaProgramacionModel.difusora).all()
        for difusora, count in difusoras:
            por_difusora[difusora] = count
        
        return PoliticasStats(
            total=total,
            habilitadas=habilitadas,
            deshabilitadas=deshabilitadas,
            por_difusora=por_difusora
        )
        
    except Exception as e:
        logger.error(f"Error al obtener estadísticas de políticas: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

# ============================================================================
# RELOJES
# ============================================================================

@router.get("/{politica_id}/relojes", response_model=List[RelojConEventos])
async def get_relojes_by_politica(politica_id: int, db: Session = Depends(get_db)):
    """Obtener todos los relojes de una política específica"""
    try:
        relojes = db.query(RelojModel).filter(RelojModel.politica_id == politica_id).all()
        return relojes
        
    except Exception as e:
        logger.error(f"Error al obtener relojes de política {politica_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.post("/{politica_id}/relojes", response_model=Reloj)
async def create_reloj(politica_id: int, reloj: RelojCreate, db: Session = Depends(get_db)):
    """Crear un nuevo reloj para una política"""
    try:
        # Verificar que la política existe
        politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == politica_id).first()
        if not politica:
            raise HTTPException(status_code=404, detail="Política no encontrada")
        
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
        logger.error(f"Error al crear reloj: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.put("/relojes/{reloj_id}", response_model=Reloj)
async def update_reloj(reloj_id: int, reloj_update: RelojUpdate, db: Session = Depends(get_db)):
    """Actualizar un reloj existente"""
    try:
        db_reloj = db.query(RelojModel).filter(RelojModel.id == reloj_id).first()
        if not db_reloj:
            raise HTTPException(status_code=404, detail="Reloj no encontrado")
        
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
        logger.error(f"Error al actualizar reloj {reloj_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.delete("/relojes/{reloj_id}")
async def delete_reloj(reloj_id: int, db: Session = Depends(get_db)):
    """Eliminar un reloj y todos sus eventos"""
    try:
        db_reloj = db.query(RelojModel).filter(RelojModel.id == reloj_id).first()
        if not db_reloj:
            raise HTTPException(status_code=404, detail="Reloj no encontrado")
        
        db.delete(db_reloj)
        db.commit()
        return {"message": "Reloj eliminado correctamente"}
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error al eliminar reloj {reloj_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

# ============================================================================
# EVENTOS DE RELOJ
# ============================================================================

@router.get("/relojes/{reloj_id}/eventos", response_model=List[EventoReloj])
async def get_eventos_by_reloj(reloj_id: int, db: Session = Depends(get_db)):
    """Obtener todos los eventos de un reloj específico"""
    try:
        reloj = db.query(RelojModel).filter(RelojModel.id == reloj_id).first()
        if not reloj:
            raise HTTPException(status_code=404, detail="Reloj no encontrado")
        
        eventos = db.query(EventoRelojModel).filter(EventoRelojModel.reloj_id == reloj_id).order_by(EventoRelojModel.orden).all()
        return eventos
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error al obtener eventos del reloj {reloj_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.post("/relojes/{reloj_id}/eventos", response_model=EventoReloj)
async def create_evento(reloj_id: int, evento: EventoRelojCreate, db: Session = Depends(get_db)):
    """Crear un nuevo evento para un reloj"""
    try:
        # Verificar que el reloj existe
        reloj = db.query(RelojModel).filter(RelojModel.id == reloj_id).first()
        if not reloj:
            raise HTTPException(status_code=404, detail="Reloj no encontrado")
        
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
        logger.error(f"Error al crear evento para reloj {reloj_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.put("/eventos/{evento_id}", response_model=EventoReloj)
async def update_evento(evento_id: int, evento_update: EventoRelojUpdate, db: Session = Depends(get_db)):
    """Actualizar un evento existente"""
    try:
        db_evento = db.query(EventoRelojModel).filter(EventoRelojModel.id == evento_id).first()
        if not db_evento:
            raise HTTPException(status_code=404, detail="Evento no encontrado")
        
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
        logger.error(f"Error al actualizar evento {evento_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.delete("/eventos/{evento_id}")
async def delete_evento(evento_id: int, db: Session = Depends(get_db)):
    """Eliminar un evento"""
    try:
        db_evento = db.query(EventoRelojModel).filter(EventoRelojModel.id == evento_id).first()
        if not db_evento:
            raise HTTPException(status_code=404, detail="Evento no encontrado")
        
        db.delete(db_evento)
        db.commit()
        return {"message": "Evento eliminado correctamente"}
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error al eliminar evento {evento_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.put("/relojes/{reloj_id}/eventos/reordenar")
async def reordenar_eventos(reloj_id: int, eventos_orden: List[dict], db: Session = Depends(get_db)):
    """Reordenar eventos de un reloj"""
    try:
        # Verificar que el reloj existe
        reloj = db.query(RelojModel).filter(RelojModel.id == reloj_id).first()
        if not reloj:
            raise HTTPException(status_code=404, detail="Reloj no encontrado")
        
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
        logger.error(f"Error al reordenar eventos del reloj {reloj_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

# ============================================================================
# DÍAS MODELO
# ============================================================================

@router.get("/{politica_id}/dias-modelo", response_model=List[DiaModelo])
async def get_dias_modelo_by_politica(politica_id: int, db: Session = Depends(get_db)):
    """Obtener todos los días modelo de una política específica"""
    try:
        politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == politica_id).first()
        if not politica:
            raise HTTPException(status_code=404, detail="Política no encontrada")
        
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
        logger.error(f"Error al obtener días modelo de política {politica_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.post("/{politica_id}/dias-modelo", response_model=DiaModelo)
async def create_dia_modelo(politica_id: int, dia_modelo: DiaModeloCreate, db: Session = Depends(get_db)):
    """Crear un nuevo día modelo para una política"""
    try:
        # Verificar que la política existe
        politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == politica_id).first()
        if not politica:
            raise HTTPException(status_code=404, detail="Política no encontrada")
        
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
        logger.error(f"Error al crear día modelo para política {politica_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.put("/dias-modelo/{dia_modelo_id}", response_model=DiaModelo)
async def update_dia_modelo(dia_modelo_id: int, dia_modelo_update: DiaModeloUpdate, db: Session = Depends(get_db)):
    """Actualizar un día modelo existente"""
    try:
        db_dia_modelo = db.query(DiaModeloModel).filter(DiaModeloModel.id == dia_modelo_id).first()
        if not db_dia_modelo:
            raise HTTPException(status_code=404, detail="Día modelo no encontrado")
        
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
        logger.error(f"Error al actualizar día modelo {dia_modelo_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.delete("/dias-modelo/{dia_modelo_id}")
async def delete_dia_modelo(dia_modelo_id: int, db: Session = Depends(get_db)):
    """Eliminar un día modelo"""
    try:
        db_dia_modelo = db.query(DiaModeloModel).filter(DiaModeloModel.id == dia_modelo_id).first()
        if not db_dia_modelo:
            raise HTTPException(status_code=404, detail="Día modelo no encontrado")
        
        db.delete(db_dia_modelo)
        db.commit()
        return {"message": "Día modelo eliminado correctamente"}
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error al eliminar día modelo {dia_modelo_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

# ============================================================================
# ESTADÍSTICAS DE RELOJES
# ============================================================================

@router.get("/relojes/stats/summary", response_model=RelojesStats)
async def get_relojes_stats(db: Session = Depends(get_db)):
    """Obtener estadísticas de relojes"""
    try:
        total = db.query(RelojModel).count()
        habilitados = db.query(RelojModel).filter(RelojModel.habilitado == True).count()
        deshabilitados = total - habilitados
        con_eventos = db.query(RelojModel).filter(RelojModel.con_evento == True).count()
        sin_eventos = total - con_eventos
        
        # Estadísticas por política
        por_politica = {}
        politicas = db.query(RelojModel.politica_id, func.count(RelojModel.id)).group_by(RelojModel.politica_id).all()
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
        logger.error(f"Error al obtener estadísticas de relojes: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")




