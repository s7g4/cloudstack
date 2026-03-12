#!/bin/bash

# CloudStack Demo Verification Script
# Usage: ./verify_deployment.sh <PUBLIC_IP>

if [ -z "$1" ]; then
    echo "Usage: ./verify_deployment.sh <PUBLIC_IP>"
    exit 1
fi

URL="http://$1"
echo "Testing $URL..."

# Check HTTP Status
STATUS=$(curl -o /dev/null -s -w "%{http_code}\n" $URL)

if [ "$STATUS" == "200" ]; then
    echo "✅ Success! Web server is reachable (HTTP 200)."
    exit 0
else
    echo "❌ Failure! Web server returned HTTP $STATUS."
    exit 1
fi
