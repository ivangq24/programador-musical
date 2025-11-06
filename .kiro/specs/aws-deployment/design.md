# AWS Deployment Design Document

## Overview

This design document outlines the architecture and implementation strategy for deploying the Programador Musical radio programming system to AWS. The solution transforms the current Docker Compose development setup into a production-ready, scalable, and secure cloud infrastructure using AWS managed services.

The deployment will use a containerized approach with AWS ECS Fargate for orchestration, RDS for managed PostgreSQL, Application Load Balancer for traffic distribution, and CloudFront for content delivery. The architecture emphasizes security, scalability, cost optimization, and operational excellence.

## Architecture

### High-Level Architecture

```mermaid
graph TB
    subgraph "Internet"
        U[Users]
    end
    
    subgraph "AWS Cloud"
        subgraph "Route 53"
            DNS[DNS Management]
        end
        
        subgraph "CloudFront CDN"
            CF[Global Edge Locations]
        end
        
        subgraph "AWS Certificate Manager"
            SSL[SSL Certificates]
        end
        
        subgraph "Application Load Balancer"
            ALB[ALB with WAF]
        end
        
        subgraph "VPC - Public Subnets"
            ALB
        end
        
        subgraph "VPC - Private Subnets"
            subgraph "ECS Cluster (EC2 + Spot)"
                EC2[t3.small Instances]
                TASK[All-in-One Tasks<br/>Frontend + Backend + Nginx]
            end
        end
        
        subgraph "VPC - Database Subnets"
            RDS[(RDS PostgreSQL)]
        end
        
        subgraph "ECR"
            ECR[Container Registry]
        end
        
        subgraph "Secrets Manager"
            SM[Application Secrets]
        end
        
        subgraph "CloudWatch"
            CW[Monitoring & Logs]
        end
        
        subgraph "S3"
            S3[Static Assets & Backups]
        end
    end
    
    U --> DNS
    DNS --> CF
    CF --> ALB
    ALB --> NG
    NG --> FE
    NG --> BE
    BE --> RDS
    
    ECR --> FE
    ECR --> BE
    ECR --> NG
    
    SM --> BE
    SM --> FE
    
    CW --> FE
    CW --> BE
    CW --> NG
    CW --> RDS
```

### Network Architecture

**VPC Configuration:**
- **CIDR Block:** 10.0.0.0/16
- **Availability Zones:** 3 AZs for high availability
- **Public Subnets:** 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24 (ALB, NAT Gateways)
- **Private Subnets:** 10.0.11.0/24, 10.0.12.0/24, 10.0.13.0/24 (ECS Tasks)
- **Database Subnets:** 10.0.21.0/24, 10.0.22.0/24, 10.0.23.0/24 (RDS)

**Security Groups:**
- **ALB Security Group:** Allow HTTP/HTTPS from 0.0.0.0/0
- **ECS Security Group:** Allow traffic from ALB only
- **RDS Security Group:** Allow PostgreSQL (5432) from ECS only

## Components and Interfaces

### 1. Container Registry (ECR)

**Purpose:** Store and manage Docker images for all application components.

**Repositories:**
- `programador-musical/frontend`: Next.js production builds
- `programador-musical/backend`: FastAPI application
- `programador-musical/nginx`: Reverse proxy configuration

**Image Lifecycle:**
- Automatic vulnerability scanning enabled
- Image retention policy: Keep last 10 images
- Cross-region replication for disaster recovery

### 2. Container Orchestration (ECS with EC2)

**Cluster Configuration:**
- **Name:** programador-musical-cluster
- **Capacity Provider:** EC2 with Spot Instances (70%) + On-Demand (30%)
- **Instance Types:** t3.small, t3.medium (burstable performance)
- **Auto Scaling Group:** 1-3 instances based on demand

**Cost Optimization Strategy:**
- **Spot Instances:** Up to 70% cost savings for non-critical workloads
- **Mixed Instance Policy:** Combine spot and on-demand for reliability
- **Instance Scheduling:** Scale down during low-usage hours (nights/weekends)

**Services:**

**All-in-One Service (Cost Optimized):**
- **Task Definition:** 0.5 vCPU, 1GB RAM per container
- **Containers per Task:** Frontend + Backend + Nginx in single task
- **Desired Count:** 1 (minimum), 3 (maximum)
- **Auto Scaling:** Target CPU 80%, Memory 85%
- **Health Check:** HTTP GET /health on nginx port 80

