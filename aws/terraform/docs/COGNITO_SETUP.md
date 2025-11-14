# Configuración de AWS Cognito para Autenticación

## Resumen

Este documento describe la configuración de autenticación y autorización con AWS Cognito para el sistema Programador Musical.

## Arquitectura de Roles

### 1. Admin (Administrador)
- **Acceso**: Todas las difusoras
- **Permisos**:
  - Gestión completa de usuarios
  - Asignación de difusoras a usuarios
  - Acceso a todas las funcionalidades del sistema
  - Configuración del sistema

### 2. Manager (Gerente)
- **Acceso**: Múltiples difusoras asignadas
- **Permisos**:
  - Gestión de políticas de programación
  - Generación de programación
  - Reportes de sus difusoras
  - Visualización de estadísticas

### 3. Operador
- **Acceso**: Una difusora específica
- **Permisos**:
  - Ver y generar programación para su difusora
  - Reportes básicos
  - Consulta de políticas

## Estructura de Base de Datos

### Tabla `usuarios`
- Sincronizada con AWS Cognito
- Almacena información del usuario y rol
- Se crea automáticamente cuando un usuario se autentica por primera vez

### Tabla `usuario_difusoras`
- Asignación many-to-many entre usuarios y difusoras
- Solo necesaria para roles `manager` y `operador`
- Los admins no necesitan asignaciones (ven todas)

## Configuración

### Variables de Entorno

**Backend:**
```env
COGNITO_USER_POOL_ID=us-east-1_XXXXXXXXX
COGNITO_CLIENT_ID=xxxxxxxxxxxxxxxxxx
COGNITO_REGION=us-east-1
```

**Frontend:**
```env
NEXT_PUBLIC_COGNITO_USER_POOL_ID=us-east-1_XXXXXXXXX
NEXT_PUBLIC_COGNITO_CLIENT_ID=xxxxxxxxxxxxxxxxxx
NEXT_PUBLIC_COGNITO_REGION=us-east-1
```

### Despliegue con Terraform

1. **Crear recursos de Cognito:**
```bash
cd aws/terraform
terraform init
terraform plan
terraform apply
```

2. **Obtener IDs de Cognito:**
```bash
terraform output cognito_user_pool_id
terraform output cognito_client_id
```

3. **Actualizar Secrets Manager:**
```bash
./aws/manage-secrets.sh update-value cognito_user_pool_id <pool-id>
./aws/manage-secrets.sh update-value cognito_client_id <client-id>
```

## Creación de Usuarios

### Opción 1: Desde AWS Console
1. Ir a AWS Cognito → User Pools
2. Seleccionar el pool creado
3. Crear usuario manualmente
4. Asignar al grupo correspondiente (admin, manager, operador)

### Opción 2: Desde CLI
```bash
aws cognito-idp admin-create-user \
  --user-pool-id <pool-id> \
  --username usuario@example.com \
  --user-attributes Name=email,Value=usuario@example.com \
  --message-action SUPPRESS

aws cognito-idp admin-add-user-to-group \
  --user-pool-id <pool-id> \
  --username usuario@example.com \
  --group-name operador
```

## Asignación de Difusoras

Una vez que el usuario se autentica por primera vez (se crea automáticamente en la BD), un administrador debe asignarle difusoras:

```bash
# API Endpoint
POST /api/v1/auth/usuarios/{usuario_id}/difusoras?difusora_id={difusora_id}
```

O desde el frontend, en la sección de gestión de usuarios.

## Flujo de Autenticación

1. Usuario inicia sesión en el frontend con Cognito
2. Cognito devuelve tokens (access, id, refresh)
3. Frontend envía `access_token` en header `Authorization: Bearer <token>`
4. Backend verifica token con Cognito JWKS
5. Backend sincroniza usuario en BD (si no existe)
6. Backend obtiene difusoras asignadas al usuario
7. Backend aplica filtros en todas las consultas

## Endpoints Protegidos

Todos los endpoints requieren autenticación excepto:
- `GET /health`
- `GET /` (root)

Los endpoints filtran automáticamente por difusoras asignadas:
- `/api/v1/programacion/politicas/`
- `/api/v1/catalogos/general/difusoras/`
- `/api/v1/programacion/generar-programacion-completa`
- `/api/v1/reportes/estadisticas/*`

## Seguridad

- Tokens JWT verificados con claves públicas de Cognito (JWKS)
- Tokens expiran después de 60 minutos
- Refresh tokens válidos por 30 días
- Contraseñas con política fuerte (8+ caracteres, mayúsculas, números, símbolos)
- MFA opcional (configurable)

## Desarrollo Local

Para desarrollo local sin Cognito configurado, el sistema funciona en modo "dev" y permite acceso sin autenticación. Esto se detecta automáticamente cuando `COGNITO_USER_POOL_ID` no está configurado.

## Migración de Datos

Para migrar usuarios existentes:

1. Crear usuarios en Cognito
2. Ejecutar migración de Alembic:
```bash
cd backend
alembic upgrade head
```
3. Asignar difusoras a usuarios mediante la API

