# Security Configuration Guide

## 🔒 IP Address Restriction

Your application is now configured to be accessible only from your IP address for maximum security.

---

## Quick Setup

### 1. Auto-Configure Your IP
```bash
# Automatically detect and set your current IP
./aws/get-my-ip.sh update
```

### 2. Deploy with IP Restriction
```bash
# Deploy with automatic IP configuration
./aws/deploy-to-aws.sh deploy
```

---

## Manual IP Management

### Check Your Current IP
```bash
# Show your current public IP
./aws/get-my-ip.sh get-ip

# Show current configuration
./aws/get-my-ip.sh show
```

### Add Additional IPs
```bash
# Add office IP
./aws/get-my-ip.sh add-ip 203.0.113.1

# Add home IP  
./aws/get-my-ip.sh add-ip 198.51.100.1
```

### Remove IPs
```bash
# Remove an IP from allowed list
./aws/get-my-ip.sh remove-ip 203.0.113.1
```

---

## Security Architecture

### Network Security Layers

```
Internet → ALB Security Group (Your IP Only) → ECS Security Group → RDS Security Group
```

#### 1. **Application Load Balancer Security Group**
- **Inbound:** Only your IP addresses on ports 80/443
- **Outbound:** All traffic to ECS tasks

#### 2. **ECS Security Group**  
- **Inbound:** Only from ALB security group
- **Outbound:** All traffic (for updates, ECR access)