### 3. Database Service (RDS - Cost Optimized)

**Configuration:**
- **Engine:** PostgreSQL 15.4
- **Instance Class:** db.t3.micro (start small, scale as needed)
- **Multi-AZ:** Disabled initially (can enable later if needed)
- **Storage:** 20GB GP2 with auto-scaling up to 100GB
- **Backup:** 3-day retention, daily automated backups
- **Maintenance Window:** Sunday 03:00-04:00 UTC
- **Encryption:** At rest enabled (required for production)

**Cost Optimization:**
- **Reserved Instance:** 1-year term for 40% savings after validation
- **Storage Optimization:** Start with minimal storage, auto-scale as needed
- **Connection Management:** Application-level pooling (no RDS Proxy initially)

### 4. Load Balancer (Cost Optimized)

**Application Load Balancer:**
- **Scheme:** Internet-facing
- **Listeners:** HTTP (80) → HTTPS redirect, HTTPS (443)
- **Target Groups:** 
  - ECS tasks (nginx containers)
  - Health check: /health every 30 seconds
- **Sticky Sessions:** Disabled for stateless design

**CDN Strategy (Phase 2):**
- **Initial:** Direct ALB access (no CloudFront initially)
- **Future:** Add CloudFront when traffic justifies the cost
- **Static Assets:** Serve from Next.js built-in optimization
- **Caching:** Leverage browser caching with proper headers

### 5. Secrets Management (Cost Optimized)

**AWS Systems Manager Parameter Store:**
- **Database Credentials:** SecureString parameters (free tier)
- **JWT Secret Key:** SecureString parameter
- **Environment Variables:** Standard parameters for non-sensitive config
- **Cost:** Free for up to 10,000 parameters

**Parameter Structure:**
```
/programador-musical/prod/database/host
/programador-musical/prod/database/username
/programador-musical/prod/database/password (SecureString)
/programador-musical/prod/app/secret-key (SecureString)
/programador-musical/prod/app/cors-origins
```

**Migration Path:** Can upgrade to Secrets Manager later if auto-rotation is needed

### 6. Monitoring and Logging

**CloudWatch Configuration:**
- **Log Groups:**
  - `/ecs/programador-musical/frontend`
  - `/ecs/programador-musical/backend`
  - `/ecs/programador-musical/nginx`
  - `/aws/rds/instance/programador-musical/postgresql`

**Metrics and Alarms:**
- **ECS Service CPU/Memory:** > 80% for 5 minutes
- **ALB Response Time:** > 2 seconds average
- **RDS CPU/Connections:** > 80% utilization
- **Error Rate:** > 5% for 3 consecutive periods

**Dashboard:**
- Application performance metrics
- Infrastructure health status
- Cost optimization insights

## Data Models

### Environment Configuration

**Production Environment Variables:**
```bash
# Backend Configuration
DATABASE_URL=postgresql://username:password@rds-endpoint:5432/programador_musical
SECRET_KEY=${SECRET_FROM_SECRETS_MANAGER}
ACCESS_TOKEN_EXPIRE_MINUTES=60
API_V1_STR=/api/v1
PROJECT_NAME=Programador Musical
BACKEND_CORS_ORIGINS=["https://yourdomain.com"]
ENVIRONMENT=production

# Frontend Configuration
NEXT_PUBLIC_API_URL=https://yourdomain.com/api
NODE_ENV=production
NEXT_TELEMETRY_DISABLED=1
```

**Infrastructure as Code Structure:**
```
infrastructure/
├── terraform/
│   ├── modules/
│   │   ├── vpc/
│   │   ├── ecs/
│   │   ├── rds/
│   │   ├── alb/
│   │   └── cloudfront/
│   ├── environments/
│   │   ├── staging/
│   │   └── production/
│   └── main.tf
└── docker/
    ├── frontend/
    │   └── Dockerfile.prod
    ├── backend/
    │   └── Dockerfile.prod
    └── nginx/
        └── Dockerfile.prod
```

## Error Handling

### Application Level

**Backend Error Handling:**
- Structured logging with correlation IDs
- Graceful database connection failures
- Circuit breaker pattern for external services
- Health check endpoints with dependency validation

