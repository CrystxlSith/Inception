#!/bin/bash

# Create necessary directories
mkdir -p /var/www/html
mkdir -p /run/php
mkdir -p /home/clarily/data/wordpress

cd /var/www/html

# Download WordPress core if not present
if [ ! -f ./wp-load.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root
fi

# Check if WordPress is properly installed (not just if config exists)
if ! wp core is-installed --allow-root 2>/dev/null; then
    echo "Setting up WordPress..."
    
    # Remove existing wp-config.php if it exists but WordPress is not installed
    if [ -f ./wp-config.php ]; then
        echo "Removing existing wp-config.php..."
        rm -f ./wp-config.php
    fi
    
    # Wait for database to be ready and create wp-config.php
    echo "Waiting for database to be ready..."
    until wp config create --dbname="${MYSQL_DATABASE}" --dbuser="${MYSQL_USER}" --dbpass="${MYSQL_PASSWORD}" --dbhost="${MYSQL_HOSTNAME}" --allow-root --force; do
        echo "Database not ready, waiting..."
        sleep 2
    done
    
    echo "Installing WordPress..."
    wp core install \
        --url="${WP_URL:-https://jopfeiff.42.fr}" \
        --title="${WP_TITLE:-Inception WordPress}" \
        --admin_user="${WP_ADMIN_USER:-admin}" \
        --admin_password="${WP_ADMIN_PASSWORD:-admin_password}" \
        --admin_email="${WP_ADMIN_EMAIL:-admin@jopfeiff.42.fr}" \
        --allow-root
    
    echo "WordPress installed successfully!"
    
    # Create additional user if specified
    if [ -n "$WP_USER" ]; then
        wp user create "$WP_USER" "$WP_USER_EMAIL" \
            --user_pass="$WP_USER_PASSWORD" \
            --role=author \
            --allow-root
        echo "Additional user created: $WP_USER"
    fi
    
    # Set correct permissions
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html
    chown -R www-data:www-data /home/clarily/data/wordpress
    chmod -R 755 /home/clarily/data/wordpress
    
    echo "WordPress setup completed!"
else
    echo "WordPress already properly installed"
fi

# Configure PHP-FPM to listen on port 9000
sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/g' /etc/php/8.2/fpm/pool.d/www.conf

# Start PHP-FPM
echo "Starting PHP-FPM..."
/usr/sbin/php-fpm8.2 -F