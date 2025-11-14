from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, UniqueConstraint
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.core.database import Base


class Organizacion(Base):
    """Modelo de organización para multi-tenancy"""
    __tablename__ = "organizaciones"
    
    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(255), nullable=False)
    nombre_empresa = Column(String(255), nullable=True, comment="Nombre de la empresa/organización")
    telefono = Column(String(50), nullable=True, comment="Teléfono de contacto")
    direccion = Column(String(500), nullable=True, comment="Dirección")
    ciudad = Column(String(100), nullable=True, comment="Ciudad")
    activa = Column(Boolean, default=True, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relaciones
    usuarios = relationship("Usuario", back_populates="organizacion")
    difusoras = relationship("Difusora", back_populates="organizacion")


class Usuario(Base):
    """Modelo de usuario sincronizado con AWS Cognito"""
    __tablename__ = "usuarios"
    
    id = Column(Integer, primary_key=True, index=True)
    cognito_user_id = Column(String(255), unique=True, nullable=False, index=True, comment="ID del usuario en Cognito (sub)")
    email = Column(String(255), unique=True, nullable=False, index=True)
    nombre = Column(String(255), nullable=False)
    rol = Column(String(50), nullable=False, comment="admin, manager, operador")
    activo = Column(Boolean, default=True, nullable=False)
    # Campos adicionales para administrador (deprecated, usar organizacion.nombre_empresa)
    nombre_empresa = Column(String(255), nullable=True, comment="Nombre de la empresa/organización (deprecated)")
    telefono = Column(String(50), nullable=True, comment="Teléfono de contacto (deprecated)")
    direccion = Column(String(500), nullable=True, comment="Dirección (deprecated)")
    ciudad = Column(String(100), nullable=True, comment="Ciudad (deprecated)")
    organizacion_id = Column(Integer, ForeignKey("organizaciones.id", ondelete="CASCADE"), nullable=False, index=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relaciones
    organizacion = relationship("Organizacion", back_populates="usuarios")
    difusoras = relationship(
        "UsuarioDifusora",
        back_populates="usuario",
        cascade="all, delete-orphan"
    )


class UsuarioDifusora(Base):
    """Tabla de asignación de difusoras a usuarios"""
    __tablename__ = "usuario_difusoras"
    
    id = Column(Integer, primary_key=True, index=True)
    usuario_id = Column(Integer, ForeignKey("usuarios.id", ondelete="CASCADE"), nullable=False, index=True)
    difusora_id = Column(Integer, ForeignKey("difusoras.id", ondelete="CASCADE"), nullable=False, index=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relaciones
    usuario = relationship("Usuario", back_populates="difusoras")
    difusora = relationship("Difusora", lazy="joined")
    
    __table_args__ = (
        UniqueConstraint('usuario_id', 'difusora_id', name='uq_usuario_difusora'),
    )

