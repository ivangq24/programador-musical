from sqlalchemy import Column, Integer, String, DateTime, Boolean, Text, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.core.database import Base

# General Models
class Difusora(Base):
    __tablename__ = "difusoras"
    
    id = Column(Integer, primary_key=True, index=True)
    siglas = Column(String(50), nullable=False, unique=True)
    nombre = Column(String(200), nullable=False)
    slogan = Column(String(500))
    orden = Column(Integer, default=1)
    mascara_medidas = Column(String(20), default="MM:SS")
    descripcion = Column(Text)
    activa = Column(Boolean, default=True)
    organizacion_id = Column(Integer, ForeignKey("organizaciones.id", ondelete="CASCADE"), nullable=False, index=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relaciones
    organizacion = relationship("Organizacion", back_populates="difusoras")
    # Relación con usuarios (definida en auth.py para evitar import circular)


