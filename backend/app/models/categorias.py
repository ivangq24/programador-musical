from sqlalchemy import Column, Integer, String, DateTime, Boolean, Text, ForeignKey
from sqlalchemy.sql import func
from app.core.database import Base

# Categorías Models
class Categoria(Base):
    __tablename__ = "categorias"
    
    id = Column(Integer, primary_key=True, index=True)
    difusora = Column(String(10))
    clave = Column(String(50))
    nombre = Column(String(100), nullable=False)
    descripcion = Column(Text)
    activa = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

class MovimientoCategoria(Base):
    __tablename__ = "movimientos_categorias"
    
    id = Column(Integer, primary_key=True, index=True)
    categoria_origen_id = Column(Integer, ForeignKey("categorias.id"))
    categoria_destino_id = Column(Integer, ForeignKey("categorias.id"))
    fecha_movimiento = Column(DateTime(timezone=True), server_default=func.now())
    motivo = Column(Text)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

# Conjuntos Models
class Conjunto(Base):
    __tablename__ = "conjuntos"
    
    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100), nullable=False)
    descripcion = Column(Text)
    activo = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

# Canciones Models
class Cancion(Base):
    __tablename__ = "canciones"
    
    id = Column(Integer, primary_key=True, index=True)
    titulo = Column(String(200), nullable=False)
    artista = Column(String(200))
    album = Column(String(200))
    duracion = Column(Integer)  # en segundos
    categoria_id = Column(Integer, ForeignKey("categorias.id"))
    conjunto_id = Column(Integer, ForeignKey("conjuntos.id"))
    activa = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
