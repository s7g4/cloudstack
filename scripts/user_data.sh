#!/bin/bash
yum update -y
amazon-linux-extras install nginx1 -y
systemctl start nginx
systemctl enable nginx

# Get Instance Metadata
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id)
AVAILABILITY_ZONE=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/placement/availability-zone)

# Create Index.html
cat <<EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>CloudStack Demo</title>
    <style>
        body { font-family: sans-serif; text-align: center; padding: 50px; background-color: #f0f2f5; }
        .container { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); display: inline-block; }
        h1 { color: #1a73e8; }
        .meta { color: #5f6368; margin-top: 20px; font-size: 0.9em; }
    </style>
</head>
<body>
    <div class="container">
        <h1>CloudStack Demo: Web Server Online</h1>
        <p>This page is served from an EC2 instance provisioned via Terraform.</p>
        <div class="meta">
            <p>Instance ID: <strong>$INSTANCE_ID</strong></p>
            <p>Availability Zone: <strong>$AVAILABILITY_ZONE</strong></p>
            <p>Managed by: <strong>Terraform</strong></p>
        </div>
    </div>
</body>
</html>
EOF
