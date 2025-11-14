"""
Endpoints para estadísticas y reportes de programación
"""
from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func, and_, case, cast, Integer
from datetime import date, datetime, timedelta
from typing import Optional, List
from pydantic import BaseModel

from app.core.database import get_db
from app.core.auth import get_current_user, get_user_difusoras
from app.models.auth import Usuario
from app.models.programacion import Programacion as ProgramacionModel, PoliticaProgramacion
from app.models.categorias import Cancion, Categoria

router = APIRouter()


# Schemas para las respuestas
class EstadisticaCategoria(BaseModel):
    categoria: str
    cantidad_reproducciones: int
    tiempo_total_segundos: int
    tiempo_total_formato: str
    porcentaje_reproducciones: float
    porcentaje_tiempo: float

class EstadisticaCancion(BaseModel):
    cancion_id: str
    titulo: str
    artista: str
    album: str
    categoria: str
    cantidad_reproducciones: int
    tiempo_total_segundos: int
    tiempo_total_formato: str

class EstadisticaArtista(BaseModel):
    artista: str
    cantidad_reproducciones: int
    cantidad_canciones_unicas: int
    tiempo_total_segundos: int
    tiempo_total_formato: str

class EstadisticaAlbum(BaseModel):
    album: str
    artista: str
    cantidad_reproducciones: int
    cantidad_canciones_unicas: int
    tiempo_total_segundos: int
    tiempo_total_formato: str

class DistribucionHoraria(BaseModel):
    hora: int
    cantidad_eventos: int
    cantidad_canciones: int
    tiempo_total_segundos: int

class DistribucionDiaSemana(BaseModel):
    dia_semana: str
    dia_numero: int
    cantidad_eventos: int
    cantidad_canciones: int
    tiempo_total_segundos: int

class EstadisticaGeneral(BaseModel):
    total_eventos: int
    total_canciones: int
    total_cortes_comerciales: int
    total_etm: int
    tiempo_total_segundos: int
    tiempo_total_formato: str
    rango_fechas: dict
    cantidad_difusoras: int
    cantidad_politicas: int

class EstadisticaDifusora(BaseModel):
    difusora: str
    cantidad_eventos: int
    cantidad_canciones: int
    tiempo_total_segundos: int
    tiempo_total_formato: str

class EstadisticaPolitica(BaseModel):
    politica_id: int
    politica_nombre: str
    cantidad_eventos: int
    cantidad_canciones: int
    tiempo_total_segundos: int
    tiempo_total_formato: str


def parse_duration_to_seconds(duration_str: str) -> int:
    """Convierte una duración HH:MM:SS a segundos"""
    if not duration_str:
        return 0
    try:
        parts = duration_str.split(':')
        if len(parts) == 3:
            hours, minutes, seconds = map(int, parts)
            return hours * 3600 + minutes * 60 + seconds
        elif len(parts) == 2:
            minutes, seconds = map(int, parts)
            return minutes * 60 + seconds
        else:
            return int(duration_str) if duration_str.isdigit() else 0
    except:
        return 0


def format_seconds_to_time(seconds: int) -> str:
    """Convierte segundos a formato HH:MM:SS"""
    hours = seconds // 3600
    minutes = (seconds % 3600) // 60
    secs = seconds % 60
    return f"{hours:02d}:{minutes:02d}:{secs:02d}"


def get_date_range(fecha_inicio: Optional[date], fecha_fin: Optional[date]) -> tuple:
    """Obtiene el rango de fechas, usando defaults si no se proporcionan"""
    if not fecha_inicio:
        fecha_inicio = date.today() - timedelta(days=30)
    if not fecha_fin:
        fecha_fin = date.today()
    return fecha_inicio, fecha_fin