**Frontend Error Handling:**
- Error boundaries for React components
- Retry logic for API calls
- Offline capability with service workers
- User-friendly error messages

### Infrastructure Level

**Auto-Recovery Mechanisms:**
- ECS service auto-restart for failed tasks
- ALB health checks with automatic target removal
- RDS automated failover in Multi-AZ setup
- CloudWatch alarms triggering auto-scaling

**Backup and Disaster Recovery:**
- RDS automated backups with point-in-time recovery
- ECR cross-region image replication
- Infrastructure code in version control
- Database migration scripts versioned

### Monitoring and Alerting

**Alert Escalation:**
1. **Warning Level:** CloudWatch → SNS → Email
2. **Critical Level:** CloudWatch → SNS → Email + SMS
3. **Emergency Level:** PagerDuty integration for 24/7 response

**Runbook Integration:**
- Automated remediation for common issues
- Step-by-step troubleshooting guides
- Contact information for escalation

## Testing Strategy

### Pre-Deployment Testing

**Container Testing:**
- Multi-stage Docker builds with test stages
- Security vulnerability scanning with Trivy
- Image size optimization validation
- Container startup time benchmarks

**Infrastructure Testing:**
- Terraform plan validation in CI/CD
- Infrastructure compliance scanning
- Cost estimation for resource changes
- Security policy validation

### Post-Deployment Testing

**Health Validation:**
- Automated smoke tests after deployment
- End-to-end API testing with Newman/Postman
- Frontend functionality testing with Playwright
- Database connectivity and performance tests

**Performance Testing:**
- Load testing with Artillery or k6
- Database performance benchmarking
- CDN cache hit ratio validation
- Auto-scaling behavior verification

### Continuous Monitoring

**Application Performance:**
- Real User Monitoring (RUM) with CloudWatch
- Synthetic monitoring for critical user journeys
- API response time and error rate tracking
- Database query performance analysis

**Infrastructure Monitoring:**
- Resource utilization trending
- Cost optimization opportunities
- Security compliance monitoring
- Capacity planning based on growth patterns

## Security Considerations

### Network Security

**Defense in Depth:**
- WAF rules for common attack patterns
- VPC Flow Logs for network monitoring
- Security Groups with least privilege access
- NACLs as additional network layer protection

**Data Protection:**
- Encryption at rest for RDS and EBS volumes
- Encryption in transit with TLS 1.2+
- Secrets rotation automation
- Database access auditing

### Application Security

**Authentication and Authorization:**
- JWT token validation with short expiration
- Role-based access control (RBAC)
- API rate limiting and throttling
- Input validation and sanitization

**Compliance:**
- GDPR compliance for user data handling
- SOC 2 Type II controls implementation
- Regular security assessments
- Vulnerability management program

## Cost Optimization

### Estimated Monthly Costs (US East-1)

**Compute (ECS + EC2):**
- 1x t3.small (Spot): ~$7/month
- 1x t3.small (On-Demand backup): ~$15/month
- **Total Compute:** ~$22/month

**Database (RDS):**
- db.t3.micro PostgreSQL: ~$13/month
- 20GB GP2 storage: ~$2/month
- **Total Database:** ~$15/month

**Networking:**
- Application Load Balancer: ~$16/month
- Data transfer (estimated): ~$5/month
- **Total Networking:** ~$21/month

**Other Services:**
- ECR storage: ~$1/month
- CloudWatch logs: ~$2/month
- Parameter Store: Free
- **Total Other:** ~$3/month

**Total Estimated Cost:** ~$61/month

### Cost Optimization Strategies

**Immediate Savings:**
- Spot instances for 70% compute cost reduction
- Parameter Store instead of Secrets Manager
- Single-AZ RDS (can upgrade later)
- No CloudFront initially

**Future Optimizations:**
- Reserved Instances after 3-6 months of stable usage
- CloudFront when traffic justifies CDN costs
- Multi-AZ RDS when high availability is critical
- Larger instances with better price/performance ratio

### Operational Efficiency

**Automation:**
- Infrastructure provisioning with Terraform
- CI/CD pipeline for deployments
- Automated backup and maintenance tasks
- Self-healing infrastructure patterns

**Development Workflow:**
- Feature branch deployments to staging
- Blue-green deployment strategy
- Rollback capabilities within 5 minutes
- Database migration automation