# CloudStack Demo: Architecture & Design

## 1. Architecture Overview & Network Flow
This high-level design demonstrates a secure, multi-tier network topology.

```mermaid
graph TB
    subgraph AWS Cloud
        subgraph VPC [VPC 10.0.0.0/16]
            IGW((Internet Gateway))
            
            subgraph Public Subnet [Public Subnet 10.0.1.0/24]
                NAT[NAT Instance]
                EC2[EC2 Web Server]
                SG[Security Group]
            end
            
            subgraph Private Subnet [Private Subnet 10.0.2.0/24]
                DB[(RDS / Database - Future)]
            end
        end
        
        CloudWatch[CloudWatch Logs & Metrics]
        SSM[SSM Systems Manager]
    end
    
    User[Users] -->|HTTP:80| IGW
    IGW -->|Route Table| EC2
    EC2 -->|Outbound Patching| NAT
    NAT -->|Route Table| IGW
    
    Admin[Admin] -.->|Session Manager| SSM
    SSM -.->|Secure Tunnel| EC2
    
    EC2 -.->|Metrics/Logs| CloudWatch
```

---

## 2. CloudWatch Observability Workflow
Flow of identifying, logging, and alerting on system events.

```mermaid
sequenceDiagram
    participant EC2 as EC2 Instance
    participant CWA as CloudWatch Agent
    participant CWL as CloudWatch Logs
    participant CWM as CloudWatch Metrics
    participant Alarm as CloudWatch Alarm
    participant SNS as SNS Topic
    participant Email as Admin Email

    Note over EC2, CWA: Application Running
    EC2->>CWA: Write App Logs / CPU Stats
    CWA->>CWL: Push Log Streams
    CWA->>CWM: Push Custom Metrics (Mem/Disk)
    
    CWM->>Alarm: Check Threshold (CPU > 80%)
    
    alt Threshold Breached
        Alarm->>SNS: Trigger "High CPU" Event
        SNS->>Email: Send Notification
    end
```

---

## 3. SSM + IAM Role Architecture
We replace SSH keys with IAM-based authentication for improved security.

### How it works:
1.  **IAM Role**: Created with `AmazonSSMManagedInstanceCore` and `CloudWatchAgentServerPolicy`.
2.  **Instance Profile**: Attached to the EC2 instance at launch.
3.  **SSM Agent**: Pre-installed on Amazon Linux 2 / Ubuntu, authenticates using the IAM Role.
4.  **Access**: Admin uses AWS Console or AWS CLI (`aws ssm start-session`) to connect. No port 22 needed in Security Group.

```mermaid
classDiagram
    class EC2Instance {
        +Install SSM Agent
        +Attach Instance Profile
    }
    class IAMRole {
        +Policy: AmazonSSMManagedInstanceCore
        +Policy: CloudWatchAgentServerPolicy
    }
    class SecurityGroup {
        +Allow: HTTP:80
        -Deny: SSH:22
    }
    
    EC2Instance --> IAMRole : Assumes Identity
    EC2Instance --> SecurityGroup : Protected By
```

---

## 4. End-to-End Deployment Flow
CI-driven infrastructure updates.

```mermaid
graph LR
    Dev[Developer] -- Pushes Code --> GitHub[GitHub Repo]
    
    subgraph GitHub Actions
        Lint[Lint & Format]
        Sec[Security Scan (tfsec)]
        Plan[Terraform Plan]
        Apply[Terraform Apply]
    end
    
    GitHub -- Trigger --> Lint
    Lint --> Sec
    Sec --> Plan
    
    Plan -- Manual Approval --> Apply
    
    Apply -- Deploys to --> AWS[AWS Infrastructure]
    
    style Plan fill:#f9f,stroke:#333
    style Apply fill:#9f9,stroke:#333
```
