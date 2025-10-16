from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Optional
from app.core.database import get_db
from app.models.programacion import (
    Programacion as ProgramacionModel,
    Reloj as RelojModel,
    EventoReloj as EventoRelojModel,
    DiaModelo as DiaModeloModel,
    RelojDiaModelo as RelojDiaModeloModel
)
from app.models.categorias import Cancion as CancionModel, Categoria as CategoriaModel
from datetime import datetime, time, timedelta
import random
import logging

router = APIRouter()
logger = logging.getLogger(__name__)

def convertir_duracion_a_segundos(duracion_str: str) -> int:
    """Convertir duración HH:MM:SS a segundos"""
    try:
        partes = duracion_str.split(':')
        if len(partes) == 3:
            horas, minutos, segundos = map(int, partes)
            return horas * 3600 + minutos * 60 + segundos
        return 180  # 3 minutos por defecto
    except:
        return 180

@router.post("/generar-programacion-completa")
async def generar_programacion_completa(
    difusora: str = Query(..., description="Difusora"),
    politica_id: int = Query(..., description="ID de la política"),
    fecha_inicio: str = Query(..., description="Fecha de inicio (DD/MM/YYYY)"),
    fecha_fin: str = Query(..., description="Fecha de fin (DD/MM/YYYY)"),
    db: Session = Depends(get_db)
):
    """Generar programación completa basada en 24 relojes con corte automático"""
    try:
        # Convertir fechas
        fecha_inicio_dt = datetime.strptime(fecha_inicio, "%d/%m/%Y")
        fecha_fin_dt = datetime.strptime(fecha_fin, "%d/%m/%Y")
        
        dias_generados = 0
        dias_procesados = []
        
        # Obtener día modelo para esta política
        fecha_actual = fecha_inicio_dt
        while fecha_actual <= fecha_fin_dt:
            # Obtener día de la semana en español
            dias_semana_map = {
                0: 'lunes', 1: 'martes', 2: 'miercoles',
                3: 'jueves', 4: 'viernes', 5: 'sabado', 6: 'domingo'
            }
            dia_semana = dias_semana_map[fecha_actual.weekday()]
            
            # Buscar día modelo que aplique
            dia_modelo = db.query(DiaModeloModel).filter(
                DiaModeloModel.politica_id == politica_id,
                DiaModeloModel.difusora == difusora,
                DiaModeloModel.habilitado == True,
                getattr(DiaModeloModel, dia_semana) == True
            ).first()
            
            if not dia_modelo:
                logger.warning(f"No hay día modelo configurado para {fecha_actual.strftime('%d/%m/%Y')}")
                dias_procesados.append({
                    "fecha": fecha_actual.strftime("%d/%m/%Y"),
                    "dia_semana": fecha_actual.strftime("%A"),
                    "status": "Sin Configuración",
                    "generado": False
                })
                fecha_actual += timedelta(days=1)
                continue
            
            # Obtener relojes asociados al día modelo
            relojes_dia = db.query(RelojModel).join(
                RelojDiaModeloModel,
                RelojModel.id == RelojDiaModeloModel.reloj_id
            ).filter(
                RelojDiaModeloModel.dia_modelo_id == dia_modelo.id,
                RelojModel.habilitado == True
            ).order_by(RelojDiaModeloModel.orden).all()
            
            if not relojes_dia:
                logger.warning(f"No hay relojes configurados para {fecha_actual.strftime('%d/%m/%Y')}")
                dias_procesados.append({
                    "fecha": fecha_actual.strftime("%d/%m/%Y"),
                    "dia_semana": fecha_actual.strftime("%A"),
                    "status": "Sin Relojes",
                    "generado": False
                })
                fecha_actual += timedelta(days=1)
                continue
            
            # Eliminar programación existente para este día antes de generar nueva
            programacion_existente = db.query(ProgramacionModel).filter(
                ProgramacionModel.difusora == difusora,
                ProgramacionModel.politica_id == politica_id,
                ProgramacionModel.fecha == fecha_actual.date()
            ).all()
            
            if programacion_existente:
                logger.info(f"Eliminando {len(programacion_existente)} eventos existentes para {fecha_actual.strftime('%d/%m/%Y')}")
                for evento in programacion_existente:
                    db.delete(evento)
                db.flush()  # Aplicar eliminaciones antes de generar nueva programación
            
            # Generar programación para este día
            try:
                eventos_generados = await generar_programacion_dia(
                    fecha_actual, difusora, politica_id, relojes_dia, db
                )
                
                logger.info(f"Generados {len(eventos_generados)} eventos para {fecha_actual.strftime('%d/%m/%Y')}")
                
                dias_generados += 1
                dias_procesados.append({
                    "fecha": fecha_actual.strftime("%d/%m/%Y"),
                    "dia_semana": fecha_actual.strftime("%A"),
                    "status": "Generado",
                    "generado": True,
                    "num_eventos": len(eventos_generados)
                })
                
            except Exception as e:
                logger.error(f"Error al generar programación para {fecha_actual}: {str(e)}")
                dias_procesados.append({
                    "fecha": fecha_actual.strftime("%d/%m/%Y"),
                    "dia_semana": fecha_actual.strftime("%A"),
                    "status": "Error",
                    "generado": False
                })
            
            fecha_actual += timedelta(days=1)
        
        return {
            "message": "Programación generada correctamente",
            "dias_generados": dias_generados,
            "dias_procesados": dias_procesados,
            "difusora": difusora,
            "politica_id": politica_id,
            "fecha_inicio": fecha_inicio,
            "fecha_fin": fecha_fin
        }
        
    except ValueError as e:
        raise HTTPException(status_code=400, detail=f"Formato de fecha inválido: {str(e)}")
    except Exception as e:
        db.rollback()
        logger.error(f"Error al generar programación completa: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

async def generar_programacion_dia(
    fecha: datetime,
    difusora: str,
    politica_id: int,
    relojes: list,
    db: Session
):
    """Generar programación para un día completo con 24 relojes"""
    eventos_generados = []
    
    # Obtener la política para conocer las categorías seleccionadas
    from app.models.programacion import PoliticaProgramacion as PoliticaProgramacionModel
    politica = db.query(PoliticaProgramacionModel).filter(
        PoliticaProgramacionModel.id == politica_id
    ).first()
    
    if not politica:
        raise ValueError(f"Política {politica_id} no encontrada")
    
    # Obtener categorías seleccionadas de la política
    categorias_ids = []
    if politica.categorias_seleccionadas:
        try:
            categorias_ids = [int(c) for c in politica.categorias_seleccionadas.split(',') if c.strip()]
        except ValueError:
            logger.warning(f"Error al parsear categorias_seleccionadas: {politica.categorias_seleccionadas}")
    
    # Si no hay categorías en la política, usar todas
    if not categorias_ids:
        categorias_ids = [c.id for c in db.query(CategoriaModel.id).all()]
    
    # Obtener todas las canciones activas de las categorías seleccionadas
    canciones_por_categoria = {}
    for cat_id in categorias_ids:
        canciones = db.query(CancionModel).filter(
            CancionModel.categoria_id == cat_id,
            CancionModel.activa == True
        ).all()
        if canciones:
            categoria = db.query(CategoriaModel).filter(CategoriaModel.id == cat_id).first()
            if categoria:
                canciones_por_categoria[categoria.nombre] = canciones
    
    if not canciones_por_categoria:
        raise ValueError("No hay canciones activas en las categorías seleccionadas")
    
    # Crear pools de canciones sin repetir para cada categoría
    # Cada pool es una lista que se mezcla aleatoriamente
    canciones_pools = {}
    for categoria_nombre, canciones in canciones_por_categoria.items():
        # Crear una copia mezclada de las canciones
        pool = list(canciones)
        random.shuffle(pool)
        canciones_pools[categoria_nombre] = {
            'pool': pool,
            'index': 0,
            'total': len(pool)
        }
    
    def obtener_cancion_sin_repetir(categoria_nombre):
        """Obtiene una canción sin repetir hasta agotar el pool"""
        if categoria_nombre not in canciones_pools:
            return None
        
        pool_info = canciones_pools[categoria_nombre]
        
        # Si llegamos al final del pool, reiniciar y mezclar
        if pool_info['index'] >= pool_info['total']:
            random.shuffle(pool_info['pool'])
            pool_info['index'] = 0
        
        # Obtener la siguiente canción
        cancion = pool_info['pool'][pool_info['index']]
        pool_info['index'] += 1
        
        return cancion
    
    # Ordenar relojes por su clave (R00, R01, ..., R23)
    relojes_ordenados = sorted(relojes, key=lambda r: r.clave)
    
    # Variable para rastrear el tiempo real de finalización del reloj anterior
    tiempo_fin_reloj_anterior = 0
    
    for idx, reloj in enumerate(relojes_ordenados):
        # Cada reloj debe comenzar en su hora programada (00:00, 01:00, 02:00, etc.)
        hora_programada_reloj = idx * 3600  # 0, 3600, 7200, ... segundos
        
        # Si el reloj anterior terminó después de la hora programada, ajustar
        tiempo_inicio_segundos = max(hora_programada_reloj, tiempo_fin_reloj_anterior)
        
        # El tiempo disponible es 1 hora desde el inicio real del reloj
        tiempo_disponible_segundos = 3600  # 1 hora por reloj
        
        # Log para debugging
        hora_inicio_hhmmss = f"{tiempo_inicio_segundos//3600:02d}:{(tiempo_inicio_segundos%3600)//60:02d}:{tiempo_inicio_segundos%60:02d}"
        print(f"🕐 Reloj {reloj.clave} (índice {idx}) - Inicio: {hora_inicio_hhmmss}")
        
        # Obtener eventos del reloj
        eventos_reloj = db.query(EventoRelojModel).filter(
            EventoRelojModel.reloj_id == reloj.id
        ).order_by(EventoRelojModel.numero).all()
        
        if not eventos_reloj:
            # Si no hay eventos configurados, llenar con canciones aleatorias
            eventos_reloj = []
        
        # Generar eventos hasta llenar el tiempo disponible (1 hora exacta)
        # NO forzar 60 minutos si no hay tiempo suficiente
        tiempo_usado = 0
        hora_actual_segundos = tiempo_inicio_segundos
        evento_idx = 0
        
        # Generar solo los eventos configurados en el reloj
        for evento_idx, evento in enumerate(eventos_reloj):
            duracion_evento_segundos = convertir_duracion_a_segundos(evento.duracion)
            tipo_evento = evento.tipo
            categoria_evento = evento.categoria
            
            # Si el evento excede el tiempo disponible, cortarlo
            tiempo_restante = tiempo_disponible_segundos - tiempo_usado
            if duracion_evento_segundos > tiempo_restante:
                duracion_evento_segundos = tiempo_restante
                if duracion_evento_segundos <= 0:
                    break
            
            # Seleccionar canción sin repetir de la categoría específica del evento
            cancion_seleccionada = None
            categoria_nombre = None
            if tipo_evento == 'cancion' or tipo_evento == '1':
                # Usar la categoría específica del evento (descripción del evento)
                categoria_nombre = evento.descripcion if evento_idx < len(eventos_reloj) else "Rock"
                
                # Verificar que la categoría esté disponible en las categorías de la política
                if categoria_nombre in canciones_por_categoria:
                    # Obtener canción sin repetir del pool de esa categoría específica
                    cancion_seleccionada = obtener_cancion_sin_repetir(categoria_nombre)
                    
                    # Usar la duración real de la canción si está disponible
                    if cancion_seleccionada and cancion_seleccionada.duracion:
                        duracion_evento_segundos = cancion_seleccionada.duracion
                else:
                    # Si la categoría no está disponible, usar una aleatoria como fallback
                    categoria_nombre = random.choice(list(canciones_por_categoria.keys()))
                    cancion_seleccionada = obtener_cancion_sin_repetir(categoria_nombre)
                    if cancion_seleccionada and cancion_seleccionada.duracion:
                        duracion_evento_segundos = cancion_seleccionada.duracion
            
            # Calcular hora real del evento
            hora_real_segundos = tiempo_inicio_segundos + tiempo_usado
            hora_real_horas = hora_real_segundos // 3600
            hora_real_minutos = (hora_real_segundos % 3600) // 60
            hora_real_seg = hora_real_segundos % 60
            
            # Convertir duración a formato HH:MM:SS
            dur_horas = duracion_evento_segundos // 3600
            dur_minutos = (duracion_evento_segundos % 3600) // 60
            dur_segundos = duracion_evento_segundos % 60
            duracion_str = f"{dur_horas:02d}:{dur_minutos:02d}:{dur_segundos:02d}"
            
            # Obtener la categoría de la canción seleccionada
            categoria_nombre = categoria_nombre if cancion_seleccionada else (categoria_evento if evento_idx < len(eventos_reloj) else "Sin categoría")
            
            # Crear entrada de programación
            programacion_entry = ProgramacionModel(
                mc=True if cancion_seleccionada else False,
                numero_reloj=reloj.clave,
                hora_real=time(hora_real_horas % 24, hora_real_minutos, hora_real_seg),
                hora_transmision=time(hora_real_horas % 24, hora_real_minutos, hora_real_seg),
                duracion_real=duracion_str,
                tipo=tipo_evento,
                hora_planeada=time(hora_real_horas % 24, hora_real_minutos, hora_real_seg),
                duracion_planeada=duracion_str,
                categoria=categoria_nombre,
                id_media=str(cancion_seleccionada.id) if cancion_seleccionada else (evento.id_media if evento_idx < len(eventos_reloj) else f"AUTO_{idx}_{evento_idx}"),
                descripcion=cancion_seleccionada.titulo if cancion_seleccionada else (evento.descripcion if evento_idx < len(eventos_reloj) else f"Canción {evento_idx + 1}"),
                lenguaje="Español" if cancion_seleccionada else "",
                interprete=cancion_seleccionada.artista if cancion_seleccionada else "",
                disco=cancion_seleccionada.album if cancion_seleccionada else "",
                sello_discografico="",
                bpm=0,
                año=0,
                difusora=difusora,
                politica_id=politica_id,
                fecha=fecha.date(),
                reloj_id=reloj.id,
                evento_reloj_id=eventos_reloj[evento_idx].id if evento_idx < len(eventos_reloj) else None
            )
            
            db.add(programacion_entry)
            eventos_generados.append(programacion_entry)
            
            # Avanzar tiempo
            tiempo_usado += duracion_evento_segundos
            hora_actual_segundos += duracion_evento_segundos
        
        # Al finalizar el reloj, actualizar el tiempo de finalización para el siguiente reloj
        tiempo_fin_reloj_anterior = tiempo_inicio_segundos + tiempo_usado
        
        # Log para debugging
        hora_fin_hhmmss = f"{tiempo_fin_reloj_anterior//3600:02d}:{(tiempo_fin_reloj_anterior%3600)//60:02d}:{tiempo_fin_reloj_anterior%60:02d}"
        hora_programada_hhmmss = f"{hora_programada_reloj//3600:02d}:{(hora_programada_reloj%3600)//60:02d}:{hora_programada_reloj%60:02d}"
        print(f"✅ Reloj {reloj.clave} completado - Programado: {hora_programada_hhmmss}, Inicio real: {hora_inicio_hhmmss}, Fin: {hora_fin_hhmmss}")
    
    # Guardar en la base de datos
    db.commit()
    
    return eventos_generados

@router.get("/dias-simple")
async def obtener_dias_simple(
    fecha_inicio: str = Query(..., description="Fecha de inicio en formato DD/MM/YYYY"),
    fecha_fin: str = Query(..., description="Fecha de fin en formato DD/MM/YYYY"),
    difusora: str = Query(..., description="Difusora"),
    politica_id: Optional[int] = Query(None, description="ID de la política"),
    db: Session = Depends(get_db)
):
    """Obtener días de programación en formato simple"""
    try:
        # Convertir fechas
        fecha_inicio_dt = datetime.strptime(fecha_inicio, "%d/%m/%Y")
        fecha_fin_dt = datetime.strptime(fecha_fin, "%d/%m/%Y")
        
        dias = []
        fecha_actual = fecha_inicio_dt
        
        while fecha_actual <= fecha_fin_dt:
            # Obtener día de la semana en español
            dias_semana_map = {
                0: 'lunes', 1: 'martes', 2: 'miercoles',
                3: 'jueves', 4: 'viernes', 5: 'sabado', 6: 'domingo'
            }
            dia_semana_espanol = dias_semana_map[fecha_actual.weekday()]
            
            # Verificar si existe programación para este día
            programacion_existente = db.query(ProgramacionModel).filter(
                ProgramacionModel.difusora == difusora,
                ProgramacionModel.fecha == fecha_actual.date()
            )
            
            if politica_id:
                programacion_existente = programacion_existente.filter(
                    ProgramacionModel.politica_id == politica_id
                )
            
            programacion_count = programacion_existente.count()
            
            # Determinar status
            if programacion_count > 0:
                status = "Con Programación"
                tiene_programacion = True
            else:
                status = "Sin Configuración"
                tiene_programacion = False
            
            # Solo buscar día modelo si ya existe programación
            dia_modelo_nombre = ""
            if tiene_programacion and politica_id:
                dia_modelo = db.query(DiaModeloModel).filter(
                    DiaModeloModel.politica_id == politica_id,
                    DiaModeloModel.difusora == difusora,
                    DiaModeloModel.habilitado == True,
                    getattr(DiaModeloModel, dia_semana_espanol) == True
                ).first()
                
                if dia_modelo:
                    dia_modelo_nombre = dia_modelo.nombre
            
            # Nombres de días en español
            dias_espanol = {
                'Monday': 'Lunes', 'Tuesday': 'Martes', 'Wednesday': 'Miércoles',
                'Thursday': 'Jueves', 'Friday': 'Viernes', 'Saturday': 'Sábado', 'Sunday': 'Domingo'
            }
            dia_ingles = fecha_actual.strftime("%A")
            dia_nombre = dias_espanol.get(dia_ingles, dia_ingles)
            
            dias.append({
                "fecha": fecha_actual.strftime("%d/%m/%Y"),
                "dia_semana": dia_nombre,
                "status": status,
                "num_eventos": programacion_count,
                "num_canciones": programacion_count,  # Simplificado
                "num_asignadas": programacion_count,  # Simplificado
                "porcentaje": 100 if programacion_count > 0 else 0,
                "minutos_comerciales": 0,
                "tiene_programacion": tiene_programacion,
                "dia_modelo": dia_modelo_nombre
            })
            
            fecha_actual += timedelta(days=1)
        
        return {
            "dias": dias,
            "total_dias": len(dias)
        }
        
    except ValueError as e:
        raise HTTPException(status_code=400, detail=f"Formato de fecha inválido: {str(e)}")
    except Exception as e:
        logger.error(f"Error al obtener días simples: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.get("/programacion-detallada")
async def obtener_programacion_detallada(
    difusora: str = Query(..., description="Difusora"),
    politica_id: int = Query(..., description="ID de la política"),
    fecha: str = Query(..., description="Fecha en formato DD/MM/YYYY"),
    db: Session = Depends(get_db)
):
    """Obtener programación detallada para un día específico"""
    try:
        # Convertir fecha
        fecha_dt = datetime.strptime(fecha, "%d/%m/%Y").date()
        
        # Obtener todos los registros de programación para este día
        programacion = db.query(ProgramacionModel).filter(
            ProgramacionModel.difusora == difusora,
            ProgramacionModel.politica_id == politica_id,
            ProgramacionModel.fecha == fecha_dt
        ).order_by(
            ProgramacionModel.hora_real,
            ProgramacionModel.id
        ).all()
        
        if not programacion:
            return {
                "programacion": [],
                "total_eventos": 0,
                "mensaje": "No hay programación para esta fecha"
            }
        
        # Formatear respuesta
        eventos = []
        for prog in programacion:
            eventos.append({
                "id": prog.id,
                "mc": prog.mc,
                "numero_reloj": prog.numero_reloj,
                "hora_real": prog.hora_real.strftime("%H:%M:%S") if prog.hora_real else "",
                "hora_transmision": prog.hora_transmision.strftime("%H:%M:%S") if prog.hora_transmision else "",
                "duracion_real": prog.duracion_real or "",
                "tipo": prog.tipo,
                "hora_planeada": prog.hora_planeada.strftime("%H:%M:%S") if prog.hora_planeada else "",
                "duracion_planeada": prog.duracion_planeada or "",
                "categoria": prog.categoria,
                "id_media": prog.id_media or "",
                "descripcion": prog.descripcion or "",
                "lenguaje": prog.lenguaje or "",
                "interprete": prog.interprete or "",
                "disco": prog.disco or "",
                "sello_discografico": prog.sello_discografico or "",
                "bpm": prog.bpm or 0,
                "año": prog.año or 0,
                "difusora": prog.difusora,
                "politica_id": prog.politica_id,
                "fecha": prog.fecha.strftime("%d/%m/%Y"),
                "reloj_id": prog.reloj_id,
                "evento_reloj_id": prog.evento_reloj_id
            })
        
        return {
            "programacion": eventos,
            "total_eventos": len(eventos),
            "difusora": difusora,
            "politica_id": politica_id,
            "fecha": fecha
        }
        
    except ValueError as e:
        raise HTTPException(status_code=400, detail=f"Formato de fecha inválido: {str(e)}")
    except Exception as e:
        logger.error(f"Error al obtener programación detallada: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.get("/generar-logfile")
async def generar_logfile(
    difusora: str = Query(..., description="Difusora"),
    politica_id: int = Query(..., description="ID de la política"),
    fecha: str = Query(..., description="Fecha en formato DD/MM/YYYY"),
    db: Session = Depends(get_db)
):
    """Generar log file para un día específico"""
    try:
        from app.services.programacion.logfiles_service import LogfilesService
        
        # Crear instancia del servicio
        logfiles_service = LogfilesService(db)
        
        # Validar parámetros
        validacion = logfiles_service.validar_parametros_logfile(difusora, politica_id, fecha)
        if not validacion["es_valido"]:
            raise HTTPException(status_code=400, detail=f"Parámetros inválidos: {', '.join(validacion['errores'])}")
        
        # Generar logfile
        resultado = logfiles_service.generar_logfile_dia(difusora, politica_id, fecha)
        
        if not resultado["success"]:
            raise HTTPException(status_code=500, detail=resultado["message"])
        
        # Crear respuesta con el contenido del log file
        from fastapi.responses import Response
        
        return Response(
            content=resultado["logfile"]["contenido"],
            media_type="text/plain",
            headers={
                "Content-Disposition": f"attachment; filename={resultado['logfile']['nombre_archivo']}"
            }
        )
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error al generar log file: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")


