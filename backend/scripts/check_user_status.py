#!/usr/bin/env python3
"""
Script para verificar el estado de un usuario en Cognito y RDS
"""
import sys
import os
import boto3
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Agregar el directorio raíz al path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app.core.config import settings
from app.models.auth import Usuario

def check_user_status(email: str):
    """Verifica el estado de un usuario en Cognito y RDS"""
    
    # Configurar Cognito
    user_pool_id = settings.COGNITO_USER_POOL_ID
    region = settings.COGNITO_REGION or "us-east-1"
    
    if not user_pool_id:
        print("❌ ERROR: COGNITO_USER_POOL_ID no está configurado")
        return
    
    cognito_client = boto3.client('cognito-idp', region_name=region)
    
    print(f"\n🔍 Verificando usuario: {email}\n")
    print("=" * 60)
    
    # Verificar en Cognito
    print("\n📋 ESTADO EN COGNITO:")
    print("-" * 60)
    try:
        # Buscar usuario por email
        users = cognito_client.list_users(
            UserPoolId=user_pool_id,
            Filter=f'email = "{email}"'
        )
        
        if not users.get('Users'):
            print(f"❌ Usuario no encontrado en Cognito")
            return
        
        user = users['Users'][0]
        username = user['Username']
        user_status = user.get('UserStatus', 'UNKNOWN')
        enabled = user.get('Enabled', False)
        
        print(f"✅ Usuario encontrado")
        print(f"   Username (cognito_user_id): {username}")
        print(f"   Estado: {user_status}")
        print(f"   Habilitado: {enabled}")
        
        # Mostrar atributos
        print(f"\n   Atributos:")
        for attr in user.get('UserAttributes', []):
            if attr['Name'] in ['email', 'name', 'email_verified']:
                print(f"     {attr['Name']}: {attr['Value']}")
        
        # Verificar grupos
        try:
            groups = cognito_client.admin_list_groups_for_user(
                UserPoolId=user_pool_id,
                Username=username
            )
            if groups.get('Groups'):
                print(f"\n   Grupos:")
                for group in groups['Groups']:
                    print(f"     - {group['GroupName']}")
            else:
                print(f"\n   ⚠️  No está asignado a ningún grupo")
        except Exception as e:
            print(f"\n   ⚠️  Error obteniendo grupos: {str(e)}")
        
        # Verificar en RDS
        print("\n📋 ESTADO EN RDS:")
        print("-" * 60)
        
        # Configurar conexión a BD
        database_url = settings.database_url
        engine = create_engine(database_url)
        Session = sessionmaker(bind=engine)
        db = Session()
        
        try:
            # Buscar por email
            usuario_rds = db.query(Usuario).filter(Usuario.email == email).first()
            
            if not usuario_rds:
                print(f"❌ Usuario no encontrado en RDS")
                print(f"\n💡 SOLUCIÓN: El usuario existe en Cognito pero no en RDS.")
                print(f"   Esto se solucionará automáticamente cuando el usuario inicie sesión.")
            else:
                print(f"✅ Usuario encontrado en RDS")
                print(f"   ID: {usuario_rds.id}")
                print(f"   Email: {usuario_rds.email}")
                print(f"   Nombre: {usuario_rds.nombre}")
                print(f"   Rol: {usuario_rds.rol}")
                print(f"   Activo: {usuario_rds.activo}")
                print(f"   cognito_user_id en RDS: {usuario_rds.cognito_user_id}")
                
                # Verificar si el cognito_user_id coincide
                if usuario_rds.cognito_user_id != username:
                    print(f"\n⚠️  ADVERTENCIA: cognito_user_id no coincide!")
                    print(f"   Cognito Username: {username}")
                    print(f"   RDS cognito_user_id: {usuario_rds.cognito_user_id}")
                    print(f"\n💡 SOLUCIÓN: Ejecuta el script fix_user_sync.py para sincronizar")
                else:
                    print(f"\n✅ cognito_user_id coincide correctamente")
            
        finally:
            db.close()
        
        # Diagnóstico
        print("\n📊 DIAGNÓSTICO:")
        print("-" * 60)
        
        if user_status == 'FORCE_CHANGE_PASSWORD':
            print(f"⚠️  El usuario está en estado FORCE_CHANGE_PASSWORD")
            print(f"   Esto significa que debe cambiar su contraseña antes de iniciar sesión.")
            print(f"\n💡 SOLUCIONES:")
            print(f"   1. Usar la opción '¿Olvidaste tu contraseña?' en el login")
            print(f"   2. O usar admin_set_user_password para establecer una contraseña permanente")
        elif user_status == 'CONFIRMED':
            print(f"✅ El usuario está confirmado y puede iniciar sesión")
        elif user_status == 'UNCONFIRMED':
            print(f"⚠️  El usuario no está confirmado")
            print(f"   Debe verificar su email antes de poder iniciar sesión")
        else:
            print(f"⚠️  Estado desconocido: {user_status}")
        
    except Exception as e:
        print(f"❌ Error verificando usuario: {str(e)}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python check_user_status.py <email>")
        sys.exit(1)
    
    email = sys.argv[1]
    check_user_status(email)

