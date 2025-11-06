# Secrets Management Guide

This guide covers how to manage application secrets using AWS Secrets Manager for the Programador Musical application.

## Overview

The application uses AWS Secrets Manager to securely store and manage sensitive configuration data including:

- JWT secret keys for authentication
- Database credentials and connection strings
- API keys and other sensitive configuration

## Secret Structure

### Application Secrets

**Secret Name:** `programador-musical-production-app-secrets`

**Content Structure:**
```json
{
  "jwt_secret_key": "base64-encoded-secret-key",
  "database_url": "postgresql://user:password@host:5432/database",
  "database_host": "rds-endpoint.region.rds.amazonaws.com",
  "database_name": "programador_musical",
  "database_username": "programador_user", 
  "database_password": "secure-random-password"
}
```

### Database Credentials Secret

**Secret Name:** `programador-musical-production-db-credentials`

**Content Structure:**
```json
{
  "username": "programador_user",
  "password": "secure-random-password",
  "engine": "postgres",
  "host": "rds-endpoint.region.rds.amazonaws.com",
  "port": 5432,
  "dbname": "programador_musical"
}
```

## Management Script

Use the `aws/manage-secrets.sh` script for all secret operations:

### Initial Setup

```bash
# Create secrets with auto-generated secure values
./aws/manage-secrets.sh create
```

This will:
- Generate a secure JWT secret (32 bytes, base64 encoded)
- Generate a secure database password (20 characters)
- Create both secrets in AWS Secrets Manager
- Output the generated database password for Terraform configuration

### Viewing Secrets

```bash
# View all secrets (values will be displayed)
./aws/manage-secrets.sh get

# Get a specific secret value
./aws/manage-secrets.sh get-value jwt_secret_key
./aws/manage-secrets.sh get-value database_password
```

### Updating Secrets

```bash
# Update a specific secret value
./aws/manage-secrets.sh update-value database_name new_database_name
./aws/manage-secrets.sh update-value jwt_secret_key new_jwt_secret
```

### Secret Rotation

```bash
# Rotate JWT secret (generates new random value)
./aws/manage-secrets.sh rotate-jwt

# Rotate database password (updates secret only)
./aws/manage-secrets.sh rotate-db
```

**Important:** When rotating the database password, you must also update the actual RDS password:

```bash
# After rotating the secret, update RDS
aws rds modify-db-instance \
  --db-instance-identifier programador-musical-production-db \
  --master-user-password NEW_PASSWORD \
  --apply-immediately
```

### Listing Secrets

```bash
# List all project-related secrets
./aws/manage-secrets.sh list
```

### Deleting Secrets

```bash
# Permanently delete secrets (use with caution)
./aws/manage-secrets.sh delete
```

## Integration with ECS

The ECS task definition automatically retrieves secrets from Secrets Manager:

```json
{
  "secrets": [
    {
      "name": "SECRET_KEY",
      "valueFrom": "arn:aws:secretsmanager:region:account:secret:programador-musical-production-app-secrets:jwt_secret_key::"
    },
    {
      "name": "DATABASE_PASSWORD", 
      "valueFrom": "arn:aws:secretsmanager:region:account:secret:programador-musical-production-app-secrets:database_password::"
    }
  ]
}
```

## Security Best Practices

### Access Control

