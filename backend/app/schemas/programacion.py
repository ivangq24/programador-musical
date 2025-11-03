from pydantic import BaseModel
from typing import Optional, List, Dict, Any
from datetime import datetime, time, date

# Schema para días modelo seleccionados
class DiaModeloSeleccionado(BaseModel):
    fecha: str
    dia_modelo: str

class GenerarProgramacionRequest(BaseModel):
    dias_modelo: List[DiaModeloSeleccionado]

# Base schemas
class PoliticaProgramacionBase(BaseModel):
    clave: str
    difusora: str
    nombre: str
    descripcion: Optional[str] = None
    habilitada: bool = True
    guid: Optional[str] = None
    # Días modelo por defecto para cada día de la semana
    lunes: Optional[int] = None
    martes: Optional[int] = None
    miercoles: Optional[int] = None
    jueves: Optional[int] = None
    viernes: Optional[int] = None
    sabado: Optional[int] = None
    domingo: Optional[int] = None

class PoliticaProgramacionCreate(PoliticaProgramacionBase):
    pass

class PoliticaProgramacionUpdate(BaseModel):
    clave: Optional[str] = None
    difusora: Optional[str] = None
    nombre: Optional[str] = None
    descripcion: Optional[str] = None
    habilitada: Optional[bool] = None
    guid: Optional[str] = None
    # Días modelo por defecto para cada día de la semana
    lunes: Optional[int] = None
    martes: Optional[int] = None
    miercoles: Optional[int] = None
    jueves: Optional[int] = None
    viernes: Optional[int] = None
    sabado: Optional[int] = None
    domingo: Optional[int] = None

