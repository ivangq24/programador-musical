from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from typing import List, Dict, Any
import io
import csv
from datetime import datetime

from app.core.database import get_db
from app.core.auth import get_current_user
from app.models.auth import Usuario
from app.models.catalogos import Difusora
from app.models.categorias import Categoria, Cancion

router = APIRouter()

@router.post("/validate-csv")
async def validate_csv(
    csv_data: List[Dict[str, Any]],
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user)
):
    """
    Valida los datos del CSV antes de la importación (solo difusoras de la organización del usuario)
    """
    try:
        validation_results = {
            "valid_rows": 0,
            "invalid_rows": 0,
            "errors": [],
            "warnings": []
        }
        
        # Validar cada fila
        for i, row in enumerate(csv_data):
            row_errors = []
            
            # Validar campos requeridos
            required_fields = ['titulo', 'interprete', 'difusora']
            for field in required_fields:
                if not row.get(field) or str(row.get(field)).strip() == '':
                    row_errors.append(f"Campo requerido '{field}' está vacío")
            
            # Validar que la difusora existe y pertenece a la organización del usuario
            if row.get('difusora'):
                difusora = db.query(Difusora).filter(
                    Difusora.siglas == row['difusora'],
                    Difusora.organizacion_id == usuario.organizacion_id  # ← FILTRO POR ORGANIZACIÓN
                ).first()
                if not difusora:
                    row_errors.append(f"Difusora '{row['difusora']}' no existe o no pertenece a tu organización")
            
            # Validar que la categoría existe y pertenece a una difusora de la organización del usuario
            if row.get('categoria'):
                # Primero verificar que la difusora existe y pertenece a la organización
                difusora_siglas = row.get('difusora')
                if difusora_siglas:
                    difusora = db.query(Difusora).filter(
                        Difusora.siglas == difusora_siglas,
                        Difusora.organizacion_id == usuario.organizacion_id
                    ).first()
                    if difusora:
                        categoria = db.query(Categoria).filter(
                            Categoria.nombre == row['categoria'],
                            Categoria.difusora == difusora_siglas  # La categoría debe pertenecer a la difusora
                        ).first()
                        if not categoria:
                            row_errors.append(f"Categoría '{row['categoria']}' no existe para la difusora '{difusora_siglas}'")
            
            if row_errors:
                validation_results["invalid_rows"] += 1
                validation_results["errors"].append({
                    "row": i + 1,
                    "errors": row_errors
                })
            else:
                validation_results["valid_rows"] += 1
        
        return validation_results
        
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error validando CSV: {str(e)}")

