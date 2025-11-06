# Deployment Guide - Programador Musical

This guide covers all deployment options for the Programador Musical application.

## Quick Start

### 1. Production Setup
```bash
chmod +x scripts/setup-production.sh
./scripts/setup-production.sh
```

### 2. Choose Your Deployment Method

#### Option A: AWS ECS (Recommended for Production)
```bash
# Configure AWS credentials
aws configure

# Deploy to AWS
./aws/deploy-to-aws.sh deploy
```

#### Option B: Local Production Environment
```bash
# Deploy locally with production configuration
./scripts/deploy.sh deploy
```

## What You Need for Deployment

### Required Tools
- **Docker & Docker Compose** - Container orchestration
- **AWS CLI** (for AWS deployment) - AWS service management
- **Terraform** (for AWS deployment) - Infrastructure as code
- **Git** - Version control

### Required Configuration Files

The setup script creates these automatically, but you need to review and customize:

1. **`.env.prod`** - Production environment variables
2. **`aws/terraform/terraform.tfvars`** - AWS infrastructure configuration

### AWS Deployment Requirements

#### AWS Account Setup
1. **AWS Account** with billing enabled
2. **IAM User** with programmatic access and these permissions:
   - EC2 (VPC, Load Balancers, Security Groups)
   - ECS (Clusters, Services, Tasks)
   - ECR (Container Registry)
   - RDS (Database)
   - IAM (Roles and Policies)
   - CloudWatch (Logging)
   - SSM (Parameter Store)
   - ACM (SSL Certificates) - if using custom domain
   - Route53 (DNS) - if using custom domain

#### Cost Considerations
- **Estimated monthly cost**: $60-80 USD
- **Free tier eligible**: Some services (first 12 months)
- **Cost optimization**: Uses t3.micro instances and minimal resources

### Domain Setup (Optional)

If you have a custom domain:

1. **Route53 Hosted Zone** - Create in AWS Console
2. **Update nameservers** - Point your domain to Route53
3. **SSL Certificate** - Automatically created by Terraform
4. **Update configuration** - Set `domain_name` in terraform.tfvars

## Deployment Process

### AWS ECS Deployment

The AWS deployment creates:

```
Internet → CloudFront (optional) → ALB → ECS Fargate → RDS PostgreSQL
                                    ↓
                               CloudWatch Logs
```

**Infrastructure Components:**
- **VPC** with public/private subnets across 3 AZs
- **ECS Fargate** cluster with auto-scaling
- **Application Load Balancer** with HTTPS termination
- **RDS PostgreSQL** in private subnets
- **ECR repositories** for Docker images
- **CloudWatch** for monitoring and logs
- **SSM Parameter Store** for secrets

**Deployment Steps:**
1. Creates ECR repositories
2. Builds and pushes Docker images
3. Deploys infrastructure with Terraform
4. Starts ECS services
5. Configures load balancer and SSL

### Local Production Deployment

For testing production configuration locally:

```
Internet → Nginx → Frontend (Next.js) + Backend (FastAPI) → PostgreSQL
```

**Components:**
- **Docker Compose** orchestration
- **Nginx** reverse proxy with SSL
- **PostgreSQL** database with persistent storage
- **Health checks** and monitoring

## Configuration Details

### Environment Variables

**Backend Configuration:**
```bash
DATABASE_URL=postgresql://user:pass@host:5432/db
SECRET_KEY=your-jwt-secret-key
ACCESS_TOKEN_EXPIRE_MINUTES=1440
API_V1_STR=/api/v1
PROJECT_NAME=Programador Musical
BACKEND_CORS_ORIGINS=["https://yourdomain.com"]
```

**Frontend Configuration:**
```bash
NODE_ENV=production
NEXT_PUBLIC_API_URL=https://yourdomain.com/api
```

### Security Configuration

**Database Security:**
- Encrypted at rest (RDS encryption)
- Private subnet placement
- Security group restrictions
- Strong password generation

**Application Security:**
- HTTPS enforcement
- CORS configuration
- JWT token authentication
- Security headers (CSP, HSTS, etc.)
- Rate limiting

