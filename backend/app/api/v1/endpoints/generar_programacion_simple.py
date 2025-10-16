from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.models.programacion import Programacion as ProgramacionModel
from app.models.categorias import Cancion as CancionModel, Categoria as CategoriaModel
from datetime import datetime, time, timedelta
import random
import logging

router = APIRouter()
logger = logging.getLogger(__name__)

@router.post("/generar-programacion-simple")
async def generar_programacion_simple(
    difusora: str = Query(..., description="Difusora"),
    politica_id: int = Query(..., description="ID de la política"),
    fecha_inicio: str = Query(..., description="Fecha de inicio (DD/MM/YYYY)"),
    fecha_fin: str = Query(..., description="Fecha de fin (DD/MM/YYYY)"),
    db: Session = Depends(get_db)
):
    """Generar programación simple para un período"""
    try:
        # Convertir fechas
        fecha_inicio_dt = datetime.strptime(fecha_inicio, "%d/%m/%Y")
        fecha_fin_dt = datetime.strptime(fecha_fin, "%d/%m/%Y")
        
        # Obtener canciones activas
        canciones = db.query(CancionModel).filter(CancionModel.activa == True).all()
        
        if not canciones:
            return {
                "message": "No hay canciones disponibles",
                "dias_generados": 0,
                "dias_procesados": []
            }
        
        dias_generados = 0
        dias_procesados = []
        
        # Generar programación para cada día
        fecha_actual = fecha_inicio_dt
        while fecha_actual <= fecha_fin_dt:
            # Seleccionar canción aleatoria
            cancion_seleccionada = random.choice(canciones)
            
            # Usar la duración real de la canción
            duracion_segundos = cancion_seleccionada.duracion if cancion_seleccionada.duracion else 180
            horas = duracion_segundos // 3600
            minutos = (duracion_segundos % 3600) // 60
            segundos = duracion_segundos % 60
            duracion_real = f"{horas:02d}:{minutos:02d}:{segundos:02d}"
            
            # Crear entrada de programación
            programacion_entry = ProgramacionModel(
                mc=True,
                numero_reloj="SIMPLE_01",
                hora_real=time(6, 0),
                hora_transmision=time(6, 0),
                duracion_real=duracion_real,
                tipo="cancion",
                hora_planeada=time(6, 0),
                duracion_planeada=duracion_real,
                categoria="Sin categoría",
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
                fecha=fecha_actual.date(),
                reloj_id=None,
                evento_reloj_id=None
            )
            
            db.add(programacion_entry)
            dias_generados += 1
            
            dias_procesados.append({
                "fecha": fecha_actual.strftime("%d/%m/%Y"),
                "dia_semana": fecha_actual.strftime("%A"),
                "status": "Generado",
                "generado": True
            })
            
            fecha_actual += timedelta(days=1)
        
        # Guardar en la base de datos
        db.commit()
        
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
        logger.error(f"Error al generar programación simple: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")
