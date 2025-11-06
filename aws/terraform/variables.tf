variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (staging, production)"
  type        = string
  default     = "production"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "programador-musical"
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "database_name" {
  description = "Name of the PostgreSQL database"
  type        = string
  default     = "programador_musical"
}

variable "database_username" {
  description = "Username for the PostgreSQL database"
  type        = string
  default     = "programador_user"
}

variable "database_password" {
  description = "Password for the PostgreSQL database"
  type        = string
  sensitive   = true
}

variable "jwt_secret_key" {
  description = "JWT secret key for authentication"
  type        = string
  sensitive   = true
}

variable "backend_cors_origins" {
  description = "CORS origins for the backend API"
  type        = list(string)
  default     = ["*"]
}

variable "ecs_desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 1
}

variable "ecs_min_capacity" {
  description = "Minimum number of ECS tasks"
  type        = number
  default     = 1
}

variable "ecs_max_capacity" {
  description = "Maximum number of ECS tasks (for 20 users, 2 is sufficient)"
  type        = number
  default     = 2
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "RDS allocated storage in GB (minimum for 20 users)"
  type        = number
  default     = 20
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for RDS"
  type        = bool
  default     = true
}

variable "allowed_ip_addresses" {
  description = "List of IP addresses allowed to access the application (CIDR format)"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Default to open access, should be overridden
}

variable "restrict_to_ip" {
  description = "Whether to restrict access to specific IP addresses only"
  type        = bool
  default     = true
}

variable "google_client_id" {
  description = "Google OAuth Client ID"
  type        = string
  default     = ""
}

variable "google_client_secret" {
  description = "Google OAuth Client Secret"
  type        = string
  sensitive   = true
  default     = ""
}

variable "apple_client_id" {
  description = "Apple OAuth Client ID (Service ID)"
  type        = string
  default     = ""
}

variable "apple_client_secret" {
  description = "Apple OAuth Client Secret (Key ID)"
  type        = string
  sensitive   = true
  default     = ""
}