**Network Security:**
- VPC isolation
- Private subnets for application/database
- Security groups with least privilege
- WAF protection (optional)

### Monitoring and Logging

**CloudWatch Integration:**
- Application logs from all containers
- Infrastructure metrics (CPU, memory, network)
- Custom application metrics
- Automated alerting

**Health Checks:**
- Load balancer health checks
- Container health checks
- Database connectivity checks
- Application-level health endpoints

## Troubleshooting

### Common Issues

1. **Docker Build Failures**
   ```bash
   # Clear Docker cache
   docker system prune -a
   
   # Rebuild without cache
   docker-compose build --no-cache
   ```

2. **AWS Permission Errors**
   ```bash
   # Verify AWS credentials
   aws sts get-caller-identity
   
   # Check IAM permissions in AWS Console
   ```

3. **Database Connection Issues**
   ```bash
   # Check database logs
   docker-compose logs db
   
   # Verify connection string
   echo $DATABASE_URL
   ```

4. **SSL Certificate Issues**
   ```bash
   # For local deployment, regenerate certificates
   ./scripts/deploy.sh ssl
   
   # For AWS, check ACM certificate status
   aws acm list-certificates
   ```

### Debugging Commands

**Local Deployment:**
```bash
# View all service logs
docker-compose logs -f

# Check service health
docker-compose ps

# Access database
docker-compose exec db psql -U postgres -d programador_musical
```

**AWS Deployment:**
```bash
# Check ECS service status
aws ecs describe-services --cluster programador-musical-production-cluster --services programador-musical-production-app

# View application logs
aws logs tail /ecs/programador-musical-production/backend --follow

# Check load balancer health
aws elbv2 describe-target-health --target-group-arn <target-group-arn>
```

## Maintenance

### Updates and Deployments

**Code Updates:**
```bash
# AWS deployment
./aws/deploy-to-aws.sh update

# Local deployment
./scripts/deploy.sh deploy
```

**Database Backups:**
```bash
# Local backup
./scripts/deploy.sh backup

# AWS RDS has automated backups enabled
```

**Scaling:**
```bash
# Scale ECS service
aws ecs update-service --cluster <cluster> --service <service> --desired-count 3
```

### Monitoring

**Key Metrics to Monitor:**
- Application response times
- Error rates
- Database connections
- CPU and memory usage
- Disk space utilization

**Alerting Setup:**
- CloudWatch alarms for critical metrics
- SNS notifications for alerts
- PagerDuty integration for 24/7 monitoring

## Security Best Practices

1. **Secrets Management**
   - Use AWS SSM Parameter Store or Secrets Manager
   - Never commit secrets to version control
   - Rotate secrets regularly

2. **Network Security**
   - Use private subnets for application and database
   - Implement security groups with least privilege
   - Enable VPC Flow Logs

3. **Application Security**
   - Keep dependencies updated
   - Implement proper authentication and authorization
   - Use HTTPS everywhere
   - Validate all inputs

4. **Monitoring and Auditing**
   - Enable CloudTrail for API auditing
   - Monitor application logs for security events
   - Set up alerts for suspicious activities

## Cost Optimization

1. **Right-sizing Resources**
   - Start with smaller instances (t3.micro)
   - Monitor usage and scale as needed
   - Use auto-scaling to handle traffic spikes

2. **Reserved Instances**
   - Purchase reserved instances for predictable workloads
   - Consider Savings Plans for flexible usage

3. **Storage Optimization**
   - Use GP2 storage for cost-effectiveness
   - Enable storage auto-scaling
   - Regular cleanup of old logs and backups

4. **Development Environments**
   - Use smaller instances for staging
   - Schedule start/stop for non-production environments
   - Use spot instances where appropriate

## Support and Resources

- **AWS Documentation**: [ECS User Guide](https://docs.aws.amazon.com/ecs/)
- **Terraform Documentation**: [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- **Docker Documentation**: [Docker Compose](https://docs.docker.com/compose/)
- **Application Logs**: Check CloudWatch or local Docker logs
- **Infrastructure Issues**: Review Terraform state and AWS Console