from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


class CorteBase(BaseModel):
    nombre: str = Field(..., min_length=1, max_length=255, description="Nombre del corte")
    descripcion: Optional[str] = Field(None, description="Descripción del corte")
    duracion: str = Field(..., pattern=r'^\d{2}:\d{2}:\d{2}$', description="Duración en formato HH:MM:SS")
    tipo: str = Field(..., pattern=r'^(comercial|vacio)$', description="Tipo de corte: comercial o vacio")
    activo: bool = Field(True, description="Estado del corte")
    observaciones: Optional[str] = Field(None, description="Observaciones adicionales")


class CorteCreate(CorteBase):
    pass


class CorteUpdate(BaseModel):
    nombre: Optional[str] = Field(None, min_length=1, max_length=255)
    descripcion: Optional[str] = None
    duracion: Optional[str] = Field(None, pattern=r'^\d{2}:\d{2}:\d{2}$')
    tipo: Optional[str] = Field(None, pattern=r'^(comercial|vacio)$')
    activo: Optional[bool] = None
    observaciones: Optional[str] = None


class CorteInDB(CorteBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class Corte(CorteInDB):
    pass


class CorteList(BaseModel):
    cortes: list[Corte]
    total: int
    page: int
    size: int
