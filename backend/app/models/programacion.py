from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, Text, Time, Date, Index, func
from sqlalchemy.orm import relationship
from app.core.database import Base

# ============================================================================
# MODELOS DE PROGRAMACIÓN
# ============================================================================

class PoliticaProgramacion(Base):
    __tablename__ = "politicas_programacion"
    
    id = Column(Integer, primary_key=True, index=True)
    clave = Column(String(50), unique=True, nullable=False, index=True)
    difusora = Column(String(10), nullable=False, index=True)
    nombre = Column(String(200), nullable=False)
    descripcion = Column(Text)
    habilitada = Column(Boolean, default=True)
    guid = Column(String(50), unique=True)
    categorias_seleccionadas = Column(Text, comment="IDs de categorías separados por comas")
    # Días modelo por defecto para cada día de la semana (IDs de dias_modelo)
    lunes = Column(Integer, ForeignKey("dias_modelo.id"), nullable=True)
    martes = Column(Integer, ForeignKey("dias_modelo.id"), nullable=True)
    miercoles = Column(Integer, ForeignKey("dias_modelo.id"), nullable=True)
    jueves = Column(Integer, ForeignKey("dias_modelo.id"), nullable=True)
    viernes = Column(Integer, ForeignKey("dias_modelo.id"), nullable=True)
    sabado = Column(Integer, ForeignKey("dias_modelo.id"), nullable=True)
    domingo = Column(Integer, ForeignKey("dias_modelo.id"), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    
    # Relaciones
    relojes = relationship("Reloj", back_populates="politica", cascade="all, delete-orphan")
    dias_modelo = relationship("DiaModelo", back_populates="politica", cascade="all, delete-orphan", foreign_keys="DiaModelo.politica_id")

class Reloj(Base):
    __tablename__ = "relojes"
    
    id = Column(Integer, primary_key=True, index=True)
    clave = Column(String(50), unique=True, nullable=False, index=True)
    nombre = Column(String(100), nullable=False)
    duracion = Column(String(10), nullable=False)  # HH:MM:SS
    numero_eventos = Column(Integer, default=0)
    habilitado = Column(Boolean, default=True)
    politica_id = Column(Integer, ForeignKey("politicas_programacion.id", ondelete="CASCADE"))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relaciones
    politica = relationship("PoliticaProgramacion", back_populates="relojes")
    eventos = relationship("EventoReloj", back_populates="reloj", cascade="all, delete-orphan")
    relojes_dia_modelo = relationship("RelojDiaModelo", back_populates="reloj", cascade="all, delete-orphan")

class EventoReloj(Base):
    __tablename__ = "eventos_reloj"
    
    id = Column(Integer, primary_key=True, index=True)
    reloj_id = Column(Integer, ForeignKey("relojes.id", ondelete="CASCADE"))
    numero = Column(String(10), nullable=False)
    offset_value = Column(String(10), default="00:00:00")
    desde_etm = Column(String(10), default="00:00:00")
    desde_corte = Column(String(10), default="00:00:00")
    offset_final = Column(String(10), default="00:00:00")
    tipo = Column(String(20), nullable=False)
    categoria = Column(String(50), nullable=False)
    descripcion = Column(String(200))
    duracion = Column(String(10), default="00:00:00")
    numero_cancion = Column(String(10), default="-")
    sin_categorias = Column(String(10), default="-")
    id_media = Column(String(50))
    categoria_media = Column(String(50))
    tipo_etm = Column(String(20))
    comando_das = Column(String(100))
    caracteristica = Column(String(50))
    twofer_valor = Column(String(50))
    todas_categorias = Column(Boolean, default=True)
    categorias_usar = Column(Text)
    grupos_reglas_ignorar = Column(Text)
    clasificaciones_evento = Column(Text)
    caracteristica_especifica = Column(String(50))
    valor_deseado = Column(String(50))
    usar_todas_categorias = Column(Boolean, default=True)
    categorias_usar_especifica = Column(Text)
    grupos_reglas_ignorar_especifica = Column(Text)
    clasificaciones_evento_especifica = Column(Text)
    orden = Column(Integer, default=0)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relaciones
    reloj = relationship("Reloj", back_populates="eventos")

class DiaModelo(Base):
    __tablename__ = "dias_modelo"
    
    id = Column(Integer, primary_key=True, index=True)
    habilitado = Column(Boolean, default=True)
    difusora = Column(String(10), nullable=False, index=True)
    politica_id = Column(Integer, ForeignKey("politicas_programacion.id", ondelete="CASCADE"))
    clave = Column(String(50), nullable=False)
    nombre = Column(String(200), nullable=False)
    descripcion = Column(Text)
    lunes = Column(Boolean, default=False)
    martes = Column(Boolean, default=False)
    miercoles = Column(Boolean, default=False)
    jueves = Column(Boolean, default=False)
    viernes = Column(Boolean, default=False)
    sabado = Column(Boolean, default=False)
    domingo = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relaciones
    politica = relationship("PoliticaProgramacion", back_populates="dias_modelo", foreign_keys="DiaModelo.politica_id")
    relojes_dia_modelo = relationship("RelojDiaModelo", back_populates="dia_modelo", cascade="all, delete-orphan")

class RelojDiaModelo(Base):
    __tablename__ = "relojes_dia_modelo"
    
    id = Column(Integer, primary_key=True, index=True)
    dia_modelo_id = Column(Integer, ForeignKey("dias_modelo.id", ondelete="CASCADE"))
    reloj_id = Column(Integer, ForeignKey("relojes.id", ondelete="CASCADE"))
    orden = Column(Integer, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relaciones
    dia_modelo = relationship("DiaModelo", back_populates="relojes_dia_modelo")
    reloj = relationship("Reloj", back_populates="relojes_dia_modelo")

class SetRegla(Base):
    __tablename__ = "sets_reglas"
    
    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100), nullable=False)
    descripcion = Column(Text)
    habilitado = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    
    # Relaciones
    reglas = relationship("Regla", back_populates="set_regla", cascade="all, delete-orphan")

