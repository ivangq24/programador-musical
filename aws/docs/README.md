# AWS ECS Deployment Guide

This guide walks you through deploying the Programador Musical application to AWS using ECS Fargate.

## Prerequisites

1. **AWS CLI** - [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
2. **Docker** - [Install Docker](https://docs.docker.com/get-docker/)
3. **Terraform** - [Install Terraform](https://developer.hashicorp.com/terraform/downloads)
4. **AWS Account** with appropriate permissions

## AWS Permissions Required

Your AWS user/role needs the following permissions:
- EC2 (VPC, Subnets, Security Groups, Load Balancers)
- ECS (Clusters, Services, Task Definitions)
- ECR (Repositories, Images)
- RDS (Instances, Subnet Groups)
- IAM (Roles, Policies)
- SSM (Parameters)
- CloudWatch (Log Groups)
- ACM (Certificates) - if using custom domain
- Route53 (DNS) - if using custom domain

## Quick Start

### 1. Configure AWS Credentials

```bash
aws configure
# Enter your AWS Access Key ID, Secret Access Key, and region
```

### 2. Configure Terraform Variables

```bash
cd aws/terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your configuration
```

**Important**: Update these values in `terraform.tfvars`:
- `database_password` - Use a strong, unique password
- `jwt_secret_key` - Use a secure random string (32+ characters)
- `domain_name` - Your domain (optional, leave empty to use ALB DNS)
- `backend_cors_origins` - Update with your domain for security

### 3. Deploy to AWS

```bash
cd ../..  # Back to project root
chmod +x aws/deploy-to-aws.sh
./aws/deploy-to-aws.sh deploy
```

This will:
1. Create ECR repositories
2. Build and push Docker images
3. Deploy infrastructure with Terraform
4. Start ECS services
5. Provide the application URL

## Architecture Overview

The deployment creates:

- **VPC** with public, private, and database subnets across 1 AZs
- **ECS Fargate Cluster** running containerized application
- **Application Load Balancer** with HTTPS termination
- **RDS PostgreSQL** database in private subnets
- **ECR repositories** for Docker images
- **CloudWatch** for logging and monitoring
- **SSM Parameter Store** for secrets management

## Cost Optimization

The configuration is optimized for cost:

- **ECS Fargate**: Pay only for running tasks
- **RDS t3.micro**: Smallest instance, can scale up
- **Single AZ RDS**: Can enable Multi-AZ later if needed
- **Spot instances**: Available for ECS (70% cost savings)

**Estimated monthly cost**: ~$65-85 USD (includes Secrets Manager)

## Secrets Management

The deployment uses AWS Secrets Manager for secure storage of sensitive configuration:

### Managing Secrets

Use the provided script to manage secrets:

```bash
# Create initial secrets with generated values
./aws/manage-secrets.sh create

# View all secrets (masked)
./aws/manage-secrets.sh get

# Get a specific secret value
./aws/manage-secrets.sh get-value jwt_secret_key

# Update a specific value
./aws/manage-secrets.sh update-value database_name new_db_name

# Rotate JWT secret
./aws/manage-secrets.sh rotate-jwt

# List all project secrets
./aws/manage-secrets.sh list
```

### Secret Structure

The application secrets are stored as JSON in Secrets Manager:

```json
{
  "jwt_secret_key": "secure-random-key",
  "database_url": "postgresql://user:pass@host:5432/db", 
  "database_host": "rds-endpoint",
  "database_name": "programador_musical",
  "database_username": "programador_user",
  "database_password": "secure-password"
}
```

## Configuration Options

### Environment Variables

Key configuration in `terraform.tfvars`:

```hcl
# Scaling configuration
ecs_desired_count = 1        # Number of running tasks
ecs_min_capacity = 1         # Minimum tasks for auto-scaling
ecs_max_capacity = 3         # Maximum tasks for auto-scaling

# Database configuration
db_instance_class = "db.t3.micro"    # Can upgrade to db.t3.small, etc.
db_allocated_storage = 20            # GB, auto-scales up to 100GB

# Security
enable_deletion_protection = false   # Set true for production
```

### Custom Domain Setup

If you have a domain:

1. Create a Route53 hosted zone for your domain
2. Update your domain's nameservers to use Route53
3. Set `domain_name = "yourdomain.com"` in terraform.tfvars
4. Update `backend_cors_origins` to include your domain

## Management Commands

### Update Application

After making code changes:

```bash
./aws/deploy-to-aws.sh update
```

### Check Status

```bash
./aws/deploy-to-aws.sh status
```

### View Logs

```bash
# View ECS service logs
aws logs tail /ecs/programador-musical-production/backend --follow
aws logs tail /ecs/programador-musical-production/frontend --follow
aws logs tail /ecs/programador-musical-production/nginx --follow
```

### Scale Application

```bash
# Scale to 2 instances
aws ecs update-service \
  --cluster programador-musical-production-cluster \
  --service programador-musical-production-app \
  --desired-count 2
```

### Database Access

```bash
# Connect to RDS (from EC2 instance in same VPC)
psql -h <RDS_ENDPOINT> -U programador_user -d programador_musical
```

## Monitoring

### CloudWatch Dashboards

The deployment includes CloudWatch monitoring:

- **Application Logs**: `/ecs/programador-musical-production/*`
- **RDS Metrics**: CPU, connections, storage
- **ALB Metrics**: Request count, response times, errors

### Health Checks

- **ALB Health Check**: `GET /health` every 30 seconds
- **Container Health Checks**: Built into each container
- **Auto-scaling**: Based on CPU/memory utilization

## Security Features

- **VPC Isolation**: Private subnets for application and database
- **Security Groups**: Restrictive firewall rules
- **Encryption**: RDS encryption at rest, HTTPS in transit
- **Secrets Management**: SSM Parameter Store for sensitive data
- **IAM Roles**: Least privilege access for ECS tasks

## Backup and Recovery

### Database Backups

- **Automated Backups**: Daily backups with 3-day retention
- **Point-in-time Recovery**: Available within backup window
- **Manual Snapshots**: Can be created as needed

### Disaster Recovery

- **Infrastructure as Code**: Complete infrastructure in Terraform
- **Multi-AZ Deployment**: Can be enabled for RDS high availability
- **Cross-region Replication**: Available for ECR images

## Troubleshooting

### Common Issues

1. **ECS Tasks Failing to Start**
   ```bash
   # Check ECS service events
   aws ecs describe-services --cluster <cluster-name> --services <service-name>
   
   # Check task logs
   aws logs tail /ecs/programador-musical-production/backend --follow
   ```

2. **Database Connection Issues**
   - Verify security groups allow port 5432
   - Check RDS endpoint in environment variables
   - Ensure database credentials are correct

3. **Load Balancer Health Check Failures**
   - Verify `/health` endpoint is responding
   - Check container health checks
   - Review ALB target group health

### Useful Commands

```bash
# List ECS services
aws ecs list-services --cluster programador-musical-production-cluster

# Describe ECS service
aws ecs describe-services --cluster <cluster> --services <service>

# View task definition
aws ecs describe-task-definition --task-definition <task-def-arn>

# Check RDS status
aws rds describe-db-instances --db-instance-identifier <db-id>

# View Terraform state
cd aws/terraform && terraform show
```

## Cleanup

To destroy all AWS resources:

```bash
./aws/deploy-to-aws.sh destroy
```

**Warning**: This will permanently delete all data. Make sure to backup any important data first.

## Support

For issues or questions:

1. Check CloudWatch logs for application errors
2. Review ECS service events for deployment issues
3. Verify Terraform configuration for infrastructure problems
4. Check AWS service health dashboards

## Next Steps

After successful deployment:

1. **Enable monitoring alerts** in CloudWatch
2. **Set up CI/CD pipeline** for automated deployments
3. **Configure backup strategy** for production data
4. **Enable Multi-AZ RDS** for high availability
5. **Add CloudFront CDN** for better performance
6. **Implement auto-scaling policies** based on metrics