#### 3. **RDS Security Group**
- **Inbound:** Only from ECS security group on port 5432
- **Outbound:** None (database doesn't need outbound)

### IP Restriction Configuration

In `terraform.tfvars`:
```hcl
# Enable IP restriction
restrict_to_ip = true

# Your allowed IP addresses (CIDR format)
allowed_ip_addresses = ["YOUR_IP/32"]

# Multiple IPs example:
# allowed_ip_addresses = ["203.0.113.1/32", "198.51.100.1/32"]
```

---

## Security Features

### ✅ **Network Isolation**
- **VPC:** Isolated network environment
- **Private Subnets:** Database and application in private networks
- **Security Groups:** Firewall rules at instance level
- **NACLs:** Additional network-level protection

### ✅ **Access Control**
- **IP Whitelisting:** Only your IP can access the application
- **IAM Roles:** Least privilege access for AWS services
- **No SSH Access:** Containers are immutable and secure

### ✅ **Data Protection**
- **Encryption at Rest:** RDS database encrypted
- **Encryption in Transit:** HTTPS/TLS everywhere
- **Secrets Management:** AWS Secrets Manager for sensitive data
- **No Hardcoded Secrets:** All secrets injected at runtime

### ✅ **Application Security**
- **HTTPS Only:** HTTP redirects to HTTPS
- **Security Headers:** CSP, HSTS, X-Frame-Options, etc.
- **JWT Authentication:** Secure token-based auth
- **Input Validation:** All inputs validated and sanitized

---

## Common Scenarios

### Working from Different Locations

#### Option 1: Update IP When Location Changes
```bash
# When you change location, update your IP
./aws/get-my-ip.sh update
terraform apply  # Apply the change
```

#### Option 2: Pre-configure Multiple IPs
```bash
# Add all your common IPs
./aws/get-my-ip.sh add-ip 203.0.113.1  # Office
./aws/get-my-ip.sh add-ip 198.51.100.1  # Home
./aws/get-my-ip.sh add-ip 192.0.2.1     # Coworking space
```

### Team Access

#### Add Team Member IPs
```bash
# Add team member IPs
./aws/get-my-ip.sh add-ip 203.0.113.10  # Team member 1
./aws/get-my-ip.sh add-ip 203.0.113.11  # Team member 2
```

#### VPN Access (Recommended for Teams)
```hcl
# In terraform.tfvars, allow VPN subnet
allowed_ip_addresses = ["10.0.0.0/16"]  # VPN network
```

---

## Monitoring and Alerts

### Access Monitoring

The infrastructure logs all access attempts:

```bash
# View ALB access logs
aws logs filter-log-events \
  --log-group-name /aws/applicationloadbalancer/programador-musical \
  --start-time $(date -d '1 hour ago' +%s)000

# View security group changes
aws logs filter-log-events \
  --log-group-name CloudTrail \
  --filter-pattern "{ $.eventName = AuthorizeSecurityGroupIngress || $.eventName = RevokeSecurityGroupIngress }"
```

### Failed Access Alerts

Set up CloudWatch alarms for unauthorized access:

```bash
# Create alarm for 4xx errors (blocked requests)
aws cloudwatch put-metric-alarm \
  --alarm-name "Unauthorized-Access-Attempts" \
  --alarm-description "Alert on blocked access attempts" \
  --metric-name "HTTPCode_Target_4XX_Count" \
  --namespace "AWS/ApplicationELB" \
  --statistic "Sum" \
  --period 300 \
  --threshold 10 \
  --comparison-operator "GreaterThanThreshold"
```

---

## Emergency Access

### Temporary Access for Support

If you need to grant temporary access:

```bash
# Add temporary IP
./aws/get-my-ip.sh add-ip 203.0.113.100

# Deploy the change
cd aws/terraform && terraform apply

# Remove after support session
./aws/get-my-ip.sh remove-ip 203.0.113.100
cd aws/terraform && terraform apply
```

### Lost Access Recovery

If you lose access (IP changed and you can't connect):

1. **AWS Console Access:**
   - Log into AWS Console
   - Go to EC2 → Security Groups
   - Find `programador-musical-production-alb-*`
   - Edit inbound rules to add your new IP

2. **AWS CLI Access:**
   ```bash
   # Get your new IP
   curl https://api.ipify.org
   
   # Update security group directly
   aws ec2 authorize-security-group-ingress \
     --group-id sg-xxxxxxxxx \
     --protocol tcp \
     --port 443 \
     --cidr YOUR_NEW_IP/32
   ```

---

## Advanced Security Options

### WAF Integration (Optional)

For additional protection, you can add AWS WAF:

```hcl
# In terraform (additional cost ~$5/month)
resource "aws_wafv2_web_acl" "main" {
  name  = "${local.name_prefix}-waf"
  scope = "REGIONAL"
  
  default_action {
    allow {}
  }
  
  rule {
    name     = "RateLimitRule"
    priority = 1
    
    action {
      block {}
    }
    
    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }
  }
}
```

### VPN Setup (Recommended for Teams)

For team access, consider setting up a VPN:

1. **AWS Client VPN** (~$22/month)
2. **Third-party VPN** (WireGuard, OpenVPN)
3. **Corporate VPN** integration

---

## Security Checklist

### ✅ **Before Deployment**
- [ ] IP addresses configured in terraform.tfvars
- [ ] Strong database password set
- [ ] JWT secret key is secure (32+ characters)
- [ ] Domain SSL certificate configured (if using custom domain)

### ✅ **After Deployment**
- [ ] Test access from your IP works
- [ ] Test access from other IPs is blocked
- [ ] Verify HTTPS redirect works
- [ ] Check security headers are present
- [ ] Monitor CloudWatch for access attempts

### ✅ **Ongoing Maintenance**
- [ ] Update IP addresses when location changes
- [ ] Rotate secrets monthly
- [ ] Review access logs weekly
- [ ] Update dependencies regularly
- [ ] Monitor security alerts

---

## Troubleshooting

### Can't Access Application

1. **Check Your Current IP:**
   ```bash
   ./aws/get-my-ip.sh get-ip
   ```

2. **Check Configured IPs:**
   ```bash
   ./aws/get-my-ip.sh show
   ```

3. **Update IP if Changed:**
   ```bash
   ./aws/get-my-ip.sh update
   cd aws/terraform && terraform apply
   ```

### Security Group Issues

```bash
# List security groups
aws ec2 describe-security-groups \
  --filters "Name=group-name,Values=*programador-musical*"

# Check specific security group rules
aws ec2 describe-security-groups \
  --group-ids sg-xxxxxxxxx
```

### SSL Certificate Issues

```bash
# Check certificate status
aws acm list-certificates

# Check certificate validation
aws acm describe-certificate --certificate-arn arn:aws:acm:...
```

---

## Cost Impact

IP restriction adds **$0** to your monthly costs - it's a free security feature!

The security configuration provides enterprise-level protection while maintaining the cost-optimized infrastructure at **$28-35/month**.

---

## Best Practices Summary

1. **Always use IP restriction** for sensitive applications
2. **Regularly update IP addresses** when location changes  
3. **Monitor access logs** for suspicious activity
4. **Use strong, unique passwords** for all services
5. **Rotate secrets regularly** (monthly recommended)
6. **Keep dependencies updated** for security patches
7. **Use HTTPS everywhere** - never allow HTTP in production
8. **Implement proper authentication** in your application
9. **Regular security reviews** of AWS resources
10. **Backup and disaster recovery** planning