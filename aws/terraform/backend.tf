# Terraform Backend Configuration
# Store state in S3 for persistence and team collaboration

terraform {
  backend "s3" {
    bucket         = "programador-musical-terraform-state"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true  # Encriptación habilitada
    kms_key_id     = "alias/terraform-state-key"  # KMS para mayor seguridad
    dynamodb_table = "programador-musical-terraform-locks"
  }
}