@router.post("/import-canciones")
async def import_canciones(
    csv_data: List[Dict[str, Any]],
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user)
):
    """
    Importa las canciones desde el CSV (solo difusoras de la organización del usuario)
    """
    try:
        imported_count = 0
        skipped_count = 0
        errors = []
        
        for i, row in enumerate(csv_data):
            try:
                # Verificar si la canción ya existe
                existing_cancion = db.query(Cancion).filter(
                    Cancion.titulo == row.get('titulo'),
                    Cancion.artista == row.get('interprete')
                ).first()
                
                if existing_cancion:
                    skipped_count += 1
                    continue
                
                # Obtener la difusora (solo de la organización del usuario)
                difusora = None
                if row.get('difusora'):
                    difusora = db.query(Difusora).filter(
                        Difusora.siglas == row['difusora'],
                        Difusora.organizacion_id == usuario.organizacion_id  # ← FILTRO POR ORGANIZACIÓN
                    ).first()
                    
                    if not difusora:
                        errors.append({
                            "row": i + 1,
                            "error": f"Difusora '{row['difusora']}' no existe o no pertenece a tu organización"
                        })
                        skipped_count += 1
                        continue
                
                # Obtener la categoría (debe pertenecer a la difusora de la organización)
                categoria = None
                if row.get('categoria') and difusora:
                    categoria = db.query(Categoria).filter(
                        Categoria.nombre == row['categoria'],
                        Categoria.difusora == difusora.siglas  # La categoría debe pertenecer a la difusora
                    ).first()
                
                # Crear nueva canción
                nueva_cancion = Cancion(
                    titulo=row.get('titulo', ''),
                    artista=row.get('interprete', ''),
                    album=row.get('album', ''),
                    duracion=int(row.get('duracion', 0)) if row.get('duracion') else 0,
                    categoria_id=categoria.id if categoria else None,
                    conjunto_id=None,  # No hay conjunto en el CSV
                    activa=True
                )
                
                db.add(nueva_cancion)
                db.flush()  # Flush to get the ID

                imported_count += 1
                
            except Exception as e:
                errors.append({
                    "row": i + 1,
                    "error": str(e)
                })
                skipped_count += 1
                continue
        
        # Commit all changes at once
        try:
            db.commit()

            
            # Verify the data was actually saved
            saved_count = db.query(Cancion).count()

            
        except Exception as e:
            db.rollback()

            raise e
        
        return {
            "message": "Importación completada",
            "imported_count": imported_count,
            "skipped_count": skipped_count,
            "errors": errors
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error importando canciones: {str(e)}")

@router.get("/template")
async def get_csv_template():
    """
    Retorna la plantilla CSV para descargar
    """
    try:
        # Headers de la plantilla
        headers = [
            'cancionid', 'difusora', 'categoria', 'categoriaid', 'idmedia', 'catidmedia',
            'idusuario1', 'idusuario2', 'titulo', 'interprete', 'interprete2', 'interprete3',
            'interprete4', 'sello', 'duracion', 'version', 'lenguaje', 'año', 'bpm',
            'tiempo_entrada', 'tiempo_salida', 'archivo', 'album', 'autor', 'genero_musical',
            'energia', 'tiempo', 'humor', 'idusuario3', 'idusuario4', 'idusuario5'
        ]
        
        # Datos de ejemplo
        sample_data = [
            [
                '1', 'XHDQ', 'Pop', '101', '1001', '201', '10001', '10002',
                'Título de la Canción', 'Artista Principal', 'Artista Secundario', 'Artista 3', 'Artista 4',
                'Sello Discográfico', '180', 'Versión Original', 'Español', '2023', '120',
                '00:00', '03:00', 'archivo1.mp3', 'Álbum de Ejemplo', 'Autor de la Canción',
                'Pop', '85', 'Medio', 'Alegre', '10003', '10004', '10005'
            ],
            [
                '2', 'XRAD', 'Rock', '102', '1002', '202', '10006', '10007',
                'Otra Canción', 'Rock Band', 'Backup Singer', '', '', 'Rock Records',
                '200', 'Live Version', 'Inglés', '2022', '140', '00:00', '03:20',
                'archivo2.mp3', 'Rock Album', 'Songwriter', 'Rock', '90', 'Alto',
                'Energético', '10008', '10009', '10010'
            ]
        ]
        
        # Crear CSV en memoria
        output = io.StringIO()
        writer = csv.writer(output)
        writer.writerow(headers)
        writer.writerows(sample_data)
        
        csv_content = output.getvalue()
        output.close()
        
        return {
            "csv_content": csv_content,
            "filename": "plantilla_canciones.csv",
            "headers": headers,
            "sample_rows": len(sample_data)
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error generando plantilla: {str(e)}")

@router.get("/validation-rules")
async def get_validation_rules():
    """
    Retorna las reglas de validación para el CSV
    """
    return {
        "required_fields": [
            "titulo",
            "interprete", 
            "difusora"
        ],
        "optional_fields": [
            "cancionid", "categoria", "categoriaid", "idmedia", "catidmedia",
            "idusuario1", "idusuario2", "interprete2", "interprete3", "interprete4",
            "sello", "duracion", "version", "lenguaje", "año", "bpm",
            "tiempo_entrada", "tiempo_salida", "archivo", "album", "autor",
            "genero_musical", "energia", "tiempo", "humor", "idusuario3",
            "idusuario4", "idusuario5"
        ],
        "field_types": {
            "cancionid": "number",
            "categoriaid": "number", 
            "idmedia": "number",
            "catidmedia": "number",
            "idusuario1": "number",
            "idusuario2": "number",
            "idusuario3": "number",
            "idusuario4": "number",
            "idusuario5": "number",
            "duracion": "number",
            "año": "number",
            "bpm": "number",
            "energia": "number"
        },
        "max_lengths": {
            "titulo": 255,
            "interprete": 255,
            "interprete2": 255,
            "interprete3": 255,
            "interprete4": 255,
            "sello": 255,
            "version": 100,
            "lenguaje": 50,
            "archivo": 255,
            "album": 255,
            "autor": 255,
            "genero_musical": 100,
            "tiempo": 50,
            "humor": 50
        }
    }
