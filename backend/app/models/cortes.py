from sqlalchemy import Column, Integer, String, Boolean, DateTime, Text, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.core.database import Base


class Corte(Base):
    __tablename__ = "cortes"

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(255), nullable=False, index=True)
    descripcion = Column(Text, nullable=True)
    duracion = Column(String(8), nullable=False)  # Formato HH:MM:SS
    tipo = Column(String(20), nullable=False, default='comercial')  # 'comercial' o 'vacio'
    activo = Column(Boolean, default=True, nullable=False)
    observaciones = Column(Text, nullable=True)
    organizacion_id = Column(Integer, ForeignKey("organizaciones.id", ondelete="CASCADE"), nullable=False, index=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relación con organización
    organizacion = relationship("Organizacion")
