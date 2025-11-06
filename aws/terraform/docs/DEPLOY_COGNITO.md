# Guía de Despliegue de Cognito

Esta guía te ayudará a desplegar AWS Cognito con Terraform para el sistema de autenticación.

## 📋 Prerrequisitos

1. **AWS CLI configurado**:
   ```bash
   aws configure
   ```

2. **Terraform instalado** (versión >= 1.0):
   ```bash
   terraform version
   ```

3. **Variables de Terraform configuradas**:
   - Copia `terraform.tfvars.example` a `terraform.tfvars`
   - Completa las variables necesarias

## 🚀 Despliegue Rápido

### Opción 1: Script Automático (Recomendado)

```bash
cd aws
./deploy-cognito.sh plan    # Ver qué se va a crear
./deploy-cognito.sh apply   # Desplegar Cognito
```

### Opción 2: Terraform Manual

```bash
cd aws/terraform

# 1. Inicializar Terraform
terraform init

# 2. Validar configuración
terraform validate

# 3. Ver plan (solo Cognito)
terraform plan -target=aws_cognito_user_pool.main \
               -target=aws_cognito_user_pool_client.web \
               -target=aws_cognito_user_pool_domain.main \
               -target=aws_cognito_user_group.admin \
               -target=aws_cognito_user_group.manager \
               -target=aws_cognito_user_group.operador

# 4. Aplicar cambios
terraform apply -target=aws_cognito_user_pool.main \
                -target=aws_cognito_user_pool_client.web \
                -target=aws_cognito_user_pool_domain.main \
                -target=aws_cognito_user_group.admin \
                -target=aws_cognito_user_group.manager \
                -target=aws_cognito_user_group.operador
```

## 📝 Configurar Variables de Entorno

Después del despliegue, obtén los valores de configuración:

```bash
cd aws/terraform
terraform output
```

### Frontend (.env.local)

```env
NEXT_PUBLIC_COGNITO_USER_POOL_ID=<del output>
NEXT_PUBLIC_COGNITO_CLIENT_ID=<del output>
NEXT_PUBLIC_COGNITO_DOMAIN=<del output>
NEXT_PUBLIC_COGNITO_REGION=us-east-1
```

### Backend (.env)

```env
COGNITO_USER_POOL_ID=<del output>
COGNITO_CLIENT_ID=<del output>
COGNITO_REGION=us-east-1
```

## 🔐 Crear Primer Usuario Admin

Después de desplegar Cognito, crea un usuario administrador:

```bash
# Usando AWS CLI
aws cognito-idp admin-create-user \
  --user-pool-id <USER_POOL_ID> \
  --username admin@example.com \
  --user-attributes Name=email,Value=admin@example.com Name=custom:rol,Value=admin Name=name,Value=Administrador \
  --temporary-password "TempPass123!" \
  --message-action SUPPRESS

# Asignar al grupo admin
aws cognito-idp admin-add-user-to-group \
  --user-pool-id <USER_POOL_ID> \
  --username admin@example.com \
  --group-name admin
```

## ✅ Verificar Despliegue

1. **Verificar en AWS Console**:
   - Ve a AWS Cognito → User Pools
   - Deberías ver tu User Pool creado

2. **Verificar configuración**:
   ```bash
   terraform output cognito_user_pool_id
   terraform output cognito_client_id
   terraform output cognito_domain
   ```

3. **Probar login**:
   - Visita: `http://localhost:3000/auth/login`
   - Deberías ver la página de login

## 🔧 Configurar OAuth (Opcional)

Para habilitar Google/Apple login:

1. **Obtener credenciales**:
   - Google: [Google Cloud Console](https://console.cloud.google.com/)
   - Apple: [Apple Developer Portal](https://developer.apple.com/)

2. **Actualizar terraform.tfvars**:
   ```hcl
   google_client_id = "tu-google-client-id"
   google_client_secret = "tu-google-secret"
   apple_client_id = "tu-apple-client-id"
   apple_client_secret = "tu-apple-secret"
   ```

3. **Aplicar cambios**:
   ```bash
   terraform apply -target=aws_cognito_identity_provider.google \
                   -target=aws_cognito_identity_provider.apple
   ```

## 🗑️ Destruir Recursos

⚠️ **ADVERTENCIA**: Esto eliminará todos los usuarios y datos de Cognito.

```bash
./deploy-cognito.sh destroy
```

## 📚 Recursos Adicionales

- [Documentación de Seguridad](COGNITO_SECURITY.md)
- [Guía de Setup Manual](COGNITO_SETUP.md)
- [Documentación AWS Cognito](https://docs.aws.amazon.com/cognito/)

## 🆘 Solución de Problemas

### Error: "User Pool already exists"
- Verifica que el nombre no esté en uso
- Cambia `project_name` o `environment` en `terraform.tfvars`

### Error: "Domain already exists"
- Los dominios de Cognito son únicos globalmente
- Cambia el nombre del dominio en `cognito.tf`

### Error: "Invalid provider configuration"
- Verifica que AWS CLI esté configurado: `aws sts get-caller-identity`
- Verifica que tengas permisos para crear recursos de Cognito

