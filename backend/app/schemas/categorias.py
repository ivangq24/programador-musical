from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

# Categoría schemas
class CategoriaBase(BaseModel):
    difusora: Optional[str] = None
    clave: Optional[str] = None
    nombre: str
    descripcion: Optional[str] = None
    activa: bool = True

class CategoriaCreate(CategoriaBase):
    pass

class CategoriaUpdate(BaseModel):
    difusora: Optional[str] = None
    clave: Optional[str] = None
    nombre: Optional[str] = None
    descripcion: Optional[str] = None
    activa: Optional[bool] = None

class Categoria(CategoriaBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True

# Canción schemas
class CancionBase(BaseModel):
    titulo: str
    artista: str
    album: Optional[str] = None
    duracion: Optional[int] = None
    categoria_id: Optional[int] = None
    activa: bool = True

class CancionCreate(CancionBase):
    pass

class CancionUpdate(BaseModel):
    titulo: Optional[str] = None
    artista: Optional[str] = None
    album: Optional[str] = None
    duracion: Optional[int] = None
    categoria_id: Optional[int] = None
    activa: Optional[bool] = None

class Cancion(CancionBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True

# (Eliminados schemas de Conjunto)
