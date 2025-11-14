# AWS Cognito User Pool para autenticación de usuarios
resource "aws_cognito_user_pool" "main" {
  name = "${var.project_name}-${var.environment}-user-pool"

  # Configuración de usuarios
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  # Políticas de contraseña más estrictas
  password_policy {
    minimum_length                   = 12  # Aumentado de 8 a 12
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7   # Las contraseñas temporales expiran en 7 días
  }

  # Atributos personalizados
  # NOTA: No se pueden agregar atributos personalizados a un User Pool existente
  # Si necesitas estos atributos, debes recrear el User Pool
  # schema {
  #   name                = "rol"
  #   attribute_data_type = "String"
  #   mutable             = true
  #   required            = false
  # }
  #
  # schema {
  #   name                = "nombre"
  #   attribute_data_type = "String"
  #   mutable             = true
  #   required            = false
  # }

  # Configuración de MFA - OPCIONAL para desarrollo, puede cambiarse a "ON" para producción
  mfa_configuration = "OPTIONAL"
  
  software_token_mfa_configuration {
    enabled = true
  }

  # Configuración de recuperación de cuenta
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }

  # Configuración de email
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
    # from_email_address solo se puede usar con SES
  }

  # Configuración de seguridad avanzada (Anti-fraude)
  # Comentado porque requiere tier PREMIUM, no disponible en ESSENTIALS
  # user_pool_add_ons {
  #   advanced_security_mode = "ENFORCED"  # Modo ENFORCED para máxima seguridad
  # }

  # Configuración de protección contra ataques
  admin_create_user_config {
    allow_admin_create_user_only = true  # Solo admins pueden crear usuarios (PRODUCCIÓN)
    
    invite_message_template {
      email_message = """
Bienvenido a Programador Musical

Estimado/a {username},

Su cuenta ha sido creada exitosamente en Programador Musical, la plataforma profesional para la gestión y programación de contenido musical.

CREDENCIALES DE ACCESO:
Email: {username}
Contraseña temporal: {####}

IMPORTANTE: Por seguridad, debe cambiar esta contraseña temporal en su primer inicio de sesión. Esta contraseña expirará en 7 días.

Para acceder al sistema, visite: https://programador-musical.com/auth/login

Si tiene alguna pregunta o necesita asistencia, no dude en contactar al administrador del sistema.

Atentamente,
Equipo de Programador Musical

---
Este es un mensaje automático. Por favor, no responda a este correo.
      """
      email_subject = "Bienvenido a Programador Musical - Credenciales de Acceso"
      sms_message   = "Programador Musical: Su contraseña temporal es {####}. Acceda en: https://programador-musical.com/auth/login"
    }
  }

  # Configuración de verificación - Usar código como opción más simple
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_message        = """
Verificación de Email - Programador Musical

Estimado/a usuario,

Para completar el proceso de verificación de su cuenta en Programador Musical, utilice el siguiente código de verificación:

CÓDIGO DE VERIFICACIÓN: {####}

Este código es válido por 15 minutos. Si no solicitó este código, puede ignorar este mensaje.

Si tiene alguna pregunta, contacte al administrador del sistema.

Atentamente,
Equipo de Programador Musical

---
Este es un mensaje automático. Por favor, no responda a este correo.
      """
    email_subject        = "Código de Verificación - Programador Musical"
    sms_message          = "Programador Musical: Su código de verificación es {####}. Válido por 15 minutos."
  }

  # Configuración de dispositivo
  device_configuration {
    challenge_required_on_new_device      = true
    device_only_remembered_on_user_prompt = true
  }

  # Tags
  tags = {
    Name        = "${var.project_name}-${var.environment}-user-pool"
    Environment = var.environment
    Project     = var.project_name
  }
}

