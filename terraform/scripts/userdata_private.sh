#!/bin/bash
set -e

# Define directory and application file
APP_DIR="/home/ec2-user/app"
mkdir -p "$APP_DIR"
cd "$APP_DIR"

# Create index.html
cat << 'EOF' > index.html
Private App Server
Hello from the Private Subnet App Server!
Served via Python http.server on Port 8080.
EOF

#Ensure ec2-user owns the app directory
chown -R ec2-user:ec2-user "$APP_DIR"

#Start Python HTTP server on port 8080 in the background as ec2-user
nohup sudo -u ec2-user python3 -m http.server 8080 > app.log 2>&1 &