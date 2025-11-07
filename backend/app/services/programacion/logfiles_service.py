from sqlalchemy.orm import Session
from typing import List, Optional, Dict, Any
from datetime import date, datetime
from uuid import UUID
import uuid

from app.models.programacion import Programacion as ProgramacionModel
from app.models.catalogos import Difusora as DifusoraModel
from app.models.programacion import PoliticaProgramacion as PoliticaProgramacionModel

class LogfilesService:
    """Servicio para manejar la lógica de negocio de generación de logfiles"""
    
    def __init__(self, db: Session):
        self.db = db
    
    def generar_logfile_dia(
        self, 
        difusora: str, 
        politica_id: int, 
        fecha: str
    ) -> Dict[str, Any]:
        """
        Genera logfile para una difusora específica en una fecha
        
        Args:
            difusora: Siglas de la difusora
            politica_id: ID de la política
            fecha: Fecha en formato DD/MM/YYYY
            
        Returns:
            Diccionario con el logfile generado y metadatos
        """
        try:
            # Convertir fecha desde formato DD/MM/YYYY a objeto date
            if isinstance(fecha, str):
                day, month, year = fecha.split('/')
                fecha_obj = date(int(year), int(month), int(day))
            else:
                fecha_obj = fecha
            
            # Obtener información de la difusora
            difusora_obj = self.db.query(DifusoraModel).filter(
                DifusoraModel.siglas == difusora
            ).first()
            
            if not difusora_obj:
                raise ValueError(f"Difusora {difusora} no encontrada o está inactiva")
            
            # Obtener programación del día
            programacion = self.db.query(ProgramacionModel).filter(
                ProgramacionModel.difusora == difusora,
                ProgramacionModel.politica_id == politica_id,
                ProgramacionModel.fecha == fecha_obj
            ).order_by(ProgramacionModel.hora_transmision).all()
            
            if not programacion:
                raise ValueError(f"No hay programación para {difusora} en {fecha}")
            
            # Generar contenido del logfile
            logfile_content = self._generar_contenido_logfile(programacion, difusora_obj, fecha_obj)
            
            # Crear nombre del archivo (LOGFILE MUSICAL)
            nombre_archivo = f"LogFile_MUSICAL_{difusora}_{fecha.replace('/', '-')}.txt"
            
            # Calcular estadísticas
            total_eventos = len(programacion)
            cortes_comerciales = [p for p in programacion if p.tipo == 'corte_comercial']
            spots = [p for p in programacion if p.tipo == 'spot']
            canciones = [p for p in programacion if p.tipo == 'cancion']
            
            total_segundos = sum(
                int(p.duracion_real.split(':')[0]) * 3600 + 
                int(p.duracion_real.split(':')[1]) * 60 + 
                int(p.duracion_real.split(':')[2]) if p.duracion_real else 0 
                for p in programacion
            )
            
            return {
                "success": True,
                "message": "Logfile generado exitosamente",
                "metadata": {
                    "difusora": difusora,
                    "politica_id": politica_id,
                    "fecha": fecha,
                    "total_eventos": total_eventos,
                    "total_cortes": len(cortes_comerciales),
                    "total_spots": len(spots),
                    "total_canciones": len(canciones),
                    "total_segundos": total_segundos
                },
                "logfile": {
                    "nombre_archivo": nombre_archivo,
                    "contenido": logfile_content,
                    "tamaño_bytes": len(logfile_content.encode('utf-8'))
                }
            }
            
        except Exception as e:
            raise
    
    def _generar_contenido_logfile(self, programacion, difusora, fecha):
        """
        Genera el contenido del logfile MUSICAL con formato de carta de tiempo
        
        Args:
            programacion: Lista de eventos de programación MUSICAL
            difusora: Objeto Difusora con información de la difusora
            fecha: Fecha para la cual se genera el logfile
            
        Returns:
            String con el contenido del logfile MUSICAL (formato carta de tiempo)
        """
        from datetime import datetime
        from zoneinfo import ZoneInfo
        
        lines = []
        
        # Usar zona horaria de México (CST/CDT)
        mexico_tz = ZoneInfo('America/Mexico_City')
        fecha_actual = datetime.now(mexico_tz)
        
        # Días de la semana en español
        dias_semana = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo']
        meses = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 
                'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre']
        
        dia_semana = dias_semana[fecha.weekday()]
        mes_nombre = meses[fecha.month - 1]
        
        # Contar eventos por tipo
        canciones = [p for p in programacion if p.tipo == 'cancion']
        eventos_musicales = [p for p in programacion if p.tipo in ['cancion', 'evento_musical']]
        cortes_comerciales = [p for p in programacion if p.tipo == 'corte_comercial']
        spots = [p for p in programacion if p.tipo == 'spot']
        
        # Obtener información del primer reloj para el header
        primer_reloj = programacion[0].numero_reloj if programacion else "UNKNOWN"
        
        # Header de la carta de tiempo
        lines.append(f"XHDQ - {difusora.siglas}")
        lines.append(f"{difusora.nombre}")
        lines.append("CARTA DE TIEMPO")
        lines.append(f"{dia_semana.capitalize()}, {fecha.day} de {mes_nombre} de {fecha.year}")
        lines.append(f"Impreso: {fecha_actual.strftime('%d/%m/%Y a las %I:%M:%S %p')}")
        lines.append("")
        
        # Información del reloj
        lines.append(f"Clave Reloj: {primer_reloj}")
        lines.append(f"Eventos: {len(programacion)}")
        lines.append(f"Canciones: {len(canciones)}")
        lines.append(f"Nombre: {primer_reloj}")
        lines.append("")
        
        # Encabezados de la tabla
        lines.append("Hora,IdMedia,Título,Intérpretes,Categoría,Duración,Intro,Lenguaje,Año")
        
        # Ordenar eventos por hora de transmisión
        eventos_ordenados = sorted(programacion, key=lambda x: x.hora_transmision if x.hora_transmision else datetime.min.time())
        
        # Procesar cada evento
        for evento in eventos_ordenados:
            # Hora de transmisión
            hora = evento.hora_transmision.strftime("%H:%M:%S") if evento.hora_transmision else "00:00:00"
            
            # IdMedia
            id_media = evento.id_media or ""
            
            # Título (descripción)
            titulo = evento.descripcion or ""
            
            # Intérpretes
            interprete = evento.interprete or ""
            
            # Categoría
            categoria = evento.categoria or ""
            
            # Duración
            duracion = evento.duracion_real or "0:00:00"
            # Convertir duración a formato legible (min seg)
            try:
                if duracion and duracion != "0:00:00":
                    partes = duracion.split(':')
                    if len(partes) == 3:
                        horas, minutos, segundos = partes
                        total_minutos = int(horas) * 60 + int(minutos)
                        duracion_formato = f"{total_minutos} min {segundos} seg"
                    elif len(partes) == 2:
                        minutos, segundos = partes
                        duracion_formato = f"{minutos} min {segundos} seg"
                    else:
                        duracion_formato = duracion
                else:
                    duracion_formato = "0 min 0 seg"
            except:
                duracion_formato = duracion or "0 min 0 seg"
            
            # Intro (siempre 0s por ahora)
            intro = "0s"
            
            # Lenguaje
            lenguaje = evento.lenguaje or ""
            
            # Año
            año = str(evento.año) if evento.año else "0"
            
            # Crear línea de datos separada por comas
            linea = f"{hora},{id_media},{titulo},{interprete},{categoria},{duracion_formato},{intro},{lenguaje},{año}"
            lines.append(linea)
        
        # Agregar línea final
        lines.append("")
        lines.append(f"Total de eventos: {len(programacion)}")
        lines.append(f"Total de canciones: {len(canciones)}")
        lines.append(f"Generado el {fecha_actual.strftime('%d/%m/%Y a las %I:%M:%S %p')}")
        
        return "\n".join(lines)
    
    def validar_parametros_logfile(
        self, 
        difusora: str, 
        politica_id: int, 
        fecha: str
    ) -> Dict[str, Any]:
        """
        Valida los parámetros para la generación de logfile
        
        Returns:
            Diccionario con resultado de validación y errores si los hay
        """
        errores = []
        
        if not difusora:
            errores.append("Debe especificar la difusora")
        
        if not politica_id:
            errores.append("Debe especificar el ID de la política")
        
        if not fecha:
            errores.append("Debe especificar la fecha")
        
        if fecha:
            try:
                # Convertir fecha desde formato DD/MM/YYYY
                if isinstance(fecha, str):
                    day, month, year = fecha.split('/')
                    fecha_obj = date(int(year), int(month), int(day))
                else:
                    fecha_obj = fecha
                    
                # Validar que la fecha no sea muy futura (máximo 1 año)
                if fecha_obj > date.today().replace(year=date.today().year + 1):
                    errores.append("No se puede generar logfile para fechas muy futuras (máximo 1 año)")
                    
            except (ValueError, IndexError):
                errores.append("Formato de fecha inválido. Use DD/MM/YYYY")
        
        return {
            "es_valido": len(errores) == 0,
            "errores": errores
        }