# User Pool Client para la aplicación web
resource "aws_cognito_user_pool_client" "web" {
  name         = "${var.project_name}-${var.environment}-web-client"
  user_pool_id = aws_cognito_user_pool.main.id

  generate_secret                      = false  # false para aplicaciones web (SPA)
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]  # Solo Authorization Code Flow (más seguro que implicit)
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  supported_identity_providers         = ["COGNITO"]
  
  # Callback URLs - Solo URLs permitidas (whitelist)
  # Incluir URLs para OAuth y verificación de email
  # Nota: Cognito solo permite HTTP para localhost, producción requiere HTTPS
  callback_urls = concat(
    [
      "http://localhost:3000/auth/callback",
      "http://127.0.0.1:3000/auth/callback",
      "http://localhost:3000/auth/verify-email",
      "http://127.0.0.1:3000/auth/verify-email",
      "http://localhost:3000/",
      "http://127.0.0.1:3000/"
    ],
    var.domain_name != "" ? [
      "https://${var.domain_name}/auth/callback",
      "https://www.${var.domain_name}/auth/callback",
      "https://${var.domain_name}/auth/verify-email",
      "https://www.${var.domain_name}/auth/verify-email",
      "https://${var.domain_name}/",
      "https://www.${var.domain_name}/"
    ] : []
  )
  
  # Logout URLs
  logout_urls = concat(
    [
      "http://localhost:3000",
      "http://127.0.0.1:3000",
      "http://localhost:3000/",
      "http://127.0.0.1:3000/"
    ],
    var.domain_name != "" ? [
      "https://${var.domain_name}",
      "https://www.${var.domain_name}",
      "https://${var.domain_name}/",
      "https://www.${var.domain_name}/"
    ] : []
  )
  
  # Configuración de tokens - Validez reducida para mayor seguridad
  access_token_validity  = 15   # 15 minutos (reducido de 60)
  id_token_validity      = 15   # 15 minutos (reducido de 60)
  refresh_token_validity = 30   # 30 días
  
  # Prevenir información de usuarios inexistentes (evita user enumeration)
  prevent_user_existence_errors = "ENABLED"
  
  # Token revocation - permitir revocar tokens
  enable_token_revocation = true
  
  # Configuración de lectura de atributos
  # Solo atributos estándar ya que no tenemos custom attributes
  read_attributes = [
    "email",
    "email_verified",
    "name"
  ]
  
  # Configuración de escritura de atributos
  # Solo atributos estándar ya que no tenemos custom attributes
  write_attributes = [
    "email",
    "name"
  ]
}

# Grupos de usuarios
resource "aws_cognito_user_group" "admin" {
  name         = "admin"
  user_pool_id = aws_cognito_user_pool.main.id
  description  = "Administradores con acceso completo al sistema"
  precedence   = 1
}

resource "aws_cognito_user_group" "manager" {
  name         = "manager"
  user_pool_id = aws_cognito_user_pool.main.id
  description  = "Gerentes con acceso a múltiples difusoras"
  precedence   = 2
}

resource "aws_cognito_user_group" "operador" {
  name         = "operador"
  user_pool_id = aws_cognito_user_pool.main.id
  description  = "Operadores con acceso a una difusora específica"
  precedence   = 3
}

# Domain para Cognito (necesario para OAuth)
resource "aws_cognito_user_pool_domain" "main" {
  domain       = "${var.project_name}-${var.environment}-auth"
  user_pool_id = aws_cognito_user_pool.main.id
  
  # Configuración de certificado SSL (opcional, pero recomendado)
  # Si tienes un dominio personalizado, puedes usar certificate_arn
}

# Identity Providers - Google y Apple deshabilitados por ahora
# Para habilitarlos en el futuro, descomentar y configurar las variables:
#
# resource "aws_cognito_identity_provider" "google" {
#   count        = var.google_client_id != "" ? 1 : 0
#   user_pool_id  = aws_cognito_user_pool.main.id
#   provider_name = "Google"
#   provider_type = "Google"
#
#   provider_details = {
#     authorize_scopes = "email openid profile"
#     client_id        = var.google_client_id
#     client_secret    = var.google_client_secret
#   }
#
#   attribute_mapping = {
#     email    = "email"
#     username = "sub"
#     name     = "name"
#   }
# }

# resource "aws_cognito_identity_provider" "apple" {
#   count        = var.apple_client_id != "" ? 1 : 0
#   user_pool_id  = aws_cognito_user_pool.main.id
#   provider_name = "SignInWithApple"
#   provider_type = "SignInWithApple"
#
#   provider_details = {
#     authorize_scopes = "email openid name"
#     client_id        = var.apple_client_id
#     client_secret    = var.apple_client_secret
#   }
#
#   attribute_mapping = {
#     email    = "email"
#     username = "sub"
#     name     = "name"
#   }
# }

