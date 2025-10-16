#!/usr/bin/env python3
"""
Script para agregar canciones con duraciones aleatorias entre 3 y 5 minutos
a las categorías existentes en la base de datos.
"""

import random
import sys
import os
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from sqlalchemy.exc import SQLAlchemyError

# Agregar el directorio del proyecto al path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.core.config import settings
from app.models.categorias import Categoria, Cancion

# Configuración de la base de datos - usar la misma que el API
DATABASE_URL = "postgresql://postgres:postgres@localhost:5433/programador-musical"

# Crear engine y session
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Lista de canciones de ejemplo para cada categoría
CANCIONES_POR_CATEGORIA = {
    "Pop": [
        {"titulo": "Shape of You", "artista": "Ed Sheeran", "album": "÷ (Divide)"},
        {"titulo": "Blinding Lights", "artista": "The Weeknd", "album": "After Hours"},
        {"titulo": "Levitating", "artista": "Dua Lipa", "album": "Future Nostalgia"},
        {"titulo": "Watermelon Sugar", "artista": "Harry Styles", "album": "Fine Line"},
        {"titulo": "Good 4 U", "artista": "Olivia Rodrigo", "album": "SOUR"},
        {"titulo": "Stay", "artista": "The Kid LAROI & Justin Bieber", "album": "F*CK LOVE 3"},
        {"titulo": "Industry Baby", "artista": "Lil Nas X ft. Jack Harlow", "album": "MONTERO"},
        {"titulo": "Peaches", "artista": "Justin Bieber ft. Daniel Caesar", "album": "Justice"},
        {"titulo": "Kiss Me More", "artista": "Doja Cat ft. SZA", "album": "Planet Her"},
        {"titulo": "Heat Waves", "artista": "Glass Animals", "album": "Dreamland"},
        {"titulo": "Bad Habits", "artista": "Ed Sheeran", "album": "="},
        {"titulo": "Positions", "artista": "Ariana Grande", "album": "Positions"},
        {"titulo": "Dynamite", "artista": "BTS", "album": "BE"},
        {"titulo": "Mood", "artista": "24kGoldn ft. iann dior", "album": "El Dorado"},
        {"titulo": "Save Your Tears", "artista": "The Weeknd", "album": "After Hours"}
    ],
    "Rock": [
        {"titulo": "Thunderstruck", "artista": "AC/DC", "album": "The Razors Edge"},
        {"titulo": "Sweet Child O' Mine", "artista": "Guns N' Roses", "album": "Appetite for Destruction"},
        {"titulo": "Livin' on a Prayer", "artista": "Bon Jovi", "album": "Slippery When Wet"},
        {"titulo": "Don't Stop Believin'", "artista": "Journey", "album": "Escape"},
        {"titulo": "We Will Rock You", "artista": "Queen", "album": "News of the World"},
        {"titulo": "Born to Be Wild", "artista": "Steppenwolf", "album": "Steppenwolf"},
        {"titulo": "Eye of the Tiger", "artista": "Survivor", "album": "Eye of the Tiger"},
        {"titulo": "Welcome to the Jungle", "artista": "Guns N' Roses", "album": "Appetite for Destruction"},
        {"titulo": "Paradise City", "artista": "Guns N' Roses", "album": "Appetite for Destruction"},
        {"titulo": "You Give Love a Bad Name", "artista": "Bon Jovi", "album": "Slippery When Wet"},
        {"titulo": "Pour Some Sugar on Me", "artista": "Def Leppard", "album": "Hysteria"},
        {"titulo": "Rock You Like a Hurricane", "artista": "Scorpions", "album": "Love at First Sting"},
        {"titulo": "Jump", "artista": "Van Halen", "album": "1984"},
        {"titulo": "Crazy Train", "artista": "Ozzy Osbourne", "album": "Blizzard of Ozz"},
        {"titulo": "Back in Black", "artista": "AC/DC", "album": "Back in Black"}
    ],
    "Jazz": [
        {"titulo": "Take Five", "artista": "Dave Brubeck", "album": "Time Out"},
        {"titulo": "Blue in Green", "artista": "Miles Davis", "album": "Kind of Blue"},
        {"titulo": "So What", "artista": "Miles Davis", "album": "Kind of Blue"},
        {"titulo": "All Blues", "artista": "Miles Davis", "album": "Kind of Blue"},
        {"titulo": "Autumn Leaves", "artista": "Cannonball Adderley", "album": "Somethin' Else"},
        {"titulo": "My Funny Valentine", "artista": "Chet Baker", "album": "Chet Baker Sings"},
        {"titulo": "Round Midnight", "artista": "Thelonious Monk", "album": "Genius of Modern Music"},
        {"titulo": "Blue Moon", "artista": "Billie Holiday", "album": "Blue Moon"},
        {"titulo": "Summertime", "artista": "Ella Fitzgerald", "album": "Porgy and Bess"},
        {"titulo": "In a Sentimental Mood", "artista": "Duke Ellington", "album": "Duke Ellington & John Coltrane"},
        {"titulo": "Body and Soul", "artista": "Coleman Hawkins", "album": "Body and Soul"},
        {"titulo": "Stella by Starlight", "artista": "Miles Davis", "album": "Kind of Blue"},
        {"titulo": "Giant Steps", "artista": "John Coltrane", "album": "Giant Steps"},
        {"titulo": "A Love Supreme", "artista": "John Coltrane", "album": "A Love Supreme"},
        {"titulo": "Blue Train", "artista": "John Coltrane", "album": "Blue Train"}
    ],
    "Clásica": [
        {"titulo": "Canon in D", "artista": "Johann Pachelbel", "album": "Canon and Gigue"},
        {"titulo": "Clair de Lune", "artista": "Claude Debussy", "album": "Suite Bergamasque"},
        {"titulo": "The Four Seasons - Spring", "artista": "Antonio Vivaldi", "album": "The Four Seasons"},
        {"titulo": "Für Elise", "artista": "Ludwig van Beethoven", "album": "Bagatelle No. 25"},
        {"titulo": "Moonlight Sonata", "artista": "Ludwig van Beethoven", "album": "Piano Sonata No. 14"},
        {"titulo": "Ave Maria", "artista": "Franz Schubert", "album": "Ellens dritter Gesang"},
        {"titulo": "The Blue Danube", "artista": "Johann Strauss II", "album": "The Blue Danube Waltz"},
        {"titulo": "Symphony No. 9", "artista": "Ludwig van Beethoven", "album": "Symphony No. 9 in D minor"},
        {"titulo": "The Nutcracker Suite", "artista": "Pyotr Ilyich Tchaikovsky", "album": "The Nutcracker"},
        {"titulo": "Swan Lake", "artista": "Pyotr Ilyich Tchaikovsky", "album": "Swan Lake"},
        {"titulo": "Eine kleine Nachtmusik", "artista": "Wolfgang Amadeus Mozart", "album": "Serenade No. 13"},
        {"titulo": "The Marriage of Figaro", "artista": "Wolfgang Amadeus Mozart", "album": "Le nozze di Figaro"},
        {"titulo": "Carmen Suite", "artista": "Georges Bizet", "album": "Carmen"},
        {"titulo": "Boléro", "artista": "Maurice Ravel", "album": "Boléro"},
        {"titulo": "The Planets", "artista": "Gustav Holst", "album": "The Planets, Op. 32"}
    ]
}

