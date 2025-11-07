from fastapi import APIRouter, Depends, HTTPException, Query, Body
from sqlalchemy.orm import Session
from typing import Optional
from app.core.database import get_db
from app.core.auth import get_current_user, get_user_difusoras
from app.models.auth import Usuario
from app.schemas.programacion import GenerarProgramacionRequest
from app.models.programacion import (
    Programacion as ProgramacionModel,
    Reloj as RelojModel,
    EventoReloj as EventoRelojModel,
    DiaModelo as DiaModeloModel,
    RelojDiaModelo as RelojDiaModeloModel,
    Regla as ReglaModel,
    SeparacionRegla as SeparacionReglaModel
)
from app.models.categorias import Cancion as CancionModel, Categoria as CategoriaModel
from datetime import datetime, time, timedelta
import random

router = APIRouter()

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
    request: GenerarProgramacionRequest = Body(...),
    difusora: str = Query(..., description="Difusora"),
    politica_id: int = Query(..., description="ID de la política"),
    fecha_inicio: str = Query(..., description="Fecha de inicio (DD/MM/YYYY)"),
    fecha_fin: str = Query(..., description="Fecha de fin (DD/MM/YYYY)"),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: list = Depends(get_user_difusoras),
    db: Session = Depends(get_db)
):
    """Generar programación completa basada en 24 relojes con corte automático"""
    try:
        # Validar que request.dias_modelo no esté vacío
        if not request.dias_modelo or len(request.dias_modelo) == 0:
            raise HTTPException(
                status_code=400,
                detail="No se proporcionaron días modelo para generar la programación"
            )
        
        # Verificar que el usuario tenga acceso a la difusora
        if usuario.rol != "admin" and difusora not in difusoras_allowed:
            raise HTTPException(
                status_code=403,
                detail=f"No tienes permiso para generar programación para la difusora {difusora}"
            )
        
        # Convertir fechas
        try:
            fecha_inicio_dt = datetime.strptime(fecha_inicio, "%d/%m/%Y")
            fecha_fin_dt = datetime.strptime(fecha_fin, "%d/%m/%Y")
        except ValueError as e:
            raise HTTPException(
                status_code=400,
                detail=f"Formato de fecha inválido. Esperado DD/MM/YYYY. Error: {str(e)}"
            )
        
        dias_generados = 0
        dias_procesados = []
        
        # Crear un diccionario de días modelo seleccionados por fecha
        dias_modelo_por_fecha = {}

        for dia_seleccionado in request.dias_modelo:
            # Registrar el día modelo seleccionado por fecha para usarlo en el bucle principal
            try:
                fecha_key = dia_seleccionado.fecha if isinstance(dia_seleccionado.fecha, str) else str(dia_seleccionado.fecha)
                # Normalizar el formato de fecha a DD/MM/YYYY si viene en otro formato
                if '/' in fecha_key:
                    # Ya está en formato DD/MM/YYYY
                    dias_modelo_por_fecha[fecha_key] = dia_seleccionado.dia_modelo
                elif '-' in fecha_key:
                    # Convertir de YYYY-MM-DD a DD/MM/YYYY
                    try:
                        fecha_dt = datetime.strptime(fecha_key, "%Y-%m-%d")
                        fecha_key = fecha_dt.strftime("%d/%m/%Y")
                        dias_modelo_por_fecha[fecha_key] = dia_seleccionado.dia_modelo
                    except:
                        dias_modelo_por_fecha[fecha_key] = dia_seleccionado.dia_modelo
                else:
                    dias_modelo_por_fecha[fecha_key] = dia_seleccionado.dia_modelo
            except Exception:
                # Si hay algún problema, intentar con string
                dias_modelo_por_fecha[str(dia_seleccionado.fecha)] = dia_seleccionado.dia_modelo
        
        # Obtener día modelo para esta política
        fecha_actual = fecha_inicio_dt
        while fecha_actual <= fecha_fin_dt:
            fecha_str = fecha_actual.strftime("%d/%m/%Y")
            
            # Obtener día de la semana en español
            dias_semana_map = {
                0: 'lunes', 1: 'martes', 2: 'miercoles',
                3: 'jueves', 4: 'viernes', 5: 'sabado', 6: 'domingo'
            }
            dia_semana = dias_semana_map[fecha_actual.weekday()]
            
            # Buscar día modelo seleccionado por el usuario
            dia_modelo_nombre = dias_modelo_por_fecha.get(fecha_str)
            if not dia_modelo_nombre or (isinstance(dia_modelo_nombre, str) and dia_modelo_nombre.strip() == ''):
                dias_procesados.append({
                    "fecha": fecha_str,
                    "dia_semana": fecha_actual.strftime("%A"),
                    "status": "Sin Día Modelo Seleccionado",
                    "generado": False
                })
                fecha_actual += timedelta(days=1)
                continue
            
            # Buscar el día modelo por nombre (búsqueda flexible por difusora)


            
            # Primero intentar buscar con difusora específica
            dia_modelo = db.query(DiaModeloModel).filter(
                DiaModeloModel.politica_id == politica_id,
                DiaModeloModel.difusora == difusora,
                DiaModeloModel.habilitado == True,
                DiaModeloModel.nombre == dia_modelo_nombre
            ).first()
            
            # Si no se encuentra, buscar sin restricción de difusora (permite "TODAS" o cualquier otra)
            if not dia_modelo:


                dia_modelo = db.query(DiaModeloModel).filter(
                    DiaModeloModel.politica_id == politica_id,
                    DiaModeloModel.habilitado == True,
                    DiaModeloModel.nombre == dia_modelo_nombre
                ).first()
            
            # Si aún no se encuentra, buscar solo por política y nombre (última opción)
            if not dia_modelo:


                dia_modelo = db.query(DiaModeloModel).filter(
                    DiaModeloModel.politica_id == politica_id,
                    DiaModeloModel.nombre == dia_modelo_nombre
                ).first()
            
            if not dia_modelo:
                dias_procesados.append({
                    "fecha": fecha_str,
                    "dia_semana": fecha_actual.strftime("%A"),
                    "status": f"Día Modelo '{dia_modelo_nombre}' no encontrado",
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

                for evento in programacion_existente:
                    db.delete(evento)
                db.flush()  # Aplicar eliminaciones antes de generar nueva programación
            
            # Generar programación para este día
            try:
                eventos_generados = await generar_programacion_dia(
                    fecha_actual, difusora, politica_id, relojes_dia, dia_modelo.id, db
                )
                
                dias_generados += 1
                dias_procesados.append({
                    "fecha": fecha_actual.strftime("%d/%m/%Y"),
                    "dia_semana": fecha_actual.strftime("%A"),
                    "status": "Generado",
                    "generado": True,
                    "num_eventos": len(eventos_generados)
                })
                
            except ValueError as ve:
                # Errores de validación (política no encontrada, sin canciones, etc.)
                dias_procesados.append({
                    "fecha": fecha_actual.strftime("%d/%m/%Y"),
                    "dia_semana": fecha_actual.strftime("%A"),
                    "status": f"Error de validación: {str(ve)}",
                    "generado": False
                })
            except Exception as e:
                # Otros errores
                dias_procesados.append({
                    "fecha": fecha_actual.strftime("%d/%m/%Y"),
                    "dia_semana": fecha_actual.strftime("%A"),
                    "status": f"Error: {str(e)}",
                    "generado": False
                })
                # Si es un error crítico, re-lanzarlo
                if "no encontrada" in str(e).lower() or "no hay" in str(e).lower():
                    raise
            
            fecha_actual += timedelta(days=1)
        
        # Hacer commit de todos los cambios después de generar toda la programación
        try:
            db.commit()


        except Exception as e:
            db.rollback()


            raise HTTPException(status_code=500, detail=f"Error al guardar la programación: {str(e)}")
        
        # Si no se generó ningún día, proporcionar información detallada
        if dias_generados == 0:
            errores_resumen = {}
            for dia in dias_procesados:
                status = dia.get("status", "Desconocido")
                if status not in errores_resumen:
                    errores_resumen[status] = 0
                errores_resumen[status] += 1
            
            mensaje_error = "No se generó programación para ningún día. "
            if errores_resumen:
                detalles = ", ".join([f"{count} día(s) con '{status}'" for status, count in errores_resumen.items()])
                mensaje_error += f"Detalles: {detalles}."
            else:
                mensaje_error += "No se encontraron días modelo seleccionados para las fechas especificadas."
            
            raise HTTPException(
                status_code=400,
                detail=mensaje_error
            )
        
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
        db.rollback()
        raise HTTPException(status_code=400, detail=f"Formato de fecha inválido: {str(e)}")
    except HTTPException:
        # Re-raise HTTP exceptions (como 403)
        raise
    except Exception as e:
        db.rollback()
        # Incluir el error real para debugging
        raise HTTPException(status_code=500, detail=f"Error interno del servidor: {str(e)}")

async def generar_programacion_dia(
    fecha: datetime,
    difusora: str,
    politica_id: int,
    relojes: list,
    dia_modelo_id: int,
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
            categorias_ids = []
    
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
    
    # Obtener todas las reglas habilitadas de la política
    reglas = db.query(ReglaModel).filter(
        ReglaModel.politica_id == politica_id,
        ReglaModel.habilitada == True
    ).all()
    
    # Cargar separaciones para cada regla
    reglas_con_separaciones = {}
    for regla in reglas:
        separaciones = db.query(SeparacionReglaModel).filter(
            SeparacionReglaModel.regla_id == regla.id
        ).all()
        reglas_con_separaciones[regla.id] = {
            'regla': regla,
            'separaciones': {sep.valor: sep.separacion for sep in separaciones}
        }
    


    
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
    
    # Lista para rastrear eventos programados (para validación de reglas)
    eventos_programados = []  # Lista de dict con información de cada evento
    
    def obtener_valor_caracteristica(cancion, caracteristica):
        """Obtiene el valor de una característica específica de una canción"""
        if caracteristica.lower() == 'id_cancion' or caracteristica.lower() == 'id de canción':
            return str(cancion.id)
        elif caracteristica.lower() == 'artista':
            return cancion.artista or ''
        elif caracteristica.lower() == 'album':
            return cancion.album or ''
        elif caracteristica.lower() == 'titulo':
            return cancion.titulo or ''
        elif caracteristica.lower() == 'duracion':
            return str(cancion.duracion) if cancion.duracion else '0'
        else:
            # Intentar obtener como atributo
            return str(getattr(cancion, caracteristica.lower(), ''))
    
    def convertir_separacion_a_valor(tipo_separacion, separacion_int, eventos_programados, tiempo_actual):
        """Convierte el tipo de separación a un valor comparable"""
        if tipo_separacion == 'Número de Eventos':
            return separacion_int  # Ya es número de eventos
        elif tipo_separacion == 'Número de Canciones':
            # Contar solo eventos que son canciones (mc=True)
            return separacion_int
        elif tipo_separacion == 'Tiempo - Segundos':
            return separacion_int  # Ya es segundos
        elif tipo_separacion == 'Tiempo - DD:HH:MM':
            # Convertir DD:HH:MM a segundos
            # Formato esperado: "DD:HH:MM" o solo el número de segundos
            return separacion_int  # Por ahora asumimos que ya viene en segundos
        return separacion_int
    
    def validar_separacion_minima(cancion, eventos_programados, regla_info, hora_actual):
        """Valida la regla de Separación Mínima"""
        regla = regla_info['regla']
        separaciones = regla_info['separaciones']
        caracteristica = regla.caracteristica
        
        valor_cancion = obtener_valor_caracteristica(cancion, caracteristica)
        
        # Buscar si hay una separación específica para este valor o "Todos los valores" / "todos"
        separacion_requerida = None
        if 'Todos los valores' in separaciones or 'todos' in separaciones:
            separacion_requerida = separaciones.get('Todos los valores') or separaciones.get('todos')
        elif valor_cancion in separaciones:
            separacion_requerida = separaciones[valor_cancion]
        else:
            # Buscar por coincidencia parcial (ej: "artista_1" para cualquier artista)
            for key, value in separaciones.items():
                if key.lower().startswith(caracteristica.lower()) or valor_cancion.lower() in key.lower():
                    separacion_requerida = value
                    break
        
        if separacion_requerida is None:
            return True  # No hay restricción para este valor
        
        # Convertir separación según tipo
        separacion_valor = convertir_separacion_a_valor(
            regla.tipo_separacion, 
            separacion_requerida, 
            eventos_programados,
            hora_actual
        )
        
        # Revisar eventos programados hacia atrás
        eventos_recientes = eventos_programados[-separacion_valor:] if len(eventos_programados) >= separacion_valor else eventos_programados
        
        if regla.tipo_separacion == 'Número de Eventos':
            # Verificar que no haya otro evento con el mismo valor en los últimos N eventos
            for evento in eventos_recientes:
                if evento.get('cancion') and obtener_valor_caracteristica(evento['cancion'], caracteristica) == valor_cancion:
                    return False
        elif regla.tipo_separacion == 'Número de Canciones':
            # Verificar que no haya otra canción con el mismo valor en las últimas N canciones
            # Contar solo canciones (no eventos no musicales)
            canciones_recientes = [e for e in eventos_programados if e.get('cancion')]
            if len(canciones_recientes) >= separacion_valor:
                # Revisar las últimas N canciones
                for evento in canciones_recientes[-separacion_valor:]:
                    if obtener_valor_caracteristica(evento['cancion'], caracteristica) == valor_cancion:
                        return False
            else:
                # Si hay menos canciones que el requerimiento, verificar todas
                for evento in canciones_recientes:
                    if obtener_valor_caracteristica(evento['cancion'], caracteristica) == valor_cancion:
                        return False
        elif regla.tipo_separacion in ['Tiempo - Segundos', 'Tiempo - DD:HH:MM']:
            # Verificar que no haya otro evento con el mismo valor en el tiempo especificado
            tiempo_limite = hora_actual - separacion_valor
            for evento in reversed(eventos_programados):
                if evento.get('tiempo_inicio_segundos', 0) < tiempo_limite:
                    break
                if evento.get('cancion') and obtener_valor_caracteristica(evento['cancion'], caracteristica) == valor_cancion:
                    return False
        
        return True
    
    def validar_maximo_en_hilera(cancion, eventos_programados, regla_info):
        """Valida la regla de Máximo de Canciones en Hilera"""
        regla = regla_info['regla']
        separaciones = regla_info['separaciones']
        caracteristica = regla.caracteristica
        
        valor_cancion = obtener_valor_caracteristica(cancion, caracteristica)
        
        # Obtener el máximo permitido (generalmente está en "Todos los valores" o "todos")
        max_permitido = separaciones.get('Todos los valores') or separaciones.get('todos') or separaciones.get(valor_cancion)
        if max_permitido is None:
            # Buscar por coincidencia parcial
            for key, value in separaciones.items():
                if key.lower().startswith(caracteristica.lower()) or valor_cancion.lower() in key.lower():
                    max_permitido = value
                    break
        if max_permitido is None:
            return True  # No hay restricción
        
        # Contar canciones consecutivas con el mismo valor al final de la lista
        contador = 0
        for evento in reversed(eventos_programados):
            if not evento.get('cancion'):
                break  # Si encontramos un evento que no es canción, romper la hilera
            if obtener_valor_caracteristica(evento['cancion'], caracteristica) == valor_cancion:
                contador += 1
            else:
                break
        
        # Si ya alcanzamos el máximo, no podemos agregar otra
        return contador < max_permitido
    
    def validar_proteccion_dias_anteriores(cancion, eventos_programados, regla_info, fecha_actual, db_session, hora_actual_segundos=0):
        """Valida la regla de Protección de Días Anteriores - Evita que se programen canciones si hubo canciones con la misma característica a la misma hora en días consecutivos"""
        regla = regla_info['regla']
        caracteristica = regla.caracteristica
        
        # Si solo_verificar_dia es True, no verificar días anteriores
        if regla.solo_verificar_dia:
            return True
        
        # Obtener la hora actual del evento que estamos programando
        # Usar el parámetro hora_actual_segundos que se pasa desde obtener_cancion_sin_repetir
        hora_actual_time = time((hora_actual_segundos // 3600) % 24, (hora_actual_segundos % 3600) // 60, hora_actual_segundos % 60)
        
        valor_cancion = obtener_valor_caracteristica(cancion, caracteristica)
        
        # Verificar días anteriores (máximo 7 días hacia atrás)
        for dias_atras in range(1, 8):
            fecha_anterior = fecha_actual - timedelta(days=dias_atras)
            eventos_anteriores = db_session.query(ProgramacionModel).filter(
                ProgramacionModel.fecha == fecha_anterior.date(),
                ProgramacionModel.politica_id == regla.politica_id,
                ProgramacionModel.mc == True  # Solo canciones
            ).all()
            
            for evento_anterior in eventos_anteriores:
                if evento_anterior.hora_real == hora_actual_time:
                    # Verificar si tiene la misma característica
                    # Verificar según la característica
                    valor_anterior = None
                    if caracteristica.lower() in ['id_cancion', 'id de canción']:
                        valor_anterior = evento_anterior.id_media
                    elif caracteristica.lower() == 'artista':
                        valor_anterior = evento_anterior.interprete
                    elif caracteristica.lower() == 'album':
                        valor_anterior = evento_anterior.disco
                    elif caracteristica.lower() == 'titulo':
                        valor_anterior = evento_anterior.descripcion
                    # TODO: Agregar más características según necesidad
                    
                    # Comparar valores
                    if valor_anterior and str(valor_anterior).lower() == str(valor_cancion).lower():
                        return False
        
        return True
    
    def validar_maxima_diferencia_permitida(cancion, eventos_programados, regla_info):
        """Valida la regla de Máxima Diferencia Permitida - Para canciones con valores numéricos, evita cambios bruscos"""
        regla = regla_info['regla']
        separaciones = regla_info['separaciones']
        caracteristica = regla.caracteristica
        
        # Obtener el valor numérico de la canción para la característica
        try:
            valor_actual = float(obtener_valor_caracteristica(cancion, caracteristica))
        except (ValueError, TypeError):
            return True  # Si no es numérico, no aplicar esta regla
        
        # Obtener el máximo permitido (generalmente está en "Todos los valores" o "todos")
        max_diferencia = separaciones.get('Todos los valores') or separaciones.get('todos')
        if max_diferencia is None:
            return True  # No hay restricción
        
        # Verificar diferencias con eventos recientes (últimas 10 canciones)
        for evento in reversed(eventos_programados[-10:]):
            if not evento.get('cancion'):
                continue
            try:
                valor_anterior = float(obtener_valor_caracteristica(evento['cancion'], caracteristica))
                diferencia = abs(valor_actual - valor_anterior)
                if diferencia > max_diferencia:
                    return False
            except (ValueError, TypeError):
                continue
        
        return True
    
    def validar_minima_diferencia_permitida(cancion, eventos_programados, regla_info):
        """Valida la regla de Mínima Diferencia Permitida - Sirve a la inversa de Máxima Diferencia Permitida"""
        regla = regla_info['regla']
        separaciones = regla_info['separaciones']
        caracteristica = regla.caracteristica
        
        # Obtener el valor numérico de la canción para la característica
        try:
            valor_actual = float(obtener_valor_caracteristica(cancion, caracteristica))
        except (ValueError, TypeError):
            return True  # Si no es numérico, no aplicar esta regla
        
        # Obtener el mínimo permitido (generalmente está en "Todos los valores" o "todos")
        min_diferencia = separaciones.get('Todos los valores') or separaciones.get('todos')
        if min_diferencia is None:
            return True  # No hay restricción
        
        # Verificar diferencias con eventos recientes (últimas 10 canciones)
        for evento in reversed(eventos_programados[-10:]):
            if not evento.get('cancion'):
                continue
            try:
                valor_anterior = float(obtener_valor_caracteristica(evento['cancion'], caracteristica))
                diferencia = abs(valor_actual - valor_anterior)
                if diferencia < min_diferencia:
                    return False
            except (ValueError, TypeError):
                continue
        
        return True
    
    def validar_maximas_en_periodo(cancion, eventos_programados, regla_info, hora_actual):
        """Valida la regla de Canciones Máximas en un Periodo - Evita que en un periodo se programen más de N canciones con la misma característica"""
        regla = regla_info['regla']
        separaciones = regla_info['separaciones']
        caracteristica = regla.caracteristica
        
        valor_cancion = obtener_valor_caracteristica(cancion, caracteristica)
        
        # Obtener el máximo permitido (generalmente está en "Todos los valores" o "todos")
        max_permitido = separaciones.get('Todos los valores') or separaciones.get('todos')
        if max_permitido is None:
            return True
        
        # Para esta regla, el tipo_separacion indica cómo medir el periodo
        # y el valor en separaciones indica el máximo de canciones permitidas en ese periodo
        
        if regla.tipo_separacion in ['Tiempo - Segundos', 'Tiempo - DD:HH:MM']:
            # El separacion indica el periodo en segundos
            periodo_segundos = max_permitido
            tiempo_limite = hora_actual - periodo_segundos
            
            # Contar canciones en el periodo con la misma característica
            contador = 0
            for evento in reversed(eventos_programados):
                if evento.get('tiempo_inicio_segundos', 0) < tiempo_limite:
                    break
                if evento.get('cancion') and obtener_valor_caracteristica(evento['cancion'], caracteristica) == valor_cancion:
                    contador += 1
            
            # max_permitido es el número máximo de canciones permitidas en el periodo
            # Como el periodo y el máximo están en el mismo campo, usamos un valor razonable
            # Si max_permitido es muy grande (ej: 3600 segundos), es el periodo
            # Si es pequeño (ej: 3), es el máximo de canciones
            if max_permitido > 60:  # Probablemente es un tiempo en segundos
                # Usar un máximo razonable (ej: 3 canciones por hora)
                max_canciones_permitidas = 3
            else:
                # Es el número de canciones máximo
                max_canciones_permitidas = max_permitido
            
            return contador < max_canciones_permitidas
        else:
            # Si es "Número de Canciones" o "Número de Eventos", el periodo es el número especificado
            periodo_canciones = max_permitido
            
            # Contar canciones recientes con la misma característica
            canciones_recientes = [e for e in eventos_programados if e.get('cancion')]
            contador = 0
            for evento in canciones_recientes[-periodo_canciones:]:
                if obtener_valor_caracteristica(evento['cancion'], caracteristica) == valor_cancion:
                    contador += 1
            
            # max_permitido es el número máximo de canciones permitidas en el periodo
            return contador < max_permitido
    
    def validar_proteccion_secuencias(cancion, eventos_programados, regla_info):
        """Valida la regla de Protección de Secuencias - Evita que se generen secuencias de canciones con valores específicos"""
        regla = regla_info['regla']
        separaciones = regla_info['separaciones']
        caracteristica = regla.caracteristica
        
        valor_cancion = obtener_valor_caracteristica(cancion, caracteristica)
        
        # Obtener el valor del evento anterior (si existe)
        if not eventos_programados:
            return True  # No hay evento anterior, no hay secuencia que validar
        
        # Buscar la última canción programada
        ultimo_evento = None
        for evento in reversed(eventos_programados):
            if evento.get('cancion'):
                ultimo_evento = evento
                break
        
        if not ultimo_evento:
            return True  # No hay canción anterior
        
        valor_anterior = obtener_valor_caracteristica(ultimo_evento['cancion'], caracteristica)
        
        # Las separaciones pueden contener secuencias prohibidas
        # Formato esperado: "valor_anterior->valor_siguiente" o similar
        # Por ejemplo: "Artista A->Artista B" significa que no puede ir B después de A
        secuencia_actual = f"{valor_anterior}->{valor_cancion}"
        secuencia_inversa = f"{valor_cancion}->{valor_anterior}"
        
        # Verificar si esta secuencia está prohibida
        for key, value in separaciones.items():
            # Verificar si la clave representa una secuencia prohibida
            if '->' in key or '->' in str(value):
                secuencia_prohibida = key if '->' in key else str(value)
                if secuencia_actual.lower() == secuencia_prohibida.lower() or \
                   secuencia_inversa.lower() == secuencia_prohibida.lower():
                    return False
        
        # Si hay un valor específico en separaciones y coincide con el valor anterior,
        # y el valor actual también está en las separaciones, podría ser una secuencia prohibida
        # Por ahora, si no hay configuración específica, permitir la secuencia
        return True
    
    def validar_proteccion_secuencias_iguales(cancion, eventos_programados, regla_info):
        """Valida la regla de Protección de Secuencias Iguales - Evita secuencias de canciones iguales según la característica"""
        regla = regla_info['regla']
        caracteristica = regla.caracteristica
        
        valor_cancion = obtener_valor_caracteristica(cancion, caracteristica)
        
        # Contar cuántas canciones consecutivas con el mismo valor hay al final
        contador = 1  # Incluir la canción actual
        for evento in reversed(eventos_programados):
            if not evento.get('cancion'):
                break
            if obtener_valor_caracteristica(evento['cancion'], caracteristica) == valor_cancion:
                contador += 1
            else:
                break
        
        # No permitir más de 2 consecutivas (secuencia igual)
        return contador <= 2
    
    def validar_proteccion_conjuntos_iguales(cancion, eventos_programados, regla_info):
        """Valida la regla de Protección de Conjuntos Iguales - Evita conjuntos de canciones iguales según la característica"""
        regla = regla_info['regla']
        separaciones = regla_info['separaciones']
        caracteristica = regla.caracteristica
        
        valor_cancion = obtener_valor_caracteristica(cancion, caracteristica)
        
        # Obtener el tamaño máximo del conjunto permitido (generalmente está en "Todos los valores" o "todos")
        max_conjunto = separaciones.get('Todos los valores') or separaciones.get('todos') or 3  # Por defecto 3
        
        # Verificar las últimas N canciones (donde N es el tamaño del conjunto)
        conjunto_actual = [cancion]
        for evento in reversed(eventos_programados[-max_conjunto:]):
            if evento.get('cancion'):
                conjunto_actual.append(evento['cancion'])
        
        # Si todas las canciones del conjunto tienen el mismo valor, es un conjunto igual prohibido
        if len(conjunto_actual) >= max_conjunto:
            valores_conjunto = [obtener_valor_caracteristica(c, caracteristica) for c in conjunto_actual]
            if len(set(valores_conjunto)) == 1:  # Todos tienen el mismo valor
                return False
        
        return True
    
    def obtener_cancion_sin_repetir(categoria_nombre, hora_actual_segundos=0):
        """Obtiene una canción sin repetir hasta agotar el pool, validando reglas"""
        if categoria_nombre not in canciones_pools:
            return None
        
        pool_info = canciones_pools[categoria_nombre]
        intentos_maximos = pool_info['total'] * 2  # Intentar el doble de veces antes de rendirse
        intentos = 0
        
        while intentos < intentos_maximos:
            # Si llegamos al final del pool, reiniciar y mezclar
            if pool_info['index'] >= pool_info['total']:
                random.shuffle(pool_info['pool'])
                pool_info['index'] = 0
            
            # Obtener la siguiente canción
            cancion = pool_info['pool'][pool_info['index']]
            pool_info['index'] += 1
            intentos += 1
            
            # Validar todas las reglas
            cumple_todas_las_reglas = True
            
            for regla_id, regla_info in reglas_con_separaciones.items():
                regla = regla_info['regla']
                
                if regla.tipo_regla == 'Separación Mínima':
                    if not validar_separacion_minima(cancion, eventos_programados, regla_info, hora_actual_segundos):
                        cumple_todas_las_reglas = False
                        break
                elif regla.tipo_regla == 'Máximo de Canciones en Hilera':
                    if not validar_maximo_en_hilera(cancion, eventos_programados, regla_info):
                        cumple_todas_las_reglas = False
                        break
                elif regla.tipo_regla == 'Protección de Días Anteriores':
                    if not validar_proteccion_dias_anteriores(cancion, eventos_programados, regla_info, fecha, db, hora_actual_segundos):
                        cumple_todas_las_reglas = False
                        break
                elif regla.tipo_regla == 'Máxima Diferencia Permitida':
                    if not validar_maxima_diferencia_permitida(cancion, eventos_programados, regla_info):
                        cumple_todas_las_reglas = False
                        break
                elif regla.tipo_regla == 'Mínima Diferencia Permitida':
                    if not validar_minima_diferencia_permitida(cancion, eventos_programados, regla_info):
                        cumple_todas_las_reglas = False
                        break
                elif regla.tipo_regla == 'Canciones máximas en un periodo':
                    if not validar_maximas_en_periodo(cancion, eventos_programados, regla_info, hora_actual_segundos):
                        cumple_todas_las_reglas = False
                        break
                elif regla.tipo_regla == 'Protección de Secuencias':
                    if not validar_proteccion_secuencias(cancion, eventos_programados, regla_info):
                        cumple_todas_las_reglas = False
                        break
                elif regla.tipo_regla == 'Protección de Secuencias Iguales':
                    if not validar_proteccion_secuencias_iguales(cancion, eventos_programados, regla_info):
                        cumple_todas_las_reglas = False
                        break
                elif regla.tipo_regla == 'Protección de Conjuntos Iguales':
                    if not validar_proteccion_conjuntos_iguales(cancion, eventos_programados, regla_info):
                        cumple_todas_las_reglas = False
                        break
            
            if cumple_todas_las_reglas:
                return cancion
        
        # Si no encontramos ninguna canción que cumpla las reglas, devolver la primera disponible

        pool_info['index'] = 0
        return pool_info['pool'][0]
    
    # Ordenar relojes por su clave (R00, R01, ..., R23)
    relojes_ordenados = sorted(relojes, key=lambda r: r.clave)
    
    # Variable para rastrear el tiempo real de finalización del reloj anterior
    tiempo_fin_reloj_anterior = 0
    
    # Variable para llevar registro de la última canción entre relojes (para procesar ETM entre relojes)
    ultima_cancion_entre_relojes = None
    ultima_cancion_tiempo_inicio_global = None
    ultima_cancion_duracion_original_global = None
    
    # Función auxiliar para obtener offset en segundos
    def get_offset_seconds(offset_str):
        try:
            parts = offset_str.split(':')
            if len(parts) == 3:
                return int(parts[0]) * 3600 + int(parts[1]) * 60 + int(parts[2])
            return 0
        except:
            return 0
    
    for idx, reloj in enumerate(relojes_ordenados):
        # Cada reloj debe comenzar en su hora programada (00:00, 01:00, 02:00, etc.)
        hora_programada_reloj = idx * 3600  # 0, 3600, 7200, ... segundos
        
        # Obtener eventos del reloj ANTES de establecer tiempo_inicio_segundos
        # para poder verificar si hay un ETM al inicio que corte la canción anterior
        eventos_reloj_raw = db.query(EventoRelojModel).filter(
            EventoRelojModel.reloj_id == reloj.id
        ).all()
        
        # Ordenar eventos por offset_value (tiempo en el reloj)
        def get_offset_seconds(offset_str):
            try:
                parts = offset_str.split(':')
                if len(parts) == 3:
                    return int(parts[0]) * 3600 + int(parts[1]) * 60 + int(parts[2])
                return 0
            except:
                return 0
        
        eventos_reloj = sorted(eventos_reloj_raw, key=lambda e: get_offset_seconds(e.offset_value or '00:00:00'))
        
        # Verificar PRIMERO si el primer evento es un ETM con "cortar" al inicio del reloj (offset 00:00:00)
        # Si es así, el reloj DEBE empezar exactamente en su hora programada, ignorando el fin del reloj anterior
        tiene_etm_cortar_inicio = False
        if eventos_reloj:  # Verificar para todos los relojes, no solo idx > 0
            primer_evento = eventos_reloj[0]
            offset_primer_evento = get_offset_seconds(primer_evento.offset_value or '00:00:00')
            es_etm_inicio = (primer_evento.categoria == 'ETM' or primer_evento.tipo == 'ETM' or primer_evento.tipo == '6')
            accion_etm_inicio = primer_evento.tipo_etm if primer_evento.tipo_etm else None
            
            # Si es ETM al inicio y tiene acción "cortar", o si es ETM al inicio sin acción definida (asumir cortar por defecto)
            if es_etm_inicio and offset_primer_evento == 0:
                # Normalizar la acción para comparación (case-insensitive, sin espacios)
                accion_normalizada = accion_etm_inicio.lower().strip() if accion_etm_inicio else None
                if accion_normalizada in ['cortar', 'cortar cancion', 'cortar canción', 'cortar cancíon', 'fadeout']:
                    tiene_etm_cortar_inicio = True

                elif accion_etm_inicio is None or accion_etm_inicio == '':
                    # Si no hay acción definida, asumir "cortar" por defecto para ETM al inicio
                    tiene_etm_cortar_inicio = True

        
        # Establecer tiempo_inicio_segundos según si hay ETM que corta o no
        if tiene_etm_cortar_inicio:
            # Si hay ETM "cortar" al inicio, el reloj DEBE empezar exactamente en su hora programada
            tiempo_inicio_segundos = hora_programada_reloj

        else:
            # Si no hay ETM que corte, ajustar según el fin del reloj anterior
            tiempo_inicio_segundos = max(hora_programada_reloj, tiempo_fin_reloj_anterior)
        
        # El tiempo disponible es 1 hora desde el inicio real del reloj
        tiempo_disponible_segundos = 3600  # 1 hora por reloj
        
        # Log para debugging
        hora_inicio_hhmmss = f"{tiempo_inicio_segundos//3600:02d}:{(tiempo_inicio_segundos%3600)//60:02d}:{tiempo_inicio_segundos%60:02d}"

        
        if not eventos_reloj:
            # Si no hay eventos configurados, llenar con canciones aleatorias
            eventos_reloj = []

        
        # Ahora procesar el ETM al inicio y cortar la canción anterior si es necesario
        if tiene_etm_cortar_inicio:
            # Hay un ETM "cortar" al inicio del reloj, cortar la última canción del reloj anterior

            if ultima_cancion_entre_relojes and ultima_cancion_tiempo_inicio_global:
                tiempo_etm_segundos = hora_programada_reloj  # Exactamente en la hora programada
                tiempo_transcurrido = tiempo_etm_segundos - ultima_cancion_tiempo_inicio_global
                
                # Obtener la duración ORIGINAL de la canción (antes de cualquier corte)
                # Si no tenemos la original guardada, intentar calcularla desde la canción seleccionada
                duracion_original_real = ultima_cancion_duracion_original_global
                if duracion_original_real == 0:
                    # Si no tenemos la original, usar la duración actual como fallback
                    duracion_actual = convertir_duracion_a_segundos(ultima_cancion_entre_relojes.duracion_real or '00:00:00')
                    if duracion_actual > 0:
                        duracion_original_real = duracion_actual

                

                
                if tiempo_transcurrido > 0:
                    # FORZAR el corte: SIEMPRE cortar la canción en el tiempo del ETM
                    # El ETM "cortar" fuerza el corte en su hora programada, sin importar si la canción ya debería haber terminado
                    nueva_duracion_segundos = tiempo_transcurrido
                    
                    # Asegurar que no sea mayor que la duración original
                    if nueva_duracion_segundos > duracion_original_real:
                        nueva_duracion_segundos = duracion_original_real
                    
                    dur_horas = nueva_duracion_segundos // 3600
                    dur_minutos = (nueva_duracion_segundos % 3600) // 60
                    dur_segundos = nueva_duracion_segundos % 60
                    nueva_duracion_str = f"{dur_horas:02d}:{dur_minutos:02d}:{dur_segundos:02d}"
                    
                    # FORZAR la actualización de la entrada anterior EN LA BASE DE DATOS
                    ultima_cancion_entre_relojes.duracion_real = nueva_duracion_str
                    ultima_cancion_entre_relojes.duracion_planeada = nueva_duracion_str
                    db.add(ultima_cancion_entre_relojes)  # Asegurar que se guarde en la DB
                    db.flush()  # Forzar el flush inmediato para asegurar que los cambios se reflejen
                
                # Asegurar que tiempo_inicio_segundos esté en la hora programada (ya debería estar así)
                tiempo_inicio_segundos = hora_programada_reloj
                tiempo_fin_reloj_anterior = hora_programada_reloj

            else:
                # No hay canción anterior

                tiempo_inicio_segundos = hora_programada_reloj
                tiempo_fin_reloj_anterior = hora_programada_reloj
        
        # Generar eventos hasta llenar el tiempo disponible (1 hora exacta)
        # NO forzar 60 minutos si no hay tiempo suficiente
        tiempo_usado = 0
        hora_actual_segundos = tiempo_inicio_segundos
        evento_idx = 0
        
        # Variable para llevar registro del último evento de canción (para procesar ETM)
        ultima_cancion_entry = None
        ultima_cancion_tiempo_inicio = None
        ultima_cancion_duracion_original = None
        
        # Variable para rastrear si el evento anterior fue un ETM "cortar" al inicio
        evento_anterior_etm_cortar_inicio = False
        
        # Generar solo los eventos configurados en el reloj

        for evento_idx, evento in enumerate(eventos_reloj):

            duracion_evento_segundos = convertir_duracion_a_segundos(evento.duracion)
            tipo_evento = evento.tipo
            categoria_evento = evento.categoria
            accion_etm = evento.tipo_etm if evento.tipo_etm else None  # Acción ETM (cortar, fadeout, espera)
            
            # Verificar si este evento es un ETM y procesar la acción
            es_etm = categoria_evento == 'ETM' or tipo_evento == 'ETM' or tipo_evento == '6'
            
            # Calcular el tiempo absoluto del evento usando su offset_value
            offset_evento_segundos = get_offset_seconds(evento.offset_value or '00:00:00')
            


            
            # Inicializar tiempo_evento_absoluto por defecto
            tiempo_evento_absoluto = tiempo_inicio_segundos + offset_evento_segundos
            
            # Si es ETM "cortar" al inicio (offset 0, primer evento), 
            # FORZAR que use la hora programada del reloj, ignorando cualquier ajuste anterior
            # IMPORTANTE: Usar tiene_etm_cortar_inicio como condición principal ya que verifica correctamente
            accion_etm_normalizada = accion_etm.lower().strip() if accion_etm else None
            if es_etm and offset_evento_segundos == 0 and evento_idx == 0 and tiene_etm_cortar_inicio:
                # FORZAR tiempo_inicio_segundos a la hora programada del reloj ANTES de calcular tiempo_evento_absoluto
                tiempo_inicio_segundos = hora_programada_reloj
                # Para ETM al inicio, el tiempo absoluto es exactamente la hora programada (offset = 0)
                tiempo_evento_absoluto = hora_programada_reloj  # offset_evento_segundos = 0, así que no se suma

            elif es_etm and offset_evento_segundos == 0 and evento_idx == 0 and accion_etm_normalizada in ['cortar', 'cortar cancion', 'cortar canción', 'cortar cancíon', 'fadeout']:
                # Fallback: si accion_etm está definida pero tiene_etm_cortar_inicio no se activó

                tiempo_inicio_segundos = hora_programada_reloj
                tiempo_evento_absoluto = hora_programada_reloj

            # Inicializar cancion_seleccionada como None (se establece solo para eventos normales)
            cancion_seleccionada = None
            categoria_nombre = None
            
            # Procesar ETM con acción "cortar canción"
            accion_etm_procesar = accion_etm.lower().strip() if accion_etm else None
            if es_etm and accion_etm_procesar in ['cortar', 'cortar cancion', 'cortar canción', 'cortar cancíon', 'fadeout']:
                # Asegurar que no hay canción seleccionada para ETM
                cancion_seleccionada = None
                
                # Si hay una canción anterior en este reloj, cortarla
                if ultima_cancion_entry and ultima_cancion_tiempo_inicio:
                    tiempo_etm_segundos = tiempo_evento_absoluto
                    tiempo_transcurrido = tiempo_etm_segundos - ultima_cancion_tiempo_inicio
                    if tiempo_transcurrido > 0 and tiempo_transcurrido < ultima_cancion_duracion_original:
                        # Ajustar la duración de la canción anterior
                        nueva_duracion_segundos = tiempo_transcurrido
                        dur_horas = nueva_duracion_segundos // 3600
                        dur_minutos = (nueva_duracion_segundos % 3600) // 60
                        dur_segundos = nueva_duracion_segundos % 60
                        nueva_duracion_str = f"{dur_horas:02d}:{dur_minutos:02d}:{dur_segundos:02d}"
                        
                        # Actualizar la entrada anterior
                        ultima_cancion_entry.duracion_real = nueva_duracion_str
                        ultima_cancion_entry.duracion_planeada = nueva_duracion_str
                        


                
                # Si es ETM al inicio del reloj (offset 0), también cortar la última canción del reloj anterior
                # ESTO ES REDUNDANTE si ya se procesó arriba, pero por si acaso lo verificamos de nuevo
                if offset_evento_segundos == 0 and idx > 0 and ultima_cancion_entre_relojes and ultima_cancion_tiempo_inicio_global:
                    # Ya se procesó arriba en la sección "tiene_etm_cortar_inicio", pero verificamos aquí también
                    # para asegurar que la canción esté cortada
                    tiempo_etm_segundos = hora_programada_reloj
                    tiempo_transcurrido = tiempo_etm_segundos - ultima_cancion_tiempo_inicio_global
                    if tiempo_transcurrido > 0:
                        # SIEMPRE cortar si el ETM está después del inicio de la canción
                        # No importa si la canción ya debería haber terminado - el ETM fuerza el corte
                        nueva_duracion_segundos = min(tiempo_transcurrido, ultima_cancion_duracion_original_global)
                        if nueva_duracion_segundos != convertir_duracion_a_segundos(ultima_cancion_entre_relojes.duracion_real or '00:00:00'):
                            dur_horas = nueva_duracion_segundos // 3600
                            dur_minutos = (nueva_duracion_segundos % 3600) // 60
                            dur_segundos = nueva_duracion_segundos % 60
                            nueva_duracion_str = f"{dur_horas:02d}:{dur_minutos:02d}:{dur_segundos:02d}"
                            
                            # Actualizar la entrada anterior
                            ultima_cancion_entre_relojes.duracion_real = nueva_duracion_str
                            ultima_cancion_entre_relojes.duracion_planeada = nueva_duracion_str
                            db.add(ultima_cancion_entre_relojes)  # Asegurar que se guarde
                            


                
                # Para ETM "cortar", no avanzar tiempo (su duración es 0)
                # La siguiente canción debe empezar inmediatamente después del ETM
                duracion_evento_segundos = 0
                # Actualizar tiempo_usado para que la siguiente canción empiece en el tiempo del ETM
                tiempo_usado = offset_evento_segundos
                # Marcar que este fue un ETM "cortar" al inicio para el siguiente evento
                evento_anterior_etm_cortar_inicio = (offset_evento_segundos == 0)
            elif es_etm and accion_etm_procesar in ['espera', 'esperar']:
                # Asegurar que no hay canción seleccionada para ETM
                cancion_seleccionada = None
                
                # ETM con acción "espera": la canción anterior termina completamente
                if ultima_cancion_entry and ultima_cancion_tiempo_inicio:
                    # Esperar: la canción anterior termina completamente, el siguiente evento empieza después
                    tiempo_usado = ultima_cancion_tiempo_inicio - tiempo_inicio_segundos + ultima_cancion_duracion_original
                    hora_actual_segundos = tiempo_inicio_segundos + tiempo_usado


                
                # Para ETM "espera", no avanzar tiempo (su duración es 0)
                duracion_evento_segundos = 0
                # Resetear el flag ya que este ETM no es de tipo "cortar" al inicio
                evento_anterior_etm_cortar_inicio = False
            elif es_etm:
                # Asegurar que no hay canción seleccionada para ETM
                cancion_seleccionada = None
                # ETM sin acción específica
                duracion_evento_segundos = 0
                # Resetear el flag ya que este ETM no es de tipo "cortar" al inicio
                evento_anterior_etm_cortar_inicio = False
            else:
                # Procesar evento normal
                # Si el evento excede el tiempo disponible, cortarlo
                tiempo_restante = tiempo_disponible_segundos - tiempo_usado
                if duracion_evento_segundos > tiempo_restante:
                    duracion_evento_segundos = tiempo_restante
                    if duracion_evento_segundos <= 0:

                        continue  # Continuar con el siguiente evento en lugar de romper el bucle
                
                # Seleccionar canción sin repetir de la categoría específica del evento
                cancion_seleccionada = None
                categoria_nombre = None
                if tipo_evento == 'cancion' or tipo_evento == '1':
                    # Usar la categoría específica del evento (descripción del evento)
                    categoria_nombre = evento.descripcion if evento_idx < len(eventos_reloj) else "Rock"
                    
                    # Verificar que la categoría esté disponible en las categorías de la política
                    if categoria_nombre in canciones_por_categoria:
                        # Obtener canción sin repetir del pool de esa categoría específica, validando reglas
                        # Calcular tiempo para reglas: usar tiempo_evento_absoluto si está disponible
                        tiempo_para_reglas = tiempo_evento_absoluto
                        cancion_seleccionada = obtener_cancion_sin_repetir(categoria_nombre, tiempo_para_reglas)
                        
                        # Usar la duración real de la canción si está disponible
                        if cancion_seleccionada and cancion_seleccionada.duracion:
                            duracion_evento_segundos = cancion_seleccionada.duracion
                    else:
                        # Si la categoría no está disponible, usar una aleatoria como fallback
                        categoria_nombre = random.choice(list(canciones_por_categoria.keys()))
                        tiempo_para_reglas = tiempo_evento_absoluto
                        cancion_seleccionada = obtener_cancion_sin_repetir(categoria_nombre, tiempo_para_reglas)
                        if cancion_seleccionada and cancion_seleccionada.duracion:
                            duracion_evento_segundos = cancion_seleccionada.duracion
                    
                    # Guardar información de la canción para posible procesamiento de ETM
                    ultima_cancion_duracion_original = duracion_evento_segundos
                    # Usar el offset del evento o tiempo_usado acumulado, el que sea mayor
                    ultima_cancion_tiempo_inicio = max(tiempo_evento_absoluto, tiempo_inicio_segundos + tiempo_usado)
            
            # Calcular hora real del evento
            # Para ETM con offset 0 al inicio del reloj con acción "cortar", usar SIEMPRE la hora programada del reloj
            # Para otros ETM, usar su offset_value (hora programada del reloj + offset)
            # Para eventos normales después de ETM "cortar", empezar inmediatamente en el tiempo del ETM
            if es_etm:
                # Si es ETM al inicio (offset 0) con acción "cortar", debe estar EXACTAMENTE a la hora programada del reloj
                # NO importa si hay atraso del reloj anterior - el ETM siempre empieza a su hora
                # IMPORTANTE: Usar hora_programada_reloj directamente, NO tiempo_inicio_segundos ni tiempo_evento_absoluto
                accion_etm_normalizada_hora = accion_etm.lower().strip() if accion_etm else None
                if offset_evento_segundos == 0 and (tiene_etm_cortar_inicio or accion_etm_normalizada_hora in ['cortar', 'cortar cancion', 'cortar canción', 'cortar cancíon', 'fadeout'] or accion_etm is None) and evento_idx == 0:
                    # ETM al inicio del reloj: FORZAR hora programada del reloj DIRECTAMENTE
                    # Esto asegura que siempre aparezca a las 01:00:00, 02:00:00, etc., sin importar atrasos
                    # El offset es 0, así que hora_real = hora_programada directamente (sin sumar offset)
                    hora_real_segundos = hora_programada_reloj  # offset_evento_segundos = 0, así que no se suma
                    # Asegurar que tiempo_inicio_segundos también esté en la hora programada para eventos siguientes
                    tiempo_inicio_segundos = hora_programada_reloj

                elif offset_evento_segundos == 0 and accion_etm_normalizada_hora in ['cortar', 'cortar cancion', 'cortar canción', 'cortar cancíon', 'fadeout']:
                    # ETM "cortar" en otro momento del reloj: usar tiempo absoluto
                    hora_real_segundos = tiempo_evento_absoluto
                else:
                    # Otros ETM: usar tiempo absoluto (hora programada + offset del evento)
                    hora_real_segundos = tiempo_evento_absoluto
            else:
                # Para eventos normales después de un ETM "cortar", la canción debe empezar inmediatamente
                # en el tiempo donde está el ETM. Si tiempo_usado fue ajustado por un ETM, usar ese tiempo.
                if offset_evento_segundos > 0:
                    # Si el evento tiene un offset específico, usar ese offset desde el inicio del reloj
                    # Si el evento anterior fue un ETM "cortar" al inicio, usar hora_programada como base
                    if evento_anterior_etm_cortar_inicio and evento_idx == 1:
                        # Primer evento después de ETM "cortar" al inicio: usar hora_programada + offset
                        hora_real_segundos = hora_programada_reloj + offset_evento_segundos
                    else:
                        # Otros eventos con offset: usar tiempo_inicio_segundos + offset
                        hora_real_segundos = tiempo_inicio_segundos + offset_evento_segundos
                else:
                    # Si no tiene offset, empezar donde terminó el evento anterior
                    # Si el evento anterior fue un ETM "cortar" al inicio, empezar inmediatamente en hora_programada
                    if evento_anterior_etm_cortar_inicio and evento_idx == 1:
                        # Primer evento después de ETM "cortar" al inicio: empezar exactamente a la hora programada del reloj
                        hora_real_segundos = hora_programada_reloj
                    else:
                        # Otros eventos: empezar donde terminó el anterior o en su offset, el que sea mayor
                        tiempo_fin_anterior = tiempo_inicio_segundos + tiempo_usado
                        hora_real_segundos = max(tiempo_evento_absoluto, tiempo_fin_anterior)
            
            hora_real_horas = hora_real_segundos // 3600
            hora_real_minutos = (hora_real_segundos % 3600) // 60
            hora_real_seg = hora_real_segundos % 60
            
            # Convertir duración a formato HH:MM:SS
            dur_horas = duracion_evento_segundos // 3600
            dur_minutos = (duracion_evento_segundos % 3600) // 60
            dur_segundos = duracion_evento_segundos % 60
            duracion_str = f"{dur_horas:02d}:{dur_minutos:02d}:{dur_segundos:02d}"
            
            # Obtener la categoría de la canción seleccionada o del evento
            if es_etm:
                categoria_nombre = categoria_evento  # Para ETM, usar la categoría del evento ('ETM')
            elif cancion_seleccionada:
                categoria_nombre = categoria_nombre
            else:
                categoria_nombre = categoria_evento if evento_idx < len(eventos_reloj) else "Sin categoría"
            
            # Calcular la descripción del evento
            if cancion_seleccionada:
                descripcion_evento = cancion_seleccionada.titulo
            elif es_etm:
                # Para ETM (guillotina), mostrar la acción específica
                accion_etm_desc = accion_etm.lower().strip() if accion_etm else None
                if accion_etm_desc in ['cortar', 'cortar cancion', 'cortar canción', 'cortar cancíon']:
                    descripcion_evento = "Guillotina"
                elif accion_etm_desc == 'fadeout':
                    descripcion_evento = "Fadeout"
                elif accion_etm_desc in ['espera', 'esperar']:
                    descripcion_evento = "Esperar a terminar"
                else:
                    descripcion_evento = "Guillotina"  # Por defecto para ETM
            else:
                descripcion_evento = evento.descripcion if evento_idx < len(eventos_reloj) and evento.descripcion else f"Evento {evento_idx + 1}"
            
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
                descripcion=descripcion_evento,
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
                evento_reloj_id=eventos_reloj[evento_idx].id if evento_idx < len(eventos_reloj) else None,
                dia_modelo_id=dia_modelo_id
            )
            
            db.add(programacion_entry)
            eventos_generados.append(programacion_entry)
            
            # Agregar a eventos_programados para validación de reglas
            eventos_programados.append({
                'cancion': cancion_seleccionada,
                'tiempo_inicio_segundos': hora_real_segundos,
                'categoria': categoria_nombre,
                'programacion_entry': programacion_entry
            })
            
            # Log para depuración de eventos generados
            if evento_idx == 0 or es_etm:
                hora_log = f"{hora_real_horas:02d}:{hora_real_minutos:02d}:{hora_real_seg:02d}"

            
            # Guardar referencia a la última canción para procesamiento de ETM
            if cancion_seleccionada:
                ultima_cancion_entry = programacion_entry
            elif not es_etm:
                # Si no es ETM ni canción, resetear la referencia
                ultima_cancion_entry = None
            
            # Avanzar tiempo: actualizar tiempo_usado al final del evento actual
            if es_etm:
                # Para ETM, tiempo_usado ya fue establecido arriba según la acción
                # tiempo_usado ya está en offset_evento_segundos para "cortar" y ajustado para "espera"
                # Solo asegurar que esté correctamente establecido para casos no manejados arriba
                accion_etm_avanzar = accion_etm.lower().strip() if accion_etm else None
                if accion_etm_avanzar not in ['cortar', 'cortar cancion', 'cortar canción', 'cortar cancíon', 'fadeout', 'espera', 'esperar']:
                    # ETM sin acción específica, mantener tiempo_usado en el offset
                    tiempo_usado = offset_evento_segundos
                hora_actual_segundos = tiempo_inicio_segundos + tiempo_usado
            else:
                # Para eventos normales, avanzar según su duración desde hora_real_segundos
                # Si el evento anterior fue un ETM "cortar", hora_real_segundos ya está en el tiempo del ETM
                tiempo_usado = (hora_real_segundos - tiempo_inicio_segundos) + duracion_evento_segundos
                hora_actual_segundos = tiempo_inicio_segundos + tiempo_usado
                # Resetear el flag ya que este no es un ETM
                evento_anterior_etm_cortar_inicio = False
        
        # Actualizar registro global de la última canción para el siguiente reloj
        if ultima_cancion_entry:
            ultima_cancion_entre_relojes = ultima_cancion_entry
            # Calcular el tiempo absoluto de inicio de la última canción (desde inicio del día)
            if ultima_cancion_entry.hora_real:
                ultima_cancion_tiempo_inicio_global = (
                    ultima_cancion_entry.hora_real.hour * 3600 + 
                    ultima_cancion_entry.hora_real.minute * 60 + 
                    ultima_cancion_entry.hora_real.second
                )
            else:
                ultima_cancion_tiempo_inicio_global = ultima_cancion_tiempo_inicio if ultima_cancion_tiempo_inicio else (tiempo_inicio_segundos + tiempo_usado)
            
            # Calcular la duración ORIGINAL (antes de cualquier corte) de la última canción
            # Esto es importante para que el ETM del siguiente reloj pueda calcular correctamente cuánto cortar
            if ultima_cancion_duracion_original:
                # Usar la duración original que se guardó cuando se seleccionó la canción
                ultima_cancion_duracion_original_global = ultima_cancion_duracion_original
            elif ultima_cancion_entry.duracion_real:
                # Si no tenemos la original, usar la actual (puede estar cortada)
                ultima_cancion_duracion_original_global = convertir_duracion_a_segundos(ultima_cancion_entry.duracion_real)
            else:
                ultima_cancion_duracion_original_global = 0
            

        
        # Calcular tiempo_fin_reloj_anterior inicialmente basado en donde terminó el reloj
        tiempo_fin_reloj_anterior = tiempo_inicio_segundos + tiempo_usado
        
        # ANTES de terminar este reloj, verificar si el siguiente reloj tiene ETM "cortar" al inicio
        # Si es así, cortar la canción anterior AHORA y ajustar tiempo_fin_reloj_anterior
        if idx < len(relojes_ordenados) - 1:  # No es el último reloj
            siguiente_reloj = relojes_ordenados[idx + 1]
            siguiente_hora_programada = (idx + 1) * 3600
            eventos_siguiente_reloj_raw = db.query(EventoRelojModel).filter(
                EventoRelojModel.reloj_id == siguiente_reloj.id
            ).all()
            eventos_siguiente_reloj = sorted(eventos_siguiente_reloj_raw, key=lambda e: get_offset_seconds(e.offset_value or '00:00:00'))
            
            if eventos_siguiente_reloj and ultima_cancion_entre_relojes and ultima_cancion_tiempo_inicio_global:
                primer_evento_siguiente = eventos_siguiente_reloj[0]
                offset_primer_siguiente = get_offset_seconds(primer_evento_siguiente.offset_value or '00:00:00')
                es_etm_siguiente = (primer_evento_siguiente.categoria == 'ETM' or primer_evento_siguiente.tipo == 'ETM' or primer_evento_siguiente.tipo == '6')
                accion_etm_siguiente = primer_evento_siguiente.tipo_etm if primer_evento_siguiente.tipo_etm else None
                
                # Si el siguiente reloj tiene ETM "cortar" al inicio, cortar la canción AHORA
                accion_etm_siguiente_norm = accion_etm_siguiente.lower().strip() if accion_etm_siguiente else None
                if es_etm_siguiente and offset_primer_siguiente == 0 and (accion_etm_siguiente_norm in ['cortar', 'cortar cancion', 'cortar canción', 'cortar cancíon', 'fadeout'] or accion_etm_siguiente is None):
                    tiempo_corte = siguiente_hora_programada
                    tiempo_transcurrido = tiempo_corte - ultima_cancion_tiempo_inicio_global
                    
                    # Obtener duración original
                    duracion_original = ultima_cancion_duracion_original_global
                    if duracion_original == 0:
                        duracion_actual = convertir_duracion_a_segundos(ultima_cancion_entre_relojes.duracion_real or '00:00:00')
                        if duracion_actual > 0:
                            duracion_original = duracion_actual
                    

                    
                    if tiempo_transcurrido > 0 and tiempo_transcurrido <= duracion_original:
                        # Cortar la canción al tiempo del siguiente reloj
                        nueva_duracion_segundos = tiempo_transcurrido
                        dur_horas = nueva_duracion_segundos // 3600
                        dur_minutos = (nueva_duracion_segundos % 3600) // 60
                        dur_segundos = nueva_duracion_segundos % 60
                        nueva_duracion_str = f"{dur_horas:02d}:{dur_minutos:02d}:{dur_segundos:02d}"
                        
                        # Actualizar la canción
                        ultima_cancion_entre_relojes.duracion_real = nueva_duracion_str
                        ultima_cancion_entre_relojes.duracion_planeada = nueva_duracion_str
                        db.add(ultima_cancion_entre_relojes)
                        db.flush()
                        
                        # AJUSTAR tiempo_fin_reloj_anterior para que el siguiente reloj empiece en su hora programada
                        tiempo_fin_reloj_anterior = siguiente_hora_programada
                        


        
        # Log de eventos generados para este reloj
        eventos_del_reloj = [e for e in eventos_generados if e.reloj_id == reloj.id]

        
        # Log para debugging
        hora_fin_hhmmss = f"{tiempo_fin_reloj_anterior//3600:02d}:{(tiempo_fin_reloj_anterior%3600)//60:02d}:{tiempo_fin_reloj_anterior%60:02d}"
        hora_programada_hhmmss = f"{hora_programada_reloj//3600:02d}:{(hora_programada_reloj%3600)//60:02d}:{hora_programada_reloj%60:02d}"

    
    # Guardar en la base de datos

    db.commit()

    
    # Verificar cuántos eventos se guardaron realmente
    eventos_guardados = db.query(ProgramacionModel).filter(
        ProgramacionModel.difusora == difusora,
        ProgramacionModel.politica_id == politica_id,
        ProgramacionModel.fecha == fecha.date()
    ).count()

    
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
            
            # Inicializar con status por defecto
            status = "Sin Configuración"
            tiene_programacion = False
            dia_modelo_nombre = ""
            programacion_count = 0
            
            # Solo verificar programación existente si se proporciona política
            if politica_id:
                # Verificar si existe programación para este día
                programacion_existente = db.query(ProgramacionModel).filter(
                    ProgramacionModel.difusora == difusora,
                    ProgramacionModel.fecha == fecha_actual.date(),
                    ProgramacionModel.politica_id == politica_id
                )
                
                programacion_count = programacion_existente.count()

                
                # Solo asignar "Con Programación" si realmente existe programación
                if programacion_count > 0:
                    status = "Con Programación"
                    tiene_programacion = True
                    
                    # Buscar día modelo usado en la programación existente


                    dia_modelo = db.query(DiaModeloModel).join(
                        ProgramacionModel,
                        DiaModeloModel.id == ProgramacionModel.dia_modelo_id
                    ).filter(
                        ProgramacionModel.difusora == difusora,
                        ProgramacionModel.fecha == fecha_actual.date(),
                        ProgramacionModel.politica_id == politica_id
                    ).first()
                    
                    if dia_modelo:
                        dia_modelo_nombre = dia_modelo.nombre


                    else:

                        # Si no se encuentra el día modelo almacenado, usar el método anterior como fallback
                        dia_modelo = db.query(DiaModeloModel).filter(
                            DiaModeloModel.politica_id == politica_id,
                            DiaModeloModel.difusora == difusora,
                            DiaModeloModel.habilitado == True,
                            getattr(DiaModeloModel, dia_semana_espanol) == True
                        ).first()
                        
                        if dia_modelo:
                            dia_modelo_nombre = dia_modelo.nombre

                else:
                    # Si no hay programación, usar el día modelo por defecto de la política
                    status = "Sin Configuración"
                    tiene_programacion = False
                    
                    # Buscar el día modelo por defecto de la política para este día de la semana
                    from app.models.programacion import PoliticaProgramacion as PoliticaProgramacionModel
                    politica = db.query(PoliticaProgramacionModel).filter(
                        PoliticaProgramacionModel.id == politica_id
                    ).first()
                    
                    if politica:
                        # Obtener el día modelo por defecto para este día de la semana
                        dia_modelo_id = getattr(politica, dia_semana_espanol, None)
                        if dia_modelo_id:
                            dia_modelo_default = db.query(DiaModeloModel).filter(
                                DiaModeloModel.id == dia_modelo_id
                            ).first()
                            if dia_modelo_default:
                                dia_modelo_nombre = dia_modelo_default.nombre


                            else:
                                dia_modelo_nombre = ""

                        else:
                            dia_modelo_nombre = ""

                    else:
                        dia_modelo_nombre = ""

            
            # Nombres de días en español
            dias_espanol = {
                'Monday': 'Lunes', 'Tuesday': 'Martes', 'Wednesday': 'Miércoles',
                'Thursday': 'Jueves', 'Friday': 'Viernes', 'Saturday': 'Sábado', 'Sunday': 'Domingo'
            }
            dia_ingles = fecha_actual.strftime("%A")
            dia_nombre = dias_espanol.get(dia_ingles, dia_ingles)
            
            dia_data = {
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
            }

            dias.append(dia_data)
            
            fecha_actual += timedelta(days=1)
        
        return {
            "dias": dias,
            "total_dias": len(dias)
        }
        
    except ValueError as e:
        raise HTTPException(status_code=400, detail=f"Formato de fecha inválido: {str(e)}")
    except Exception as e:

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
        
        # Obtener todos los registros de programación para este día con join a Reloj
        programacion = db.query(ProgramacionModel, RelojModel).join(
            RelojModel, ProgramacionModel.reloj_id == RelojModel.id, isouter=True
        ).filter(
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
        
        # Generar números secuenciales de reloj basados en reloj_id único
        # Primero, obtener todos los relojes únicos ordenados por primera aparición
        relojes_unicos = {}
        relojes_orden = []
        nnumero_reloj_contador = 1
        
        for prog, reloj in programacion:
            reloj_id = prog.reloj_id if prog.reloj_id else None
            if reloj_id and reloj_id not in relojes_unicos:
                relojes_unicos[reloj_id] = nnumero_reloj_contador
                relojes_orden.append(reloj_id)
                nnumero_reloj_contador += 1
        
        # Formatear respuesta
        eventos = []
        for prog, reloj in programacion:
            reloj_id = prog.reloj_id if prog.reloj_id else None
            nnumero_reloj = relojes_unicos.get(reloj_id, 0) if reloj_id else 0
            clave_reloj = reloj.clave if reloj else (prog.numero_reloj if prog.numero_reloj else "")
            
            eventos.append({
                "id": prog.id,
                "mc": prog.mc,
                "nnumero_reloj": nnumero_reloj,  # Número secuencial (1, 2, 3...)
                "clave_reloj": clave_reloj,  # Clave/Nombre del reloj
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

        raise HTTPException(status_code=500, detail="Error interno del servidor")


@router.delete("/eliminar-programacion")
async def eliminar_programacion(
    difusora: str = Query(..., description="Nombre de la difusora"),
    politica_id: int = Query(..., description="ID de la política"),
    fecha: str = Query(..., description="Fecha en formato YYYY-MM-DD"),
    db: Session = Depends(get_db)
):
    """
    Eliminar programación para una fecha específica
    """
    try:

        
        # Buscar la programación a eliminar
        programacion = db.query(ProgramacionModel).filter(
            ProgramacionModel.difusora == difusora,
            ProgramacionModel.politica_id == politica_id,
            ProgramacionModel.fecha == fecha
        ).all()
        
        if not programacion or len(programacion) == 0:
            raise HTTPException(status_code=404, detail="No se encontró programación para eliminar")
        
        # Eliminar todas las entradas de programación
        for entrada in programacion:
            db.delete(entrada)
        db.commit()
        

        return {"message": "Programación eliminada exitosamente"}
        
    except HTTPException:
        raise
    except Exception as e:

        raise HTTPException(status_code=500, detail="Error interno del servidor")


@router.get("/carta-tiempo")
async def generar_carta_tiempo(
    difusora: str = Query(..., description="Nombre de la difusora"),
    politica_id: int = Query(..., description="ID de la política"),
    fecha: str = Query(..., description="Fecha en formato YYYY-MM-DD"),
    db: Session = Depends(get_db)
):
    """
    Generar carta de tiempo para una fecha específica
    """
    try:

        
        # Buscar la programación
        programacion = db.query(ProgramacionModel).filter(
            ProgramacionModel.difusora == difusora,
            ProgramacionModel.politica_id == politica_id,
            ProgramacionModel.fecha == fecha
        ).first()
        
        if not programacion:
            raise HTTPException(status_code=404, detail="No se encontró programación para la fecha especificada")
        
        # Generar carta de tiempo (formato simplificado)
        carta_tiempo = {
            "difusora": difusora,
            "politica_id": politica_id,
            "fecha": fecha,
            "programacion": programacion.programacion if programacion.programacion else [],
            "total_eventos": len(programacion.programacion) if programacion.programacion else 0
        }
        
        return carta_tiempo
        
    except HTTPException:
        raise
    except Exception as e:

        raise HTTPException(status_code=500, detail="Error interno del servidor")


@router.put("/programacion/{programacion_id}/cancion")
async def actualizar_cancion_programacion(
    programacion_id: int,
    cancion_id: int = Query(..., description="ID de la nueva canción"),
    db: Session = Depends(get_db)
):
    """
    Actualizar la canción asignada a una entrada de programación
    """
    try:

        
        # Buscar la entrada de programación
        programacion_entry = db.query(ProgramacionModel).filter(
            ProgramacionModel.id == programacion_id
        ).first()
        
        if not programacion_entry:
            raise HTTPException(status_code=404, detail="Entrada de programación no encontrada")
        
        # Buscar la nueva canción
        cancion = db.query(CancionModel).filter(CancionModel.id == cancion_id).first()
        
        if not cancion:
            raise HTTPException(status_code=404, detail="Canción no encontrada")
        
        # Actualizar los campos de la programación con los datos de la nueva canción
        programacion_entry.id_media = str(cancion.id)
        programacion_entry.descripcion = cancion.titulo
        programacion_entry.interprete = cancion.artista
        programacion_entry.disco = cancion.album
        
        # Actualizar duración si está disponible
        if cancion.duracion:
            horas = cancion.duracion // 3600
            minutos = (cancion.duracion % 3600) // 60
            segundos = cancion.duracion % 60
            programacion_entry.duracion_real = f"{horas:02d}:{minutos:02d}:{segundos:02d}"
            programacion_entry.duracion_planeada = f"{horas:02d}:{minutos:02d}:{segundos:02d}"
        
        # Marcar como que tiene canción asignada
        programacion_entry.mc = True
        
        # Guardar cambios
        db.commit()
        db.refresh(programacion_entry)
        

        
        return {
            "id": programacion_entry.id,
            "id_media": programacion_entry.id_media,
            "descripcion": programacion_entry.descripcion,
            "interprete": programacion_entry.interprete,
            "disco": programacion_entry.disco,
            "duracion_real": programacion_entry.duracion_real,
            "mensaje": "Canción actualizada exitosamente"
        }
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()

        raise HTTPException(status_code=500, detail=f"Error interno del servidor: {str(e)}")


