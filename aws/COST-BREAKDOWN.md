# AWS Cost Breakdown - Programador Musical

## Monthly Cost Estimate (US East-1)

### 💰 **Total Estimated Cost: $65-85 USD/month**

---

## Detailed Cost Breakdown

### 🖥️ **Compute Services**

#### ECS Fargate
- **Configuration:** 1 task, 1 vCPU, 2GB RAM
- **Running 24/7:** 730 hours/month
- **Cost:** 730 × ($0.04048/vCPU-hour + $0.004445/GB-hour × 2)
- **Monthly Cost:** ~$36/month

#### Auto Scaling (Peak Usage)
- **Additional tasks during peak:** 2 extra tasks × 4 hours/day × 30 days = 240 hours
- **Peak Cost:** 240 × ($0.04048 + $0.004445 × 2) = ~$12/month
- **Average Monthly Cost:** ~$48/month

---

### 🗄️ **Database Services**

#### RDS PostgreSQL (db.t3.micro)
- **Instance:** db.t3.micro (1 vCPU, 1GB RAM)
- **Storage:** 20GB GP2 SSD
- **Backup Storage:** ~5GB (3-day retention)
- **Costs:**
  - Instance: $0.017/hour × 730 hours = ~$12.40/month
  - Storage: 20GB × $0.115/GB = ~$2.30/month
  - Backup: 5GB × $0.095/GB = ~$0.48/month
- **Total RDS Cost:** ~$15/month

---

### 🌐 **Networking Services**

#### Application Load Balancer (ALB)
- **Base Cost:** $0.0225/hour × 730 hours = ~$16.40/month
- **Load Balancer Capacity Units (LCU):** ~$2/month (low traffic)
- **Total ALB Cost:** ~$18/month

#### Data Transfer
- **Outbound Data:** 10GB/month × $0.09/GB = ~$0.90/month
- **Inbound Data:** Free
- **Inter-AZ Transfer:** 5GB/month × $0.01/GB = ~$0.05/month
- **Total Data Transfer:** ~$1/month

#### NAT Gateway
- **3 NAT Gateways:** $0.045/hour × 3 × 730 hours = ~$98/month
- **Data Processing:** 10GB × $0.045/GB = ~$0.45/month
- **Total NAT Gateway:** ~$98/month

> ⚠️ **Cost Optimization:** NAT Gateways are expensive! Consider using 1 NAT Gateway instead of 3 to save ~$65/month

---

### 🐳 **Container Registry**

#### Elastic Container Registry (ECR)
- **Storage:** 3 repositories × 2GB average = 6GB
- **Cost:** 6GB × $0.10/GB = ~$0.60/month
- **Data Transfer:** Included in compute costs
- **Total ECR Cost:** ~$1/month

---

### 🔐 **Security & Secrets**

#### Secrets Manager
- **2 Secrets:** $0.40/secret/month × 2 = ~$0.80/month
- **API Calls:** ~1,000 calls/month = ~$0.01/month
- **Total Secrets Manager:** ~$1/month

#### Certificate Manager (ACM)
- **SSL Certificates:** Free for AWS services
- **Cost:** $0/month

---

### 📊 **Monitoring & Logging**

#### CloudWatch
- **Log Ingestion:** 5GB/month × $0.50/GB = ~$2.50/month
- **Log Storage:** 5GB × $0.03/GB = ~$0.15/month
- **Metrics:** 50 custom metrics × $0.30/metric = ~$15/month
- **Alarms:** 10 alarms × $0.10/alarm = ~$1/month
- **Total CloudWatch:** ~$19/month

---

### 🌍 **DNS & Domain**

#### Route 53 (if using custom domain)
- **Hosted Zone:** $0.50/month
- **DNS Queries:** 1M queries × $0.40/1M = ~$0.40/month
- **Total Route 53:** ~$1/month (optional)

---

## Cost Optimization Strategies

### 🎯 **Immediate Savings (Reduce to ~$45/month)**

1. **Use Single NAT Gateway**
   ```hcl
   # In terraform/vpc.tf, change:
   count = 1  # Instead of length(local.azs)
   ```
   **Savings:** ~$65/month