The ECS execution role has minimal permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ],
      "Resource": [
        "arn:aws:secretsmanager:region:account:secret:programador-musical-*"
      ]
    }
  ]
}
```

### Encryption

- **At Rest:** Secrets are encrypted using AWS KMS
- **In Transit:** All API calls use TLS 1.2+
- **In Memory:** Secrets are only loaded when needed

### Audit Trail

- All secret access is logged in CloudTrail
- Secret modifications are tracked with timestamps
- Version history is maintained automatically

## Troubleshooting

### Common Issues

1. **Permission Denied**
   ```bash
   # Check AWS credentials
   aws sts get-caller-identity
   
   # Verify IAM permissions for Secrets Manager
   aws iam get-role-policy --role-name programador-musical-production-ecs-execution-role --policy-name programador-musical-production-ecs-execution-secrets
   ```

2. **Secret Not Found**
   ```bash
   # List all secrets to verify name
   aws secretsmanager list-secrets --query "SecretList[?contains(Name, 'programador-musical')]"
   
   # Check if secret exists in correct region
   aws secretsmanager describe-secret --secret-id programador-musical-production-app-secrets --region us-east-1
   ```

3. **ECS Task Cannot Access Secrets**
   ```bash
   # Check ECS task definition
   aws ecs describe-task-definition --task-definition programador-musical-production-app
   
   # Verify ECS execution role permissions
   aws iam list-attached-role-policies --role-name programador-musical-production-ecs-execution-role
   ```

### Debugging Commands

```bash
# Test secret retrieval
aws secretsmanager get-secret-value --secret-id programador-musical-production-app-secrets

# Check secret metadata
aws secretsmanager describe-secret --secret-id programador-musical-production-app-secrets

# View secret versions
aws secretsmanager list-secret-version-ids --secret-id programador-musical-production-app-secrets

# Test KMS permissions
aws kms describe-key --key-id alias/aws/secretsmanager
```

## Cost Considerations

### Secrets Manager Pricing

- **Secret Storage:** $0.40 per secret per month
- **API Calls:** $0.05 per 10,000 requests
- **Estimated Monthly Cost:** ~$2-3 for typical usage

### Cost Optimization

- Use fewer secrets by combining related values in JSON
- Minimize API calls by caching secrets in application
- Consider using SSM Parameter Store for non-sensitive config

## Automation

### CI/CD Integration

The GitHub Actions workflow automatically handles secrets:

```yaml
- name: Create/Update Secrets
  run: |
    if ! aws secretsmanager describe-secret --secret-id programador-musical-production-app-secrets; then
      ./aws/manage-secrets.sh create
    fi
```

### Terraform Integration

Secrets are referenced in Terraform but values are managed separately:

```hcl
resource "aws_secretsmanager_secret_version" "app_secrets" {
  secret_id = aws_secretsmanager_secret.app_secrets.id
  secret_string = jsonencode({
    jwt_secret_key = var.jwt_secret_key
    # ... other values
  })
}
```

## Migration from SSM Parameter Store

If migrating from SSM Parameter Store:

1. **Export existing parameters:**
   ```bash
   aws ssm get-parameters-by-path --path "/programador-musical/production" --recursive --with-decryption
   ```

2. **Create secrets with existing values:**
   ```bash
   # Manually create secrets with current values
   ./aws/manage-secrets.sh create
   ./aws/manage-secrets.sh update-value jwt_secret_key "existing-jwt-secret"
   ```

3. **Update Terraform configuration:**
   - Remove SSM parameter resources
   - Add Secrets Manager resources
   - Update ECS task definition

4. **Deploy changes:**
   ```bash
   terraform plan
   terraform apply
   ```

## Monitoring and Alerting

### CloudWatch Metrics

Monitor secret usage:
- `AWS/SecretsManager/SecretRetrievals`
- `AWS/SecretsManager/RotationFailed`
- `AWS/SecretsManager/RotationSucceeded`

### CloudWatch Alarms

Set up alerts for:
- Failed secret retrievals
- Unauthorized access attempts
- Rotation failures

### Example Alarm

```bash
aws cloudwatch put-metric-alarm \
  --alarm-name "SecretsManager-UnauthorizedAccess" \
  --alarm-description "Alert on unauthorized secret access" \
  --metric-name "SecretRetrievals" \
  --namespace "AWS/SecretsManager" \
  --statistic "Sum" \
  --period 300 \
  --threshold 10 \
  --comparison-operator "GreaterThanThreshold"
```