def get_base_filters(
    db: Session,
    fecha_inicio: Optional[date] = None,
    fecha_fin: Optional[date] = None,
    difusora: Optional[str] = None,
    politica_id: Optional[int] = None,
    difusoras_allowed: Optional[list] = None,
    usuario_rol: Optional[str] = None
):
    """Obtiene los filtros base para las consultas"""
    query = db.query(ProgramacionModel)
    
    fecha_inicio, fecha_fin = get_date_range(fecha_inicio, fecha_fin)
    query = query.filter(
        and_(
            ProgramacionModel.fecha >= fecha_inicio,
            ProgramacionModel.fecha <= fecha_fin
        )
    )
    
    # Filtrar por difusoras permitidas (todos los usuarios, incluyendo admins)
    # Cada admin solo ve las programaciones de sus propias difusoras asignadas (multi-tenancy)
    if difusoras_allowed:
        query = query.filter(ProgramacionModel.difusora.in_(difusoras_allowed))
    else:
        # Si no tiene difusoras asignadas, retornar query vacío
        # Esto asegura el aislamiento por organización
        query = query.filter(False)  # Esto retorna 0 resultados
    
    if difusora:
        query = query.filter(ProgramacionModel.difusora == difusora)
    
    if politica_id:
        query = query.filter(ProgramacionModel.politica_id == politica_id)
    
    return query


