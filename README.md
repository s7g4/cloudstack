# CloudStack Demo: Production-Ready AWS Environment

## Project Summary
**CloudStack Demo** demonstrates a production-grade AWS environment built entirely with Terraform. This project goes beyond basic scaffolding to deliver a secure, observable, and highly available infrastructure.

It features a custom **VPC** with **Public/Private subnet isolation**, an **Auto Scaling Group** of web servers behind an **Application Load Balancer**, and a full **Observability** suite using CloudWatch Logs, Alarms, and **VPC Flow Logs**.

## Architecture

```mermaid
graph TB
subgraph AWS [AWS Cloud]
        subgraph VPC [VPC 10.0.0.0/16]
            IGW((Internet Gateway))
            
            subgraph Public [Public Subnet]
                WAF[AWS WAF]
                ALB[Application Load Balancer]
                NAT[NAT Instance]
                ASG[Auto Scaling Group (Web Servers)]
            end
            
            subgraph Private [Private Subnet]
                DB[(RDS PostgreSQL)]
                Cache[(ElastiCache Redis)]
            end
        end
        
        CF[CloudFront CDN]
        CW[CloudWatch Observability]
        SM[Secrets Manager]
        KMS[KMS Encryption]
        Backup[AWS Backup]
    end
    
    User -->|HTTPS| CF
    CF -->|HTTPS| WAF
    WAF --> ALB
    ALB -->|HTTP| ASG
    ASG -->|Outbound| NAT
    ASG -->|SQL| DB
    ASG -->|Redis| Cache
    
    ASG -.->|Metrics/Logs| CW
    DB -.->|Encrypt| KMS
    DB -.->|Store Creds| SM
    DB -.->|Replicate| Backup
```

---

## Production Deployment Guide

### 1. Prerequisites
-   **GitHub Account**: For hosting the repo and running Actions.
-   **AWS Account**: Admin access to create IAM Users.
-   **Terraform CLI** (Optional): Only needed for local development.

### 2. Secrets Configuration (Critical)
To deploy this via the included CI/CD pipeline, go to your GitHub Repo -> **Settings** -> **Secrets and variables** -> **Actions** and add:

| Secret Name | Description | Example Value |
|:--- |:--- |:--- |
| `AWS_ACCESS_KEY_ID` | CI User Access Key | `AKIA...` |
| `AWS_SECRET_ACCESS_KEY` | CI User Secret Key | `wJalr...` |
| `INFRACOST_API_KEY` | (Optional) For Cost Est. | `ico-...` |
| `TF_VAR_db_password` | **Production DB Password** | `SuperSecureP@ssw0rd!` |

> [!WARNING]
> Never commit `terraform.tfvars` containing real passwords to Git!

### 3. Deploying
1.  **Push to `main`**: The GitHub Action will automatically Trigger.
2.  **Review Plan**: The Action will post a comment with the Terraform Plan and Cost Estimate.
3.  **Apply**: On successful merge/push to `main`, Terraform will provision:
    -   VPC & Networking
    -   KMS Keys
    -   RDS Database (takes ~10 mins)
    -   ASG & ALB

### 4. Production Readiness Checklist
Before going live with real traffic, ensure you have tuned these variables in `terraform/modules/...`:

- [ ] **Multi-AZ Database**: Set `multi_az = true` in `modules/database/main.tf` for failover.
- [ ] **Instance Types**: Upgrade `instance_type` in `modules/compute` and `database` (e.g., `t3.medium`).
- [ ] **Remote State**: Uncomment the `backend "s3"` block in `terraform/backend.tf` to store state securely.
- [ ] **HTTPS**: Add an `aws_acm_certificate` to the ALB listener for SSL/TLS.

---

## Verification
Once deployed, verify the system:
1.  **Web Access**: Visit the `web_alb_url` output.
2.  **Dashboard**: Check the created **CloudWatch Dashboard** for real-time CPU and Request metrics.
3.  **Database**: Connect to the RDS endpoint from an EC2 instance to verify connectivity.
