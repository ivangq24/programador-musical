#!/usr/bin/env python3
"""
Script para inicializar la base de datos en AWS RDS
Crea todas las tablas y carga datos iniciales
"""
import sys
from sqlalchemy import create_engine
from app.core.database import Base
from app.core.config import settings

# Importar todos los modelos para que SQLAlchemy los registre
from app.models import (
    Usuario, UsuarioDifusora, Difusora,
    Categoria, Cancion,
    PoliticaProgramacion, Reloj, EventoReloj, DiaModelo,
    Regla, SeparacionRegla, Programacion,
    Corte
)

def init_database():
    """Crear todas las tablas en la base de datos"""
    print(f"Conectando a: {settings.database_url}")
    
    try:
        engine = create_engine(settings.database_url)
        
        print("Creando tablas...")
        Base.metadata.create_all(bind=engine)
        
        print("✅ Tablas creadas exitosamente!")
        return True
        
    except Exception as e:
        print(f"❌ Error al crear tablas: {e}")
        return False

if __name__ == "__main__":
    success = init_database()
    sys.exit(0 if success else 1)