def generar_duracion_aleatoria():
    """
    Genera una duración aleatoria entre 3 y 5 minutos (180-300 segundos)
    """
    return random.randint(180, 300)

def obtener_categoria_por_nombre(session, nombre_categoria):
    """
    Obtiene una categoría por su nombre
    """
    try:
        categoria = session.query(Categoria).filter(
            Categoria.nombre == nombre_categoria,
            Categoria.activa == True
        ).first()
        return categoria
    except Exception as e:
        print(f"Error obteniendo categoría {nombre_categoria}: {e}")
        return None

def verificar_cancion_existente(session, titulo, artista):
    """
    Verifica si una canción ya existe en la base de datos
    """
    try:
        cancion = session.query(Cancion).filter(
            Cancion.titulo == titulo,
            Cancion.artista == artista
        ).first()
        return cancion is not None
    except Exception as e:
        print(f"Error verificando canción existente: {e}")
        return False

def agregar_cancion(session, titulo, artista, album, duracion, categoria_id):
    """
    Agrega una nueva canción a la base de datos
    """
    try:
        nueva_cancion = Cancion(
            titulo=titulo,
            artista=artista,
            album=album,
            duracion=duracion,
            categoria_id=categoria_id,
            activa=True
        )
        
        session.add(nueva_cancion)
        session.commit()
        session.refresh(nueva_cancion)
        
        return nueva_cancion
    except Exception as e:
        session.rollback()
        print(f"Error agregando canción {titulo} - {artista}: {e}")
        return None

