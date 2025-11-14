# 📜 Scripts de AWS - Programador Musical

## 🚀 **Scripts Principales (Deployment)**

### `deploy-to-aws.sh` 
**Script principal de despliegue completo**
```bash
./deploy-to-aws.sh deploy    # Despliegue completo
./deploy-to-aws.sh update    # Solo actualizar aplicación
./deploy-to-aws.sh destroy   # Destruir recursos
```

### `manage-secrets.sh`
**Gestión de secretos en AWS Secrets Manager**
```bash
./manage-secrets.sh create   # Crear secretos iniciales
./manage-secrets.sh get      # Ver secretos actuales
./manage-secrets.sh rotate-jwt  # Rotar JWT secret
```

### `setup-terraform-backend.sh`
**Configurar el backend de Terraform (S3)**
```bash
./setup-terraform-backend.sh
```

## 🔍 **Scripts de Monitoreo**

### `check-ecs-status.sh`
**Verificar estado de los servicios ECS**
```bash
./check-ecs-status.sh
```

## 📋 **Orden de Uso Recomendado**

### **Primera vez (Deploy completo):**
```bash
# 1. Configurar backend de Terraform (solo primera vez)
./setup-terraform-backend.sh

# 2. Desplegar infraestructura completa
./deploy-to-aws.sh deploy

# 3. Crear primer admin desde la aplicación web
# Visita: https://tu-dominio/auth/setup
```

### **Actualizaciones de código:**
```bash
./deploy-to-aws.sh update
```

### **Monitoreo:**
```bash
./check-ecs-status.sh      # Estado de servicios
```

### **Limpieza:**
```bash
./deploy-to-aws.sh destroy   # Destruir todo
```

## ⚠️ **Notas Importantes**

- Todos los scripts deben ejecutarse desde el directorio `aws/`
- Asegúrate de tener configuradas las credenciales de AWS
- El archivo `terraform/terraform.tfvars` debe existir antes del deploy
- Los secretos se crean automáticamente durante el deploy
- Los backups se gestionan directamente desde AWS (RDS snapshots automáticos)
- La gestión de usuarios se realiza desde la aplicación web, no desde scripts

## 📚 **Documentación Adicional**

- `PRE-DEPLOY-CHECKLIST.md` - Checklist antes de desplegar
- `PRODUCTION-STATUS.md` - Estado de producción
- `FINAL-VERIFICATION.md` - Verificación final
- `ASSIGN-DIFUSORAS-GUIDE.md` - Guía para asignar difusoras
- `docs/` - Documentación adicional sobre costos, seguridad, etc.
