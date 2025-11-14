#!/usr/bin/env python3
"""
Script para verificar políticas en la base de datos
"""
import sys
import os

# Agregar el directorio raíz al path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.models.programacion import PoliticaProgramacion
from app.core.config import settings
from app.core.database import get_db

def check_politicas():
    """Verificar políticas en la base de datos"""
    # Usar la misma configuración que la aplicación
    if settings.DATABASE_URL:
        engine = create_engine(settings.DATABASE_URL)
    else:
        # Construir desde componentes individuales
        database_url = f"postgresql://{settings.DATABASE_USERNAME}:{settings.DATABASE_PASSWORD}@{settings.DATABASE_HOST}:{settings.DATABASE_PORT}/{settings.DATABASE_NAME}"
        engine = create_engine(database_url)
    
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    db = SessionLocal()
    
    try:
        # Contar total de políticas
        total = db.query(PoliticaProgramacion).count()
        print(f"Total de políticas en la BD: {total}")
        
        if total > 0:
            # Mostrar las primeras 10
            politicas = db.query(PoliticaProgramacion).limit(10).all()
            print("\nPrimeras políticas:")
            for p in politicas:
                print(f"  - ID: {p.id}, Clave: {p.clave}, Nombre: {p.nombre}, Difusora: {p.difusora}, Habilitada: {p.habilitada}")
        else:
            print("\n⚠️  No hay políticas en la base de datos")
            print("   Necesitas crear políticas usando el frontend o directamente en la BD")
        
        # Verificar difusoras
        from app.models.catalogos import Difusora
        difusoras = db.query(Difusora).filter(Difusora.activa == True).all()
        print(f"\nTotal de difusoras activas: {len(difusoras)}")
        if difusoras:
            print("Difusoras activas:")
            for d in difusoras:
                print(f"  - {d.siglas}: {d.nombre}")
        
    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()
    finally:
        db.close()

if __name__ == "__main__":
    check_politicas()