class PoliticaProgramacion(PoliticaProgramacionBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True

# Reloj schemas
class RelojBase(BaseModel):
    habilitado: bool = True
    clave: str
    nombre: str
    numero_eventos: int = 0
    duracion: str = '00:00:00'
    politica_id: int

class RelojCreate(BaseModel):
    habilitado: bool = True
    clave: str
    nombre: str
    numero_eventos: int = 0
    duracion: str = '00:00:00'

class RelojUpdate(BaseModel):
    habilitado: Optional[bool] = None
    clave: Optional[str] = None
    nombre: Optional[str] = None
    numero_eventos: Optional[int] = None
    duracion: Optional[str] = None
    politica_id: Optional[int] = None

class Reloj(RelojBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True

# Evento Reloj schemas
class EventoRelojBase(BaseModel):
    reloj_id: int
    numero: str
    offset_value: str = '00:00:00'
    desde_etm: str = '00:00:00'
    desde_corte: str = '00:00:00'
    offset_final: str = '00:00:00'
    tipo: str
    categoria: str
    descripcion: Optional[str] = None
    duracion: str = '00:00:00'
    numero_cancion: str = '-'
    sin_categorias: str = '-'
    # Campos específicos
    id_media: Optional[str] = None
    categoria_media: Optional[str] = None
    tipo_etm: Optional[str] = None
    comando_das: Optional[str] = None
    caracteristica: Optional[str] = None
    twofer_valor: Optional[str] = None
    todas_categorias: bool = True
    categorias_usar: Optional[str] = None
    grupos_reglas_ignorar: Optional[str] = None
    clasificaciones_evento: Optional[str] = None
    caracteristica_especifica: Optional[str] = None
    valor_deseado: Optional[str] = None
    usar_todas_categorias: bool = True
    categorias_usar_especifica: Optional[str] = None
    grupos_reglas_ignorar_especifica: Optional[str] = None
    clasificaciones_evento_especifica: Optional[str] = None
    orden: int = 0

class EventoRelojCreate(BaseModel):
    numero: str
    offset_value: str = '00:00:00'
    desde_etm: str = '00:00:00'
    desde_corte: str = '00:00:00'
    offset_final: str = '00:00:00'
    tipo: str
    categoria: str
    descripcion: Optional[str] = None
    duracion: str = '00:00:00'
    numero_cancion: str = '-'
    sin_categorias: str = '-'
    # Campos específicos
    id_media: Optional[str] = None
    categoria_media: Optional[str] = None
    tipo_etm: Optional[str] = None
    comando_das: Optional[str] = None
    caracteristica: Optional[str] = None
    twofer_valor: Optional[str] = None
    todas_categorias: bool = True
    categorias_usar: Optional[str] = None
    grupos_reglas_ignorar: Optional[str] = None
    clasificaciones_evento: Optional[str] = None
    caracteristica_especifica: Optional[str] = None
    valor_deseado: Optional[str] = None
    usar_todas_categorias: bool = True
    categorias_usar_especifica: Optional[str] = None
    grupos_reglas_ignorar_especifica: Optional[str] = None
    clasificaciones_evento_especifica: Optional[str] = None
    orden: int = 0

class EventoRelojUpdate(BaseModel):
    reloj_id: Optional[int] = None
    numero: Optional[str] = None
    offset_value: Optional[str] = None
    desde_etm: Optional[str] = None
    desde_corte: Optional[str] = None
    offset_final: Optional[str] = None
    tipo: Optional[str] = None
    categoria: Optional[str] = None
    descripcion: Optional[str] = None
    duracion: Optional[str] = None
    numero_cancion: Optional[str] = None
    sin_categorias: Optional[str] = None
    id_media: Optional[str] = None
    categoria_media: Optional[str] = None
    tipo_etm: Optional[str] = None
    comando_das: Optional[str] = None
    caracteristica: Optional[str] = None
    twofer_valor: Optional[str] = None
    todas_categorias: Optional[bool] = None
    categorias_usar: Optional[str] = None
    grupos_reglas_ignorar: Optional[str] = None
    clasificaciones_evento: Optional[str] = None
    caracteristica_especifica: Optional[str] = None
    valor_deseado: Optional[str] = None
    usar_todas_categorias: Optional[bool] = None
    categorias_usar_especifica: Optional[str] = None
    grupos_reglas_ignorar_especifica: Optional[str] = None
    clasificaciones_evento_especifica: Optional[str] = None
    orden: Optional[int] = None

class EventoReloj(EventoRelojBase):
    id: int
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True

# Día Modelo schemas
class DiaModeloBase(BaseModel):
    habilitado: bool = True
    difusora: str
    politica_id: int
    clave: str
    nombre: str
    descripcion: Optional[str] = None
    lunes: bool = False
    martes: bool = False
    miercoles: bool = False
    jueves: bool = False
    viernes: bool = False
    sabado: bool = False
    domingo: bool = False

class DiaModeloCreate(BaseModel):
    habilitado: bool = True
    difusora: str
    clave: str
    nombre: str
    descripcion: Optional[str] = None
    lunes: bool = False
    martes: bool = False
    miercoles: bool = False
    jueves: bool = False
    viernes: bool = False
    sabado: bool = False
    domingo: bool = False
    relojes: Optional[List[int]] = None

class DiaModeloUpdate(BaseModel):
    habilitado: Optional[bool] = None
    difusora: Optional[str] = None
    politica_id: Optional[int] = None
    clave: Optional[str] = None
    nombre: Optional[str] = None
    descripcion: Optional[str] = None
    lunes: Optional[bool] = None
    martes: Optional[bool] = None
    miercoles: Optional[bool] = None
    jueves: Optional[bool] = None
    viernes: Optional[bool] = None
    sabado: Optional[bool] = None
    domingo: Optional[bool] = None
    relojes: Optional[List[int]] = None

class DiaModelo(DiaModeloBase):
    id: int
    created_at: datetime
    relojes: Optional[List[Reloj]] = None

    class Config:
        from_attributes = True

# Reloj Día Modelo schemas
class RelojDiaModeloBase(BaseModel):
    dia_modelo_id: int
    reloj_id: int
    orden: int = 0

class RelojDiaModeloCreate(RelojDiaModeloBase):
    pass

class RelojDiaModeloUpdate(BaseModel):
    dia_modelo_id: Optional[int] = None
    reloj_id: Optional[int] = None
    orden: Optional[int] = None

class RelojDiaModelo(RelojDiaModeloBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True


# Orden Asignación schemas
class OrdenAsignacionBase(BaseModel):
    politica_id: int
    nombre: str
    descripcion: Optional[str] = None
    tipo: str
    parametros: Optional[Dict[str, Any]] = None
    habilitado: bool = True
    orden: int = 0

class OrdenAsignacionCreate(OrdenAsignacionBase):
    pass

class OrdenAsignacionUpdate(BaseModel):
    politica_id: Optional[int] = None
    nombre: Optional[str] = None
    descripcion: Optional[str] = None
    tipo: Optional[str] = None
    parametros: Optional[Dict[str, Any]] = None
    habilitado: Optional[bool] = None
    orden: Optional[int] = None

class OrdenAsignacion(OrdenAsignacionBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True

# Schemas con relaciones
class RelojConEventos(Reloj):
    eventos: List[EventoReloj] = []

class PoliticaCompleta(PoliticaProgramacion):
    relojes: List[RelojConEventos] = []
    dias_modelo: List[DiaModelo] = []
    orden_asignacion: List[OrdenAsignacion] = []

class DiaModeloConRelojes(DiaModelo):
    relojes_relacion: List[RelojDiaModelo] = []


# Schemas para estadísticas
class PoliticasStats(BaseModel):
    total: int
    habilitadas: int
    deshabilitadas: int
    por_difusora: Dict[str, int]

class RelojesStats(BaseModel):
    total: int
    habilitados: int
    deshabilitados: int
    con_eventos: int
    sin_eventos: int
    por_politica: Dict[str, int]

# Schemas para Programación
class ProgramacionBase(BaseModel):
    mc: bool = False
    numero_reloj: str
    hora_real: Optional[time] = None
    hora_transmision: Optional[time] = None
    duracion_real: Optional[str] = None
    tipo: str
    hora_planeada: Optional[time] = None
    duracion_planeada: Optional[str] = None
    categoria: str
    id_media: Optional[str] = None
    descripcion: Optional[str] = None
    lenguaje: Optional[str] = None
    interprete: Optional[str] = None
    disco: Optional[str] = None
    sello_discografico: Optional[str] = None
    bpm: Optional[int] = None
    año: Optional[int] = None
    difusora: str
    politica_id: Optional[int] = None
    fecha: date
    reloj_id: Optional[int] = None
    evento_reloj_id: Optional[int] = None

class ProgramacionCreate(ProgramacionBase):
    pass

class ProgramacionUpdate(BaseModel):
    mc: Optional[bool] = None
    numero_reloj: Optional[str] = None
    hora_real: Optional[time] = None
    hora_transmision: Optional[time] = None
    duracion_real: Optional[str] = None
    tipo: Optional[str] = None
    hora_planeada: Optional[time] = None
    duracion_planeada: Optional[str] = None
    categoria: Optional[str] = None
    id_media: Optional[str] = None
    descripcion: Optional[str] = None
    lenguaje: Optional[str] = None
    interprete: Optional[str] = None
    disco: Optional[str] = None
    sello_discografico: Optional[str] = None
    bpm: Optional[int] = None
    año: Optional[int] = None
    difusora: Optional[str] = None
    politica_id: Optional[int] = None
    fecha: Optional[date] = None
    reloj_id: Optional[int] = None
    evento_reloj_id: Optional[int] = None

class Programacion(ProgramacionBase):
    id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class ProgramacionStats(BaseModel):
    total: int
    por_difusora: Dict[str, int]
    por_fecha: Dict[str, int]
    por_tipo: Dict[str, int]
    por_categoria: Dict[str, int]
    mc_completados: int
    mc_pendientes: int


# Reglas schemas
class SeparacionReglaBase(BaseModel):
    valor: str
    separacion: int

class SeparacionReglaCreate(SeparacionReglaBase):
    pass

class SeparacionReglaUpdate(BaseModel):
    valor: Optional[str] = None
    separacion: Optional[int] = None

class SeparacionRegla(SeparacionReglaBase):
    id: int
    regla_id: int
    created_at: datetime

    class Config:
        from_attributes = True

class ReglaBase(BaseModel):
    politica_id: int
    tipo_regla: str
    caracteristica: str
    tipo_separacion: str
    descripcion: Optional[str] = None
    horario: bool = False
    solo_verificar_dia: bool = False
    habilitada: bool = True

class ReglaCreate(ReglaBase):
    separaciones: List[SeparacionReglaCreate] = []

class ReglaUpdate(BaseModel):
    tipo_regla: Optional[str] = None
    caracteristica: Optional[str] = None
    tipo_separacion: Optional[str] = None
    descripcion: Optional[str] = None
    horario: Optional[bool] = None
    solo_verificar_dia: Optional[bool] = None
    habilitada: Optional[bool] = None
    separaciones: Optional[List[SeparacionReglaCreate]] = None

class Regla(ReglaBase):
    id: int
    separaciones: List[SeparacionRegla] = []
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class ReglaConSeparaciones(Regla):
    separaciones: List[SeparacionRegla] = []

    class Config:
        from_attributes = True

