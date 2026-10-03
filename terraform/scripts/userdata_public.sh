#!/bin/bash
set -e

# Install and enable Nginx
dnf install -y nginx
systemctl enable --now nginx

# Create the Nginx reverse proxy configuration using the injected variable
tee /etc/nginx/conf.d/reverse_proxy.conf > /dev/null << EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://${private_ip}:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

# Validate and reload Nginx configuration
nginx -t
systemctl reload nginx