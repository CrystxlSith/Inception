#!/bin/bash

# Generate SSL certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=FR/ST=IDF/L=Paris/O=42/CN=login.42.fr"

# Configure hosts
echo "127.0.0.1 jopfeiff.42.fr" >> /etc/hosts

# Start nginx
nginx -g 'daemon off;'