2. **Reduce CloudWatch Metrics**
   - Disable detailed monitoring
   - Use fewer custom metrics
   **Savings:** ~$10/month

3. **Optimize Log Retention**
   ```hcl
   retention_in_days = 3  # Instead of 7
   ```
   **Savings:** ~$1/month

### 💡 **Medium-term Optimizations**

1. **Reserved Instances (after 3-6 months)**
   - RDS Reserved Instance: 40% savings = ~$6/month savings
   - Total with RI: ~$39/month

2. **Spot Instances for ECS**
   - Already configured in Terraform
   - Potential 70% savings on compute: ~$34/month savings

3. **CloudFront CDN (for high traffic)**
   - Add when traffic justifies cost
   - Can reduce ALB costs

### 🏆 **Optimized Configuration Cost: ~$35-45/month**

---

## Free Tier Benefits (First 12 months)

If you're on AWS Free Tier:

- **RDS:** 750 hours db.t3.micro = FREE
- **ECS Fargate:** Some compute credits
- **CloudWatch:** 10 custom metrics FREE
- **Data Transfer:** 1GB outbound FREE

**First Year Cost:** ~$25-35/month

---

## Cost by Environment

### Development/Staging
- **Smaller instances:** db.t3.micro, 0.25 vCPU Fargate
- **Single AZ:** No Multi-AZ RDS
- **Scheduled shutdown:** Stop during nights/weekends
- **Estimated Cost:** ~$15-25/month

### Production (Current Config)
- **High Availability:** Multi-AZ setup
- **Auto Scaling:** Handle traffic spikes
- **Full Monitoring:** Complete observability
- **Estimated Cost:** ~$65-85/month

---

## Traffic-Based Scaling

### Low Traffic (< 1,000 requests/day)
- **Current config is sufficient**
- **Cost:** ~$65/month

### Medium Traffic (10,000 requests/day)
- **Scale to 2-3 ECS tasks**
- **Larger RDS instance (db.t3.small)**
- **Cost:** ~$85-110/month

### High Traffic (100,000+ requests/day)
- **Scale to 5-10 ECS tasks**
- **RDS db.t3.medium or larger**
- **Add CloudFront CDN**
- **Cost:** ~$150-250/month

---

## Cost Monitoring Setup

### CloudWatch Billing Alarms

```bash
# Set up billing alarm for $100/month
aws cloudwatch put-metric-alarm \
  --alarm-name "Monthly-Billing-Alarm" \
  --alarm-description "Alert when monthly bill exceeds $100" \
  --metric-name "EstimatedCharges" \
  --namespace "AWS/Billing" \
  --statistic "Maximum" \
  --period 86400 \
  --threshold 100 \
  --comparison-operator "GreaterThanThreshold" \
  --dimensions Name=Currency,Value=USD
```

### Cost Explorer Tags

All resources are tagged for cost tracking:
- `Project: programador-musical`
- `Environment: production`
- `ManagedBy: terraform`

---

## Recommendations

### 🚀 **Start Small**
1. Deploy with optimized config (~$45/month)
2. Monitor usage for 2-3 months
3. Scale up based on actual needs

### 📈 **Scale Gradually**
1. Start with 1 NAT Gateway
2. Add more as traffic grows
3. Use Reserved Instances after usage patterns are clear

### 💰 **Budget Planning**
- **Minimum:** $35/month (optimized)
- **Recommended:** $50/month (balanced)
- **Maximum:** $85/month (full HA setup)

### 🔍 **Monthly Review**
- Check AWS Cost Explorer
- Review CloudWatch metrics
- Optimize unused resources
- Consider Reserved Instances

---

## Alternative Architectures

### Serverless Option (Lambda + RDS Serverless)
- **Cost:** ~$20-40/month
- **Pros:** Pay per use, auto-scaling
- **Cons:** Cold starts, complexity

### Container on EC2 (instead of Fargate)
- **Cost:** ~$40-60/month
- **Pros:** Lower compute costs
- **Cons:** More management overhead

### Managed Services (RDS + Elastic Beanstalk)
- **Cost:** ~$50-70/month
- **Pros:** Less configuration
- **Cons:** Less control, vendor lock-in