def agregar_canciones_por_categoria(session, nombre_categoria, canciones):
    """
    Agrega canciones para una categoría específica
    """
    print(f"\n--- Procesando categoría: {nombre_categoria} ---")
    
    # Obtener la categoría
    categoria = obtener_categoria_por_nombre(session, nombre_categoria)
    if not categoria:
        print(f"❌ Categoría '{nombre_categoria}' no encontrada o inactiva")
        return 0
    
    print(f"✅ Categoría encontrada: {categoria.nombre} (ID: {categoria.id})")
    
    canciones_agregadas = 0
    canciones_omitidas = 0
    
    for cancion_data in canciones:
        titulo = cancion_data["titulo"]
        artista = cancion_data["artista"]
        album = cancion_data["album"]
        
        # Verificar si la canción ya existe
        if verificar_cancion_existente(session, titulo, artista):
            print(f"⏭️  Omitiendo: {titulo} - {artista} (ya existe)")
            canciones_omitidas += 1
            continue
        
        # Generar duración aleatoria
        duracion = generar_duracion_aleatoria()
        
        # Agregar la canción
        nueva_cancion = agregar_cancion(
            session, titulo, artista, album, duracion, categoria.id
        )
        
        if nueva_cancion:
            print(f"✅ Agregada: {titulo} - {artista} ({duracion}s)")
            canciones_agregadas += 1
        else:
            print(f"❌ Error agregando: {titulo} - {artista}")
    
    print(f"📊 Resumen {nombre_categoria}: {canciones_agregadas} agregadas, {canciones_omitidas} omitidas")
    return canciones_agregadas

def main():
    """
    Función principal del script
    """
    print("🎵 Script para agregar canciones con duraciones aleatorias")
    print("=" * 60)
    
    # Crear sesión de base de datos
    session = SessionLocal()
    
    try:
        total_agregadas = 0
        
        # Procesar cada categoría
        for nombre_categoria, canciones in CANCIONES_POR_CATEGORIA.items():
            agregadas = agregar_canciones_por_categoria(session, nombre_categoria, canciones)
            total_agregadas += agregadas
        
        print("\n" + "=" * 60)
        print(f"🎉 Proceso completado!")
        print(f"📈 Total de canciones agregadas: {total_agregadas}")
        
        # Mostrar estadísticas finales
        print("\n📊 Estadísticas por categoría:")
        for nombre_categoria in CANCIONES_POR_CATEGORIA.keys():
            categoria = obtener_categoria_por_nombre(session, nombre_categoria)
            if categoria:
                total_canciones = session.query(Cancion).filter(
                    Cancion.categoria_id == categoria.id,
                    Cancion.activa == True
                ).count()
                print(f"   {nombre_categoria}: {total_canciones} canciones")
    
    except Exception as e:
        print(f"❌ Error general: {e}")
        session.rollback()
    
    finally:
        session.close()

if __name__ == "__main__":
    main()
