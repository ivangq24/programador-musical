from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

# Base schemas
class DifusoraBase(BaseModel):
    siglas: str
    nombre: str
    slogan: Optional[str] = None
    orden: int = 1
    mascara_medidas: str = "MM:SS"
    descripcion: Optional[str] = None
    activa: bool = True

class DifusoraCreate(DifusoraBase):
    pass

class DifusoraUpdate(BaseModel):
    siglas: Optional[str] = None
    nombre: Optional[str] = None
    slogan: Optional[str] = None
    orden: Optional[int] = None
    mascara_medidas: Optional[str] = None
    descripcion: Optional[str] = None
    activa: Optional[bool] = None

class Difusora(DifusoraBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True

# Tipo Clasificación schemas
class TipoClasificacionBase(BaseModel):
    nombre: str
    descripcion: Optional[str] = None
    activo: bool = True

class TipoClasificacionCreate(TipoClasificacionBase):
    pass

class TipoClasificacionUpdate(TipoClasificacionBase):
    nombre: Optional[str] = None
    activo: Optional[bool] = None

class TipoClasificacion(TipoClasificacionBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True

# Clasificación schemas
class ClasificacionBase(BaseModel):
    nombre: str
    tipo_id: Optional[int] = None
    descripcion: Optional[str] = None
    activa: bool = True

class ClasificacionCreate(ClasificacionBase):
    pass

class ClasificacionUpdate(ClasificacionBase):
    nombre: Optional[str] = None
    activa: Optional[bool] = None

class Clasificacion(ClasificacionBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True

