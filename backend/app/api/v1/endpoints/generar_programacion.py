from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import or_, func, and_
from app.core.database import get_db
from app.models.programacion import (
    PoliticaProgramacion as PoliticaProgramacionModel,
    Reloj as RelojModel,
    EventoReloj as EventoRelojModel,
    DiaModelo as DiaModeloModel,
    RelojDiaModelo as RelojDiaModeloModel,
    SetRegla as SetReglaModel,
    Regla as ReglaModel,
    Programacion as ProgramacionModel
)
from app.models.categorias import Cancion as CancionModel
from pydantic import BaseModel
from typing import List, Optional, Dict, Any
from datetime import datetime, timedelta, time
import logging
import random

logger = logging.getLogger(__name__)
router = APIRouter()

# ============================================================================
# ENDPOINT DE PRUEBA
# ============================================================================

@router.get("/test")
async def test_endpoint():
    """Endpoint de prueba para verificar que el router funciona"""
    return {"message": "Generar programación endpoint funcionando", "status": "ok"}

@router.get("/dias-simple")
async def obtener_dias_simple(
    fecha_inicio: str = Query("30/01/2026", description="Fecha de inicio en formato DD/MM/YYYY"),
    fecha_fin: str = Query("31/01/2026", description="Fecha de fin en formato DD/MM/YYYY"),
    difusora: str = Query("test2", description="Difusora"),
    politica_id: Optional[int] = Query(None, description="ID de la política"),
    db: Session = Depends(get_db)
):
    """Endpoint para obtener días de programación basado en relojes y eventos"""
    try:
        # Convertir fechas de DD/MM/YYYY a datetime
        fecha_inicio_dt = datetime.strptime(fecha_inicio, "%d/%m/%Y")
        fecha_fin_dt = datetime.strptime(fecha_fin, "%d/%m/%Y")
        
        # Generar días entre las fechas
        dias = []
        current_date = fecha_inicio_dt
        nombres_dias = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo']
        
        while current_date <= fecha_fin_dt:
            dia_semana = nombres_dias[current_date.weekday()]
            fecha_str = current_date.strftime("%d/%m/%Y")
            
            # Generar programación para este día basada en relojes
            programacion_dia = await generar_programacion_dia(
                current_date, difusora, politica_id, db
            )
            
            dias.append({
                "fecha": fecha_str,
                "dia_semana": dia_semana,
                "dia_modelo": programacion_dia.get("dia_modelo"),
                "status": programacion_dia.get("status", "Sin Programación"),
                "num_eventos": programacion_dia.get("num_eventos", 0),
                "num_canciones": programacion_dia.get("num_canciones", 0),
                "num_asignadas": programacion_dia.get("num_asignadas", 0),
                "porcentaje": programacion_dia.get("porcentaje", 0.0),
                "minutos_comerciales": programacion_dia.get("minutos_comerciales", 0.0),
                "tiene_programacion": programacion_dia.get("tiene_programacion", False)
            })
            
            current_date += timedelta(days=1)
        
        return {
            "dias": dias,
            "total": len(dias),
            "difusora": difusora,
            "fecha_inicio": fecha_inicio,
            "fecha_fin": fecha_fin,
            "politica_id": politica_id
        }
        
    except ValueError as e:
        raise HTTPException(status_code=400, detail=f"Formato de fecha inválido: {str(e)}")
    except Exception as e:
        logger.error(f"Error al obtener días de programación: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

# ============================================================================
# FUNCIONES DE GENERACIÓN DE PROGRAMACIÓN
# ============================================================================

async def generar_programacion_dia(fecha: datetime, difusora: str, politica_id: Optional[int], db: Session):
    """Generar programación para un día específico basada en relojes y eventos"""
    try:
        # Obtener día de la semana (0=lunes, 6=domingo)
        dia_semana_num = fecha.weekday()
        nombres_dias = ['lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado', 'domingo']
        dia_semana_nombre = nombres_dias[dia_semana_num]
        
        # Buscar días modelo para esta difusora y política
        query = db.query(DiaModeloModel).filter(
            DiaModeloModel.difusora == difusora,
            DiaModeloModel.habilitado == True
        )
        
        if politica_id:
            query = query.filter(DiaModeloModel.politica_id == politica_id)
        
        # Filtrar por día de la semana
        dia_semana_field = getattr(DiaModeloModel, dia_semana_nombre)
        query = query.filter(dia_semana_field == True)
        
        dias_modelo = query.all()
        
        if not dias_modelo:
            return {
                "dia_modelo": None,
                "status": "Sin Configuración",
                "num_eventos": 0,
                "num_canciones": 0,
                "num_asignadas": 0,
                "porcentaje": 0.0,
                "minutos_comerciales": 0.0,
                "tiene_programacion": False,
                "puede_generar": True
            }
        
        # Usar el primer día modelo encontrado
        dia_modelo = dias_modelo[0]
        
        # Obtener relojes para este día modelo
        relojes_dia = db.query(RelojDiaModeloModel).filter(
            RelojDiaModeloModel.dia_modelo_id == dia_modelo.id
        ).order_by(RelojDiaModeloModel.orden).all()
        
        if not relojes_dia:
            return {
                "dia_modelo": dia_modelo.nombre,
                "status": "Sin Relojes",
                "num_eventos": 0,
                "num_canciones": 0,
                "num_asignadas": 0,
                "porcentaje": 0.0,
                "minutos_comerciales": 0.0,
                "tiene_programacion": False
            }
        
        # Generar programación completa del día
        programacion_completa = await generar_programacion_completa_dia(
            fecha, relojes_dia, db
        )
        
        return {
            "dia_modelo": dia_modelo.nombre,
            "status": "Con Programación",
            "num_eventos": programacion_completa["total_eventos"],
            "num_canciones": programacion_completa["total_canciones"],
            "num_asignadas": programacion_completa["total_asignadas"],
            "porcentaje": programacion_completa["porcentaje_completado"],
            "minutos_comerciales": programacion_completa["minutos_comerciales"],
            "tiene_programacion": True,
            "programacion_detalle": programacion_completa["eventos"]
        }
        
    except Exception as e:
        logger.error(f"Error al generar programación para {fecha}: {str(e)}")
        return {
            "dia_modelo": None,
            "status": "Sin Configuración",
            "num_eventos": 0,
            "num_canciones": 0,
            "num_asignadas": 0,
            "porcentaje": 0.0,
            "minutos_comerciales": 0.0,
            "tiene_programacion": False,
            "puede_generar": True
        }

async def generar_programacion_completa_dia(fecha: datetime, relojes_dia: list, db: Session):
    """Generar programación completa del día con ajustes de tiempo automáticos"""
    try:
        eventos_programacion = []
        tiempo_actual = 0  # En minutos desde medianoche
        total_eventos = 0
        total_canciones = 0
        total_asignadas = 0
        minutos_comerciales = 0
        
        # Procesar cada reloj del día
        for reloj_dia in relojes_dia:
            reloj = db.query(RelojModel).filter(RelojModel.id == reloj_dia.reloj_id).first()
            if not reloj or not reloj.habilitado:
                continue
            
            # Obtener eventos del reloj
            eventos_reloj = db.query(EventoRelojModel).filter(
                EventoRelojModel.reloj_id == reloj.id
            ).order_by(EventoRelojModel.orden).all()
            
            if not eventos_reloj:
                continue
            
            # Calcular hora de inicio del reloj (extraer de la clave, ej: "LUNES_06_00" -> 6:00)
            hora_inicio = extraer_hora_desde_clave(reloj.clave)
            tiempo_inicio_reloj = hora_inicio * 60  # Convertir a minutos
            
            # Si hay tiempo restante del reloj anterior, ajustar
            if tiempo_actual > tiempo_inicio_reloj:
                # Cortar eventos anteriores y empezar el nuevo reloj
                tiempo_actual = tiempo_inicio_reloj
            
            # Procesar eventos del reloj
            tiempo_reloj = 0
            duracion_reloj = convertir_duracion_a_minutos(reloj.duracion)
            
            for evento in eventos_reloj:
                # Verificar si hay tiempo suficiente para este evento
                duracion_evento = convertir_duracion_a_minutos(evento.duracion)
                
                # Si el evento excede el tiempo del reloj, cortarlo
                if tiempo_reloj + duracion_evento > duracion_reloj:
                    duracion_evento = duracion_reloj - tiempo_reloj
                    if duracion_evento <= 0:
                        break
                
                # Crear evento de programación
                evento_programacion = {
                "hora_inicio": f"{int(tiempo_actual // 60):02d}:{int(tiempo_actual % 60):02d}:00",
                "tipo": evento.tipo,
                "categoria": evento.categoria,
                "duracion": f"{int(duracion_evento // 60):02d}:{int(duracion_evento % 60):02d}:00",
                "descripcion": evento.descripcion or f"Evento {evento.numero}",
                "reloj": reloj.nombre
                }
                
                eventos_programacion.append(evento_programacion)
                
                # Actualizar contadores
                tiempo_actual += duracion_evento
                tiempo_reloj += duracion_evento
                total_eventos += 1
                
                if evento.tipo == "1":  # Canciones
                    total_canciones += 1
                    total_asignadas += 1
                elif evento.tipo == "6":  # ETM/Comerciales
                    minutos_comerciales += duracion_evento
        
        # Calcular porcentaje de completado (asumiendo 24 horas = 1440 minutos)
        porcentaje = min(100.0, (tiempo_actual / 1440) * 100)
        
        return {
            "eventos": eventos_programacion,
            "total_eventos": total_eventos,
            "total_canciones": total_canciones,
            "total_asignadas": total_asignadas,
            "porcentaje_completado": round(porcentaje, 1),
            "minutos_comerciales": round(minutos_comerciales, 1),
            "tiempo_total_programado": tiempo_actual
        }
        
    except Exception as e:
        logger.error(f"Error al generar programación completa: {str(e)}")
        return {
            "eventos": [],
            "total_eventos": 0,
            "total_canciones": 0,
            "total_asignadas": 0,
            "porcentaje_completado": 0.0,
            "minutos_comerciales": 0.0,
            "tiempo_total_programado": 0
        }

def extraer_hora_desde_clave(clave: str) -> int:
    """Extraer hora de inicio desde la clave del reloj (ej: 'LUNES_06_00' -> 6)"""
    try:
        # Buscar patrón de hora en la clave
        import re
        match = re.search(r'_(\d{2})_(\d{2})', clave)
        if match:
            hora = int(match.group(1))
            return hora
        return 0
    except:
        return 0

def convertir_duracion_a_minutos(duracion_str: str) -> float:
    """Convertir duración de formato HH:MM:SS a minutos"""
    try:
        if not duracion_str:
            return 0.0
        
        # Formato: HH:MM:SS o MM:SS
        partes = duracion_str.split(':')
        if len(partes) == 3:  # HH:MM:SS
            horas = int(partes[0])
            minutos = int(partes[1])
            segundos = int(partes[2])
            return horas * 60 + minutos + segundos / 60
        elif len(partes) == 2:  # MM:SS
            minutos = int(partes[0])
            segundos = int(partes[1])
            return minutos + segundos / 60
        else:
            return float(duracion_str)
    except:
        return 0.0

async def generar_programacion_dia_completo(
    fecha: datetime, difusora: str, politica_id: int, dia_modelo, relojes, 
    canciones_por_categoria: Dict, db: Session
):
    """Generar programación completa para un día específico"""
    try:
        programacion_generada = []
        
        # Ordenar relojes por hora
        relojes_ordenados = sorted(relojes, key=lambda r: r.clave)
        
        for reloj in relojes_ordenados:
            # Obtener eventos del reloj
            eventos_reloj = db.query(EventoRelojModel).filter(
                EventoRelojModel.reloj_id == reloj.id
            ).all()
            
            if not eventos_reloj:
                continue
            
            # Calcular hora de inicio del reloj
            hora_reloj = datetime.combine(fecha.date(), time(6, 0))  # Asumiendo que empieza a las 6 AM
            
            for evento in eventos_reloj:
                # Para la estructura actual, generar eventos básicos
                # Seleccionar categoría aleatoria de las disponibles
                categorias_disponibles = list(canciones_por_categoria.keys())
                if not categorias_disponibles:
                    continue
                
                categoria_id_seleccionada = random.choice(categorias_disponibles)
                canciones_categoria = canciones_por_categoria[categoria_id_seleccionada]
                
                if not canciones_categoria:
                    continue
                
                # Seleccionar canción aleatoria
                cancion_seleccionada = random.choice(canciones_categoria)
                
                # Obtener nombre de la categoría
                from app.models.categorias import Categoria as CategoriaModel
                categoria = db.query(CategoriaModel).filter(CategoriaModel.id == categoria_id_seleccionada).first()
                nombre_categoria = categoria.nombre if categoria else f"Categoria_{categoria_id_seleccionada}"
                
                # Usar la duración real de la canción
                duracion_segundos = cancion_seleccionada.duracion if cancion_seleccionada.duracion else 180
                horas = duracion_segundos // 3600
                minutos = (duracion_segundos % 3600) // 60
                segundos = duracion_segundos % 60
                duracion_real = f"{horas:02d}:{minutos:02d}:{segundos:02d}"
                
                # Crear entrada de programación
                programacion_entry = ProgramacionModel(
                mc=True,  # Se pudo agregar la canción
                numero_reloj=reloj.clave,
                hora_real=hora_reloj.time(),
                hora_transmision=hora_reloj.time(),
                    duracion_real=duracion_real,
                    tipo="cancion",
                    hora_planeada=hora_reloj.time(),
                    duracion_planeada=duracion_real,
                    categoria=nombre_categoria,
                    id_media=str(cancion_seleccionada.id),
                    descripcion=cancion_seleccionada.titulo,
                    lenguaje="Español",
                    interprete=cancion_seleccionada.artista,
                    disco=cancion_seleccionada.album,
                    sello_discografico="",
                    bpm=0,
                    año=0,
                    difusora=difusora,
                    politica_id=politica_id,
                    fecha=fecha.date(),
                    reloj_id=reloj.id,
                    evento_reloj_id=evento.id
                )
                
                db.add(programacion_entry)
                programacion_generada.append(programacion_entry)
                
                # Avanzar tiempo según la duración real de la canción
                # duracion_segundos ya está calculado arriba
                hora_reloj += timedelta(seconds=duracion_segundos)
        
        # Guardar en la base de datos
        db.commit()
        return programacion_generada
        
    except Exception as e:
        db.rollback()
        logger.error(f"Error al generar programación para {fecha}: {str(e)}")
        return None

@router.post("/generar-programacion")
async def generar_programacion_completa(
    difusora: str = Query(..., description="Difusora"),
    politica_id: int = Query(..., description="ID de la política"),
    fecha_inicio: str = Query(..., description="Fecha de inicio (DD/MM/YYYY)"),
    fecha_fin: str = Query(..., description="Fecha de fin (DD/MM/YYYY)"),
    db: Session = Depends(get_db)
):
    """Generar programación completa para un período"""
    try:
        # Convertir fechas
        fecha_inicio_dt = datetime.strptime(fecha_inicio, "%d/%m/%Y")
        fecha_fin_dt = datetime.strptime(fecha_fin, "%d/%m/%Y")
        
        # Obtener política y sus categorías seleccionadas
        politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == politica_id).first()
        if not politica:
            raise HTTPException(status_code=404, detail="Política no encontrada")
        
        # Obtener categorías seleccionadas para esta política
        categorias_politica = getattr(politica, 'categorias_seleccionadas', [])
        if not categorias_politica:
            # Si no hay categorías seleccionadas, usar todas las categorías disponibles
            from app.models.categorias import Categoria as CategoriaModel
            categorias_politica = db.query(CategoriaModel.id).all()
            categorias_politica = [cat[0] for cat in categorias_politica if cat[0]]
        
        # Obtener canciones por categoría
        canciones_por_categoria = {}
        for categoria_id in categorias_politica:
            canciones = db.query(CancionModel).filter(
                CancionModel.categoria_id == categoria_id,
                CancionModel.activa == True
            ).all()
            canciones_por_categoria[categoria_id] = canciones
        
        # Generar programación para cada día
        current_date = fecha_inicio_dt
        total_generados = 0
        dias_procesados = []
        
        while current_date <= fecha_fin_dt:
            # Obtener día modelo para este día
            dia_semana_ingles = current_date.strftime("%A").lower()
            # Mapear días de la semana en inglés a español
            mapeo_dias = {
                'monday': 'lunes',
                'tuesday': 'martes', 
                'wednesday': 'miercoles',
                'thursday': 'jueves',
                'friday': 'viernes',
                'saturday': 'sabado',
                'sunday': 'domingo'
            }
            dia_semana_espanol = mapeo_dias.get(dia_semana_ingles, 'lunes')
            
            dia_modelo = db.query(DiaModeloModel).filter(
                DiaModeloModel.politica_id == politica_id,
                DiaModeloModel.habilitado == True,
                getattr(DiaModeloModel, dia_semana_espanol) == True
            ).first()
            
            if not dia_modelo:
                dias_procesados.append({
                "fecha": current_date.strftime("%d/%m/%Y"),
                "dia_semana": current_date.strftime("%A"),
                "status": "Sin Configuración",
                "generado": False
                })
                current_date += timedelta(days=1)
                continue
            
            # Obtener relojes del día modelo
            relojes = db.query(RelojModel).filter(
                RelojModel.politica_id == politica_id,
                RelojModel.habilitado == True
            ).all()
            
            if not relojes:
                dias_procesados.append({
                "fecha": current_date.strftime("%d/%m/%Y"),
                "dia_semana": current_date.strftime("%A"),
                "status": "Sin Relojes",
                "generado": False
                })
                current_date += timedelta(days=1)
                continue
            
            # Generar programación para este día
            programacion_generada = await generar_programacion_dia_completo(
                current_date, difusora, politica_id, dia_modelo, relojes, 
                canciones_por_categoria, db
            )
            
            if programacion_generada:
                total_generados += 1
                dias_procesados.append({
                "fecha": current_date.strftime("%d/%m/%Y"),
                "dia_semana": current_date.strftime("%A"),
                "status": "Generada",
                "generado": True,
                "eventos_generados": len(programacion_generada)
                })
            else:
                dias_procesados.append({
                "fecha": current_date.strftime("%d/%m/%Y"),
                "dia_semana": current_date.strftime("%A"),
                "status": "Error",
                "generado": False
                })
            
            current_date += timedelta(days=1)
        
        return {
            "message": "Programación generada correctamente",
            "dias_generados": total_generados,
            "dias_procesados": dias_procesados,
            "difusora": difusora,
            "politica_id": politica_id,
            "fecha_inicio": fecha_inicio,
            "fecha_fin": fecha_fin,
            "categorias_utilizadas": list(canciones_por_categoria.keys())
        }
        
    except ValueError as e:
        raise HTTPException(status_code=400, detail=f"Formato de fecha inválido: {str(e)}")
    except Exception as e:
        db.rollback()
        logger.error(f"Error al generar programación: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.post("/generar-programacion-simple")
async def generar_programacion_simple(
    difusora: str = Query(..., description="Difusora"),
    politica_id: int = Query(..., description="ID de la política"),
    fecha: str = Query(..., description="Fecha (DD/MM/YYYY)"),
    db: Session = Depends(get_db)
):
    """Generar programación simple para un día específico"""
    try:
        # Convertir fecha
        fecha_dt = datetime.strptime(fecha, "%d/%m/%Y")
        
        # Crear una entrada de programación de prueba
        programacion_entry = ProgramacionModel(
            mc=True,
            numero_reloj="TEST_01",
            hora_real=time(6, 0),
            hora_transmision=time(6, 0),
            duracion_real="03:30:00",
            tipo="cancion",
            hora_planeada=time(6, 0),
            duracion_planeada="03:30:00",
            categoria="Pop",
            id_media="123",
            descripcion="Canción de Prueba",
            lenguaje="Español",
            interprete="Artista de Prueba",
            disco="Álbum de Prueba",
            sello_discografico="Sello de Prueba",
            bpm=120,
            año=2024,
            difusora=difusora,
            politica_id=politica_id,
            fecha=fecha_dt.date(),
            reloj_id=None,
            evento_reloj_id=None
        )
        
        db.add(programacion_entry)
        db.commit()
        
        return {
            "message": "Programación de prueba generada correctamente",
            "difusora": difusora,
            "politica_id": politica_id,
            "fecha": fecha,
            "programacion_id": programacion_entry.id
        }
        
    except ValueError as e:
        raise HTTPException(status_code=400, detail=f"Formato de fecha inválido: {str(e)}")
    except Exception as e:
        db.rollback()
        logger.error(f"Error al generar programación simple: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.get("/programacion-estadisticas")
async def get_programacion_estadisticas(
    difusora: str = Query(..., description="Difusora"),
    politica_id: int = Query(..., description="ID de la política"),
    fecha_inicio: str = Query(..., description="Fecha de inicio (DD/MM/YYYY)"),
    fecha_fin: str = Query(..., description="Fecha de fin (DD/MM/YYYY)"),
    db: Session = Depends(get_db)
):
    """Obtener estadísticas de programación para un período"""
    try:
        # Convertir fechas
        fecha_inicio_dt = datetime.strptime(fecha_inicio, "%d/%m/%Y")
        fecha_fin_dt = datetime.strptime(fecha_fin, "%d/%m/%Y")
        
        # Obtener programación generada para el período
        programacion = db.query(ProgramacionModel).filter(
            ProgramacionModel.difusora == difusora,
            ProgramacionModel.politica_id == politica_id,
            ProgramacionModel.fecha >= fecha_inicio_dt.date(),
            ProgramacionModel.fecha <= fecha_fin_dt.date()
        ).all()
        
        # Calcular estadísticas por día
        dias_estadisticas = {}
        for p in programacion:
            fecha_str = p.fecha.strftime("%d/%m/%Y")
            if fecha_str not in dias_estadisticas:
                dias_estadisticas[fecha_str] = {
                "fecha": fecha_str,
                "dia_semana": p.fecha.strftime("%A"),
                "num_eventos": 0,
                "num_canciones": 0,
                "num_asignadas": 0,
                "minutos_comerciales": 0.0,
                "tiene_programacion": True
                }
            
            dias_estadisticas[fecha_str]["num_eventos"] += 1
            if p.tipo == "cancion":
                dias_estadisticas[fecha_str]["num_canciones"] += 1
            if p.mc:
                dias_estadisticas[fecha_str]["num_asignadas"] += 1
            if p.tipo == "corte_comercial":
                # Convertir duración a minutos comerciales
                duracion_minutos = convertir_duracion_a_minutos(p.duracion_real)
                dias_estadisticas[fecha_str]["minutos_comerciales"] += duracion_minutos
        
        # Calcular porcentajes
        for fecha_str, stats in dias_estadisticas.items():
            if stats["num_eventos"] > 0:
                stats["porcentaje"] = (stats["num_asignadas"] / stats["num_eventos"]) * 100
            else:
                stats["porcentaje"] = 0.0
        
        return {
            "dias_estadisticas": list(dias_estadisticas.values()),
            "total_dias": len(dias_estadisticas),
            "dias_con_programacion": len([d for d in dias_estadisticas.values() if d["tiene_programacion"]]),
            "difusora": difusora,
            "politica_id": politica_id,
            "fecha_inicio": fecha_inicio,
            "fecha_fin": fecha_fin
        }
        
    except ValueError as e:
        raise HTTPException(status_code=400, detail=f"Formato de fecha inválido: {str(e)}")
    except Exception as e:
        logger.error(f"Error al obtener estadísticas de programación: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.get("/programacion-detallada")
async def get_programacion_detallada(
    difusora: str = Query(..., description="Difusora"),
    politica_id: int = Query(..., description="ID de la política"),
    fecha: str = Query(..., description="Fecha (DD/MM/YYYY)"),
    db: Session = Depends(get_db)
):
    """Obtener programación detallada para un día específico"""
    try:
        # Convertir fecha
        fecha_dt = datetime.strptime(fecha, "%d/%m/%Y")
        
        # Obtener programación del día
        programacion = db.query(ProgramacionModel).filter(
            ProgramacionModel.difusora == difusora,
            ProgramacionModel.politica_id == politica_id,
            ProgramacionModel.fecha == fecha_dt.date()
        ).order_by(ProgramacionModel.hora_real).all()
        
        # Convertir a formato detallado
        eventos_detallados = []
        for i, evento in enumerate(programacion):
            eventos_detallados.append({
                "id": evento.id,
                "mc": evento.mc,
                "numero_reloj": evento.numero_reloj,
                "numero_evento": i + 1,
                "hora_real": evento.hora_real.strftime("%H:%M:%S") if evento.hora_real else "00:00:00",
                "hora_transmision": evento.hora_transmision.strftime("%H:%M:%S") if evento.hora_transmision else "N/D",
                "duracion_real": evento.duracion_real or "00:00:00",
                "tipo": evento.tipo,
                "hora_planeada": evento.hora_planeada.strftime("%H:%M:%S") if evento.hora_planeada else "00:00:00",
                "duracion_planeada": evento.duracion_planeada or "00:00:00",
                "categoria": evento.categoria or "",
                "id_media": evento.id_media or "",
                "descripcion": evento.descripcion or "",
                "lenguaje": evento.lenguaje or "",
                "interprete": evento.interprete or "",
                "disco": evento.disco or "",
                "sello_discografico": evento.sello_discografico or "",
                "bpm": evento.bpm or 0,
                "año": evento.año or 0
            })
        
        # Calcular estadísticas del día
        total_eventos = len(programacion)
        total_canciones = len([e for e in programacion if e.tipo == "cancion"])
        total_cortes_comerciales = len([e for e in programacion if e.tipo == "corte_comercial"])
        
        # Calcular duración total
        duracion_total_segundos = 0
        for evento in programacion:
            if evento.duracion_real:
                try:
                    partes = evento.duracion_real.split(':')
                    if len(partes) == 3:
                        horas, minutos, segundos = map(int, partes)
                        duracion_total_segundos += horas * 3600 + minutos * 60 + segundos
                except:
                    pass
        
        horas = duracion_total_segundos // 3600
        minutos = (duracion_total_segundos % 3600) // 60
        segundos = duracion_total_segundos % 60
        
        return {
            "difusora": difusora,
            "politica_id": politica_id,
            "fecha": fecha,
            "dia_semana": fecha_dt.strftime("%A"),
            "eventos": eventos_detallados,
            "estadisticas": {
                "total_eventos": total_eventos,
                "total_canciones": total_canciones,
                "total_cortes_comerciales": total_cortes_comerciales,
                "duracion_total": f"{horas:02d}:{minutos:02d}:{segundos:02d}",
                "duracion_total_segundos": duracion_total_segundos
            }
        }
        
    except ValueError as e:
        raise HTTPException(status_code=400, detail=f"Formato de fecha inválido: {str(e)}")
    except Exception as e:
        logger.error(f"Error al obtener programación detallada: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

# ============================================================================
# SCHEMAS PARA GENERAR PROGRAMACIÓN
# ============================================================================

class GenerarProgramacionRequest(BaseModel):
    difusora: str
    politica_id: int
    set_regla_id: Optional[int] = None
    fecha_inicio: str  # Formato: DD/MM/YYYY
    fecha_fin: str     # Formato: DD/MM/YYYY
    incluir_fines_semana: bool = True
    parametros_adicionales: Optional[Dict[str, Any]] = None

class DiaProgramacion(BaseModel):
    fecha: str
    dia_semana: str
    dia_modelo: Optional[str] = None
    status: str  # "Sin Programación", "Con Programación", "Error"
    num_eventos: int = 0
    num_canciones: int = 0
    num_asignadas: int = 0
    porcentaje: float = 0.0
    minutos_comerciales: float = 0.0
    tiene_programacion: bool = False

class GenerarProgramacionResponse(BaseModel):
    dias_programacion: List[DiaProgramacion]
    resumen: Dict[str, Any]
    mensaje: str

# ============================================================================
# ENDPOINTS PARA GENERAR PROGRAMACIÓN
# ============================================================================

@router.post("/generar", response_model=GenerarProgramacionResponse)
async def generar_programacion(
    request: GenerarProgramacionRequest,
    db: Session = Depends(get_db)
):
    """Generar programación basada en política, relojes y días modelo"""
    try:
        # Validar que la política existe
        politica = db.query(PoliticaProgramacionModel).filter(
            PoliticaProgramacionModel.id == request.politica_id
        ).first()
        if not politica:
            raise HTTPException(status_code=404, detail="Política no encontrada")
        
        # Validar que la política pertenece a la difusora
        if politica.difusora != request.difusora:
            raise HTTPException(
                status_code=400, 
                detail=f"La política no pertenece a la difusora {request.difusora}"
            )
        
        # Obtener días modelo de la política
        dias_modelo = db.query(DiaModeloModel).filter(
            DiaModeloModel.politica_id == request.politica_id
        ).all()
        
        if not dias_modelo:
            raise HTTPException(
                status_code=400,
                detail="La política no tiene días modelo configurados"
            )
        
        # Obtener relojes de la política
        relojes = db.query(RelojModel).filter(
            RelojModel.politica_id == request.politica_id
        ).all()
        
        # Generar lista de fechas
        fecha_inicio = datetime.strptime(request.fecha_inicio, "%d/%m/%Y")
        fecha_fin = datetime.strptime(request.fecha_fin, "%d/%m/%Y")
        
        dias_programacion = []
        total_dias = 0
        dias_con_programacion = 0
        dias_sin_programacion = 0
        total_eventos = 0
        total_canciones = 0
        total_asignadas = 0
        total_mc = 0.0
        
        # Iterar por cada día en el rango
        current_date = fecha_inicio
        while current_date <= fecha_fin:
            # Verificar si incluir fines de semana
            if not request.incluir_fines_semana and current_date.weekday() >= 5:
                current_date += timedelta(days=1)
                continue
            
            # Obtener el día de la semana (0=lunes, 6=domingo)
            dia_semana_num = current_date.weekday()
            nombres_dias = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo']
            dia_semana = nombres_dias[dia_semana_num]
            
            # Buscar día modelo correspondiente
            dia_modelo = None
            for dm in dias_modelo:
                if dm.dia_semana.lower() == dia_semana.lower():
                    dia_modelo = dm
                    break
            
            # Calcular estadísticas del día
            num_eventos = 0
            num_canciones = 0
            num_asignadas = 0
            minutos_comerciales = 0.0
            tiene_programacion = False
            
            if dia_modelo:
                # Obtener relojes del día modelo
                relojes_dia = db.query(RelojDiaModeloModel).filter(
                RelojDiaModeloModel.dia_modelo_id == dia_modelo.id
                ).all()
                
                for reloj_dia in relojes_dia:
                    # Obtener eventos del reloj
                    eventos = db.query(EventoRelojModel).filter(
                        EventoRelojModel.reloj_id == reloj_dia.reloj_id
                    ).all()
                    
                    num_eventos += len(eventos)
                
                # Simular conteo de canciones y comerciales
                for evento in eventos:
                    if evento.tipo == 'cancion':
                        num_canciones += 1
                    elif evento.tipo == 'comercial':
                        minutos_comerciales += evento.duracion / 60.0  # Convertir segundos a minutos
                
                num_asignadas = num_canciones  # Simplificado
                tiene_programacion = num_eventos > 0
            
            # Calcular porcentaje
            porcentaje = (num_asignadas / num_canciones * 100) if num_canciones > 0 else 0.0
            
            # Determinar status
            if tiene_programacion:
                status = "Con Programación"
                dias_con_programacion += 1
            else:
                status = "Sin Programación"
                dias_sin_programacion += 1
            
            # Crear objeto del día
            dia_prog = DiaProgramacion(
                fecha=current_date.strftime("%d/%m/%Y"),
                dia_semana=dia_semana,
                dia_modelo=dia_modelo.nombre if dia_modelo else None,
                status=status,
                num_eventos=num_eventos,
                num_canciones=num_canciones,
                num_asignadas=num_asignadas,
                porcentaje=round(porcentaje, 1),
                minutos_comerciales=round(minutos_comerciales, 1),
                tiene_programacion=tiene_programacion
            )
            
            dias_programacion.append(dia_prog)
            
            # Acumular totales
            total_dias += 1
            total_eventos += num_eventos
            total_canciones += num_canciones
            total_asignadas += num_asignadas
            total_mc += minutos_comerciales
            
            current_date += timedelta(days=1)
        
        # Crear resumen
        resumen = {
            "total_dias": total_dias,
            "dias_con_programacion": dias_con_programacion,
            "dias_sin_programacion": dias_sin_programacion,
            "porcentaje_completado": round((dias_con_programacion / total_dias * 100), 1) if total_dias > 0 else 0,
            "total_eventos": total_eventos,
            "total_canciones": total_canciones,
            "total_asignadas": total_asignadas,
            "total_minutos_comerciales": round(total_mc, 1),
            "politica": {
                "id": politica.id,
                "nombre": politica.nombre,
                "clave": politica.clave
            },
            "difusora": request.difusora,
            "fecha_inicio": request.fecha_inicio,
            "fecha_fin": request.fecha_fin
        }
        
        mensaje = f"Programación generada para {total_dias} días. {dias_con_programacion} con programación, {dias_sin_programacion} sin programación."
        
        return GenerarProgramacionResponse(
            dias_programacion=dias_programacion,
            resumen=resumen,
            mensaje=mensaje
        )
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error al generar programación: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.get("/dias/{difusora}/{fecha_inicio}/{fecha_fin}")
async def obtener_dias_programacion(
    difusora: str,
    fecha_inicio: str,
    fecha_fin: str,
    politica_id: Optional[int] = Query(None),
    incluir_fines_semana: bool = Query(True),
    db: Session = Depends(get_db)
):
    """Obtener días de programación para un rango de fechas"""
    try:
        # Convertir fechas
        fecha_inicio_dt = datetime.strptime(fecha_inicio, "%d/%m/%Y")
        fecha_fin_dt = datetime.strptime(fecha_fin, "%d/%m/%Y")
        
        # Si se especifica política, validar que existe
        if politica_id:
            politica = db.query(PoliticaProgramacionModel).filter(
                and_(
                PoliticaProgramacionModel.id == politica_id,
                PoliticaProgramacionModel.difusora == difusora
                )
            ).first()
            if not politica:
                raise HTTPException(status_code=404, detail="Política no encontrada para esta difusora")
        
        # Generar días (simplificado para consulta)
        dias = []
        current_date = fecha_inicio_dt
        
        while current_date <= fecha_fin_dt:
            if not incluir_fines_semana and current_date.weekday() >= 5:
                current_date += timedelta(days=1)
                continue
            
            nombres_dias = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo']
            dia_semana = nombres_dias[current_date.weekday()]
            
            # Por ahora, simular datos (en implementación real, consultarías la base de datos)
            dias.append({
                "fecha": current_date.strftime("%d/%m/%Y"),
                "dia_semana": dia_semana,
                "dia_modelo": None,
                "status": "Sin Programación",
                "num_eventos": 0,
                "num_canciones": 0,
                "num_asignadas": 0,
                "porcentaje": 0.0,
                "minutos_comerciales": 0.0,
                "tiene_programacion": False
            })
            
            current_date += timedelta(days=1)
        
        return {
            "dias": dias,
            "total": len(dias),
            "difusora": difusora,
            "fecha_inicio": fecha_inicio,
            "fecha_fin": fecha_fin,
            "politica_id": politica_id
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error al obtener días de programación: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.get("/stats/generacion")
async def get_stats_generacion(db: Session = Depends(get_db)):
    """Obtener estadísticas de generación de programación"""
    try:
        # Estadísticas generales
        total_politicas = db.query(PoliticaProgramacionModel).count()
        politicas_habilitadas = db.query(PoliticaProgramacionModel).filter(
            PoliticaProgramacionModel.habilitada == True
        ).count()
        
        total_relojes = db.query(RelojModel).count()
        relojes_habilitados = db.query(RelojModel).filter(
            RelojModel.habilitado == True
        ).count()
        
        total_dias_modelo = db.query(DiaModeloModel).count()
        
        # Estadísticas por difusora
        politicas_por_difusora = db.query(
            PoliticaProgramacionModel.difusora,
            func.count(PoliticaProgramacionModel.id)
        ).group_by(PoliticaProgramacionModel.difusora).all()
        
        return {
            "politicas": {
                "total": total_politicas,
                "habilitadas": politicas_habilitadas,
                "por_difusora": [
                {"difusora": difusora, "count": count}
                for difusora, count in politicas_por_difusora
                ]
            },
            "relojes": {
                "total": total_relojes,
                "habilitados": relojes_habilitados
            },
            "dias_modelo": {
                "total": total_dias_modelo
            }
        }
        
    except Exception as e:
        logger.error(f"Error al obtener estadísticas de generación: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.get("/dias-modelo-difusora/{difusora}")
async def get_dias_modelo_by_difusora(difusora: str, db: Session = Depends(get_db)):
    """Obtener todos los días modelo de una difusora específica"""
    try:
        dias_modelo = db.query(DiaModeloModel).filter(
            DiaModeloModel.difusora == difusora,
            DiaModeloModel.habilitado == True
        ).all()
        
        # Convertir a diccionario simple para evitar problemas de serialización
        result = []
        for dia in dias_modelo:
            result.append({
                "id": dia.id,
                "clave": dia.clave,
                "nombre": dia.nombre,
                "descripcion": dia.descripcion,
                "difusora": dia.difusora
            })
        
        return {"dias_modelo": result, "difusora": difusora}
        
    except Exception as e:
        logger.error(f"Error al obtener días modelo de difusora {difusora}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")