class Regla(Base):
    __tablename__ = "reglas"
    
    id = Column(Integer, primary_key=True, index=True)
    set_regla_id = Column(Integer, ForeignKey("sets_reglas.id", ondelete="CASCADE"))
    nombre = Column(String(100), nullable=False)
    descripcion = Column(Text)
    tipo = Column(String(50), nullable=False)
    valor = Column(String(200))
    habilitado = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    
    # Relaciones
    set_regla = relationship("SetRegla", back_populates="reglas")

class Programacion(Base):
    __tablename__ = "programacion"
    
    id = Column(Integer, primary_key=True, index=True)
    mc = Column(Boolean, default=False, comment="Si se pudo agregar la canción")
    numero_reloj = Column(String(10), nullable=False, comment="Número del reloj")
    hora_real = Column(Time, comment="Hora real de transmisión")
    hora_transmision = Column(Time, comment="Hora de transmisión")
    duracion_real = Column(String(10), comment="Duración real (HH:MM:SS)")
    tipo = Column(String(20), nullable=False, comment="Tipo de evento")
    hora_planeada = Column(Time, comment="Hora planeada")
    duracion_planeada = Column(String(10), comment="Duración planeada (HH:MM:SS)")
    categoria = Column(String(50), nullable=False, comment="Categoría del evento")
    id_media = Column(String(50), comment="ID del media")
    descripcion = Column(String(200), comment="Descripción del evento")
    lenguaje = Column(String(20), comment="Idioma")
    interprete = Column(String(100), comment="Intérprete/Artista")
    disco = Column(String(100), comment="Disco/Álbum")
    sello_discografico = Column(String(100), comment="Sello discográfico")
    bpm = Column(Integer, comment="Beats per minute")
    año = Column(Integer, comment="Año de lanzamiento")
    
    # Relaciones
    difusora = Column(String(10), nullable=False, comment="Difusora")
    politica_id = Column(Integer, ForeignKey("politicas_programacion.id", ondelete="CASCADE"))
    fecha = Column(Date, nullable=False, comment="Fecha de programación")
    reloj_id = Column(Integer, ForeignKey("relojes.id", ondelete="CASCADE"))
    evento_reloj_id = Column(Integer, ForeignKey("eventos_reloj.id", ondelete="CASCADE"))
    dia_modelo_id = Column(Integer, ForeignKey("dias_modelo.id", ondelete="CASCADE"), comment="Día modelo usado para generar la programación")
    
    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    
    # Índices
    __table_args__ = (
        Index('ix_programacion_fecha_difusora', 'fecha', 'difusora'),
        Index('ix_programacion_reloj', 'reloj_id'),
        Index('ix_programacion_politica', 'politica_id'),
    )