@router.get("/estadisticas/general", response_model=EstadisticaGeneral)
async def get_estadisticas_general(
    fecha_inicio: Optional[date] = Query(None, description="Fecha de inicio (YYYY-MM-DD)"),
    fecha_fin: Optional[date] = Query(None, description="Fecha de fin (YYYY-MM-DD)"),
    difusora: Optional[str] = Query(None, description="Filtrar por difusora"),
    politica_id: Optional[int] = Query(None, description="Filtrar por política"),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: list = Depends(get_user_difusoras),
    db: Session = Depends(get_db)
):
    """Obtiene estadísticas generales de la programación"""
    try:
        query = get_base_filters(
            db, fecha_inicio, fecha_fin, difusora, politica_id,
            difusoras_allowed=difusoras_allowed, usuario_rol=usuario.rol
        )
        
        total_eventos = query.count()
        total_canciones = query.filter(ProgramacionModel.mc == True).filter(
            ProgramacionModel.categoria != 'Corte Comercial'
        ).filter(ProgramacionModel.categoria != 'ETM').count()
        total_cortes = query.filter(ProgramacionModel.categoria == 'Corte Comercial').count()
        total_etm = query.filter(ProgramacionModel.categoria == 'ETM').count()
        
        # Calcular tiempo total
        eventos = query.all()
        tiempo_total = sum(parse_duration_to_seconds(e.duracion_real or "00:00:00") for e in eventos)
        
        # Rango de fechas
        fecha_inicio, fecha_fin = get_date_range(fecha_inicio, fecha_fin)
        
        # Cantidad de difusoras y políticas únicas
        difusoras_unicas = db.query(func.count(func.distinct(ProgramacionModel.difusora))).scalar()
        politicas_unicas = db.query(func.count(func.distinct(ProgramacionModel.politica_id))).filter(
            ProgramacionModel.politica_id.isnot(None)
        ).scalar()
        
        return EstadisticaGeneral(
            total_eventos=total_eventos,
            total_canciones=total_canciones,
            total_cortes_comerciales=total_cortes,
            total_etm=total_etm,
            tiempo_total_segundos=tiempo_total,
            tiempo_total_formato=format_seconds_to_time(tiempo_total),
            rango_fechas={
                "inicio": str(fecha_inicio),
                "fin": str(fecha_fin)
            },
            cantidad_difusoras=difusoras_unicas or 0,
            cantidad_politicas=politicas_unicas or 0
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error al obtener estadísticas generales: {str(e)}")


@router.get("/estadisticas/categorias", response_model=List[EstadisticaCategoria])
async def get_estadisticas_categorias(
    fecha_inicio: Optional[date] = Query(None),
    fecha_fin: Optional[date] = Query(None),
    difusora: Optional[str] = Query(None),
    politica_id: Optional[int] = Query(None),
    limite: int = Query(50, ge=1, le=200),
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: list = Depends(get_user_difusoras)
):
    """Obtiene estadísticas por categoría (solo de la organización del usuario)"""
    try:
        query = get_base_filters(db, fecha_inicio, fecha_fin, difusora, politica_id, difusoras_allowed=difusoras_allowed, usuario_rol=usuario.rol)
        eventos = query.filter(ProgramacionModel.categoria.isnot(None)).all()
        
        # Agrupar por categoría
        stats = {}
        total_eventos = len(eventos)
        tiempo_total_general = 0
        
        for evento in eventos:
            cat = evento.categoria or "Sin categoría"
            if cat not in stats:
                stats[cat] = {"cantidad": 0, "tiempo": 0}
            
            stats[cat]["cantidad"] += 1
            tiempo_evento = parse_duration_to_seconds(evento.duracion_real or "00:00:00")
            stats[cat]["tiempo"] += tiempo_evento
            tiempo_total_general += tiempo_evento
        
        # Convertir a lista y calcular porcentajes
        resultado = []
        for categoria, datos in sorted(stats.items(), key=lambda x: x[1]["cantidad"], reverse=True)[:limite]:
            porcentaje_reproducciones = (datos["cantidad"] / total_eventos * 100) if total_eventos > 0 else 0
            porcentaje_tiempo = (datos["tiempo"] / tiempo_total_general * 100) if tiempo_total_general > 0 else 0
            
            resultado.append(EstadisticaCategoria(
                categoria=categoria,
                cantidad_reproducciones=datos["cantidad"],
                tiempo_total_segundos=datos["tiempo"],
                tiempo_total_formato=format_seconds_to_time(datos["tiempo"]),
                porcentaje_reproducciones=round(porcentaje_reproducciones, 2),
                porcentaje_tiempo=round(porcentaje_tiempo, 2)
            ))
        
        return resultado
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error al obtener estadísticas por categoría: {str(e)}")


@router.get("/estadisticas/canciones", response_model=List[EstadisticaCancion])
async def get_estadisticas_canciones(
    fecha_inicio: Optional[date] = Query(None),
    fecha_fin: Optional[date] = Query(None),
    difusora: Optional[str] = Query(None),
    politica_id: Optional[int] = Query(None),
    categoria: Optional[str] = Query(None),
    limite: int = Query(100, ge=1, le=500),
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: list = Depends(get_user_difusoras)
):
    """Obtiene estadísticas por canción (solo de la organización del usuario)"""
    try:
        query = get_base_filters(db, fecha_inicio, fecha_fin, difusora, politica_id, difusoras_allowed=difusoras_allowed, usuario_rol=usuario.rol)
        query = query.filter(ProgramacionModel.mc == True).filter(
            ProgramacionModel.categoria != 'Corte Comercial'
        ).filter(ProgramacionModel.categoria != 'ETM').filter(ProgramacionModel.id_media.isnot(None))
        
        if categoria:
            query = query.filter(ProgramacionModel.categoria == categoria)
        
        eventos = query.all()
        
        # Agrupar por ID de media (canción)
        stats = {}
        for evento in eventos:
            cancion_id = evento.id_media
            if not cancion_id:
                continue
                
            if cancion_id not in stats:
                stats[cancion_id] = {
                    "cantidad": 0,
                    "tiempo": 0,
                    "titulo": evento.descripcion or "Sin título",
                    "artista": evento.interprete or "Sin artista",
                    "album": evento.disco or "Sin álbum",
                    "categoria": evento.categoria or "Sin categoría"
                }
            
            stats[cancion_id]["cantidad"] += 1
            tiempo_evento = parse_duration_to_seconds(evento.duracion_real or "00:00:00")
            stats[cancion_id]["tiempo"] += tiempo_evento
        
        # Convertir a lista
        resultado = []
        for cancion_id, datos in sorted(stats.items(), key=lambda x: x[1]["cantidad"], reverse=True)[:limite]:
            resultado.append(EstadisticaCancion(
                cancion_id=cancion_id,
                titulo=datos["titulo"],
                artista=datos["artista"],
                album=datos["album"],
                categoria=datos["categoria"],
                cantidad_reproducciones=datos["cantidad"],
                tiempo_total_segundos=datos["tiempo"],
                tiempo_total_formato=format_seconds_to_time(datos["tiempo"])
            ))
        
        return resultado
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error al obtener estadísticas por canción: {str(e)}")


@router.get("/estadisticas/artistas", response_model=List[EstadisticaArtista])
async def get_estadisticas_artistas(
    fecha_inicio: Optional[date] = Query(None),
    fecha_fin: Optional[date] = Query(None),
    difusora: Optional[str] = Query(None),
    politica_id: Optional[int] = Query(None),
    limite: int = Query(50, ge=1, le=200),
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: list = Depends(get_user_difusoras)
):
    """Obtiene estadísticas por artista (solo de la organización del usuario)"""
    try:
        query = get_base_filters(db, fecha_inicio, fecha_fin, difusora, politica_id, difusoras_allowed=difusoras_allowed, usuario_rol=usuario.rol)
        query = query.filter(ProgramacionModel.mc == True).filter(
            ProgramacionModel.categoria != 'Corte Comercial'
        ).filter(ProgramacionModel.categoria != 'ETM').filter(ProgramacionModel.interprete.isnot(None))
        
        eventos = query.all()
        
        # Agrupar por artista
        stats = {}
        canciones_por_artista = {}
        
        for evento in eventos:
            artista = evento.interprete
            if not artista:
                continue
            
            if artista not in stats:
                stats[artista] = {"cantidad": 0, "tiempo": 0}
                canciones_por_artista[artista] = set()
            
            stats[artista]["cantidad"] += 1
            tiempo_evento = parse_duration_to_seconds(evento.duracion_real or "00:00:00")
            stats[artista]["tiempo"] += tiempo_evento
            
            if evento.id_media:
                canciones_por_artista[artista].add(evento.id_media)
        
        # Convertir a lista
        resultado = []
        for artista, datos in sorted(stats.items(), key=lambda x: x[1]["cantidad"], reverse=True)[:limite]:
            resultado.append(EstadisticaArtista(
                artista=artista,
                cantidad_reproducciones=datos["cantidad"],
                cantidad_canciones_unicas=len(canciones_por_artista[artista]),
                tiempo_total_segundos=datos["tiempo"],
                tiempo_total_formato=format_seconds_to_time(datos["tiempo"])
            ))
        
        return resultado
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error al obtener estadísticas por artista: {str(e)}")


@router.get("/estadisticas/albums", response_model=List[EstadisticaAlbum])
async def get_estadisticas_albums(
    fecha_inicio: Optional[date] = Query(None),
    fecha_fin: Optional[date] = Query(None),
    difusora: Optional[str] = Query(None),
    politica_id: Optional[int] = Query(None),
    limite: int = Query(50, ge=1, le=200),
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: list = Depends(get_user_difusoras)
):
    """Obtiene estadísticas por álbum (solo de la organización del usuario)"""
    try:
        query = get_base_filters(db, fecha_inicio, fecha_fin, difusora, politica_id, difusoras_allowed=difusoras_allowed, usuario_rol=usuario.rol)
        query = query.filter(ProgramacionModel.mc == True).filter(
            ProgramacionModel.categoria != 'Corte Comercial'
        ).filter(ProgramacionModel.categoria != 'ETM').filter(ProgramacionModel.disco.isnot(None))
        
        eventos = query.all()
        
        # Agrupar por álbum
        stats = {}
        canciones_por_album = {}
        
        for evento in eventos:
            album = evento.disco
            artista = evento.interprete or "Sin artista"
            if not album:
                continue
            
            key = f"{album} - {artista}"
            if key not in stats:
                stats[key] = {"album": album, "artista": artista, "cantidad": 0, "tiempo": 0}
                canciones_por_album[key] = set()
            
            stats[key]["cantidad"] += 1
            tiempo_evento = parse_duration_to_seconds(evento.duracion_real or "00:00:00")
            stats[key]["tiempo"] += tiempo_evento
            
            if evento.id_media:
                canciones_por_album[key].add(evento.id_media)
        
        # Convertir a lista
        resultado = []
        for key, datos in sorted(stats.items(), key=lambda x: x[1]["cantidad"], reverse=True)[:limite]:
            resultado.append(EstadisticaAlbum(
                album=datos["album"],
                artista=datos["artista"],
                cantidad_reproducciones=datos["cantidad"],
                cantidad_canciones_unicas=len(canciones_por_album[key]),
                tiempo_total_segundos=datos["tiempo"],
                tiempo_total_formato=format_seconds_to_time(datos["tiempo"])
            ))
        
        return resultado
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error al obtener estadísticas por álbum: {str(e)}")


@router.get("/estadisticas/distribucion-horaria", response_model=List[DistribucionHoraria])
async def get_distribucion_horaria(
    fecha_inicio: Optional[date] = Query(None),
    fecha_fin: Optional[date] = Query(None),
    difusora: Optional[str] = Query(None),
    politica_id: Optional[int] = Query(None),
    db: Session = Depends(get_db)
):
    """Obtiene distribución de eventos por hora del día"""
    try:
        query = get_base_filters(db, fecha_inicio, fecha_fin, difusora, politica_id)
        eventos = query.all()
        
        # Agrupar por hora
        stats = {hora: {"eventos": 0, "canciones": 0, "tiempo": 0} for hora in range(24)}
        
        for evento in eventos:
            if evento.hora_real:
                hora = evento.hora_real.hour
                stats[hora]["eventos"] += 1
                
                if evento.mc and evento.categoria != 'Corte Comercial' and evento.categoria != 'ETM':
                    stats[hora]["canciones"] += 1
                
                tiempo_evento = parse_duration_to_seconds(evento.duracion_real or "00:00:00")
                stats[hora]["tiempo"] += tiempo_evento
        
        # Convertir a lista
        resultado = []
        for hora in range(24):
            resultado.append(DistribucionHoraria(
                hora=hora,
                cantidad_eventos=stats[hora]["eventos"],
                cantidad_canciones=stats[hora]["canciones"],
                tiempo_total_segundos=stats[hora]["tiempo"]
            ))
        
        return resultado
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error al obtener distribución horaria: {str(e)}")


@router.get("/estadisticas/distribucion-dia-semana", response_model=List[DistribucionDiaSemana])
async def get_distribucion_dia_semana(
    fecha_inicio: Optional[date] = Query(None),
    fecha_fin: Optional[date] = Query(None),
    difusora: Optional[str] = Query(None),
    politica_id: Optional[int] = Query(None),
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: list = Depends(get_user_difusoras)
):
    """Obtiene distribución de eventos por día de la semana (solo de la organización del usuario)"""
    try:
        query = get_base_filters(db, fecha_inicio, fecha_fin, difusora, politica_id, difusoras_allowed=difusoras_allowed, usuario_rol=usuario.rol)
        eventos = query.all()
        
        dias = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"]
        stats = {i: {"eventos": 0, "canciones": 0, "tiempo": 0} for i in range(7)}
        
        for evento in eventos:
            if evento.fecha:
                dia_semana = evento.fecha.weekday()  # 0=Lunes, 6=Domingo
                stats[dia_semana]["eventos"] += 1
                
                if evento.mc and evento.categoria != 'Corte Comercial' and evento.categoria != 'ETM':
                    stats[dia_semana]["canciones"] += 1
                
                tiempo_evento = parse_duration_to_seconds(evento.duracion_real or "00:00:00")
                stats[dia_semana]["tiempo"] += tiempo_evento
        
        # Convertir a lista
        resultado = []
        for i in range(7):
            resultado.append(DistribucionDiaSemana(
                dia_semana=dias[i],
                dia_numero=i,
                cantidad_eventos=stats[i]["eventos"],
                cantidad_canciones=stats[i]["canciones"],
                tiempo_total_segundos=stats[i]["tiempo"]
            ))
        
        return resultado
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error al obtener distribución por día de semana: {str(e)}")


@router.get("/estadisticas/difusoras", response_model=List[EstadisticaDifusora])
async def get_estadisticas_difusoras(
    fecha_inicio: Optional[date] = Query(None),
    fecha_fin: Optional[date] = Query(None),
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: list = Depends(get_user_difusoras)
):
    """Obtiene estadísticas por difusora (solo de la organización del usuario)"""
    try:
        query = get_base_filters(db, fecha_inicio, fecha_fin, difusoras_allowed=difusoras_allowed, usuario_rol=usuario.rol)
        eventos = query.all()
        
        # Agrupar por difusora
        stats = {}
        for evento in eventos:
            dif = evento.difusora
            if not dif:
                continue
            
            if dif not in stats:
                stats[dif] = {"eventos": 0, "canciones": 0, "tiempo": 0}
            
            stats[dif]["eventos"] += 1
            
            if evento.mc and evento.categoria != 'Corte Comercial' and evento.categoria != 'ETM':
                stats[dif]["canciones"] += 1
            
            tiempo_evento = parse_duration_to_seconds(evento.duracion_real or "00:00:00")
            stats[dif]["tiempo"] += tiempo_evento
        
        # Convertir a lista
        resultado = []
        for dif, datos in sorted(stats.items()):
            resultado.append(EstadisticaDifusora(
                difusora=dif,
                cantidad_eventos=datos["eventos"],
                cantidad_canciones=datos["canciones"],
                tiempo_total_segundos=datos["tiempo"],
                tiempo_total_formato=format_seconds_to_time(datos["tiempo"])
            ))
        
        return resultado
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error al obtener estadísticas por difusora: {str(e)}")


@router.get("/estadisticas/politicas", response_model=List[EstadisticaPolitica])
async def get_estadisticas_politicas(
    fecha_inicio: Optional[date] = Query(None),
    fecha_fin: Optional[date] = Query(None),
    difusora: Optional[str] = Query(None),
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: list = Depends(get_user_difusoras)
):
    """Obtiene estadísticas por política (solo de la organización del usuario)"""
    try:
        query = get_base_filters(db, fecha_inicio, fecha_fin, difusora, None, difusoras_allowed=difusoras_allowed, usuario_rol=usuario.rol)
        query = query.filter(ProgramacionModel.politica_id.isnot(None))
        eventos = query.all()
        
        # Agrupar por política
        stats = {}
        politicas_nombres = {}
        
        for evento in eventos:
            politica_id = evento.politica_id
            if not politica_id:
                continue
            
            if politica_id not in stats:
                stats[politica_id] = {"eventos": 0, "canciones": 0, "tiempo": 0}
                # Obtener nombre de la política
                politica = db.query(PoliticaProgramacion).filter(PoliticaProgramacion.id == politica_id).first()
                politicas_nombres[politica_id] = politica.nombre if politica else f"Política {politica_id}"
            
            stats[politica_id]["eventos"] += 1
            
            if evento.mc and evento.categoria != 'Corte Comercial' and evento.categoria != 'ETM':
                stats[politica_id]["canciones"] += 1
            
            tiempo_evento = parse_duration_to_seconds(evento.duracion_real or "00:00:00")
            stats[politica_id]["tiempo"] += tiempo_evento
        
        # Convertir a lista
        resultado = []
        for politica_id, datos in sorted(stats.items(), key=lambda x: x[1]["eventos"], reverse=True):
            resultado.append(EstadisticaPolitica(
                politica_id=politica_id,
                politica_nombre=politicas_nombres[politica_id],
                cantidad_eventos=datos["eventos"],
                cantidad_canciones=datos["canciones"],
                tiempo_total_segundos=datos["tiempo"],
                tiempo_total_formato=format_seconds_to_time(datos["tiempo"])
            ))
        
        return resultado
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error al obtener estadísticas por política: {str(e)}")

