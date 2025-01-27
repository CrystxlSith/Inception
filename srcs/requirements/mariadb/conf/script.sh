#!/bin/bash

# Create and set proper permissions for required directories
mkdir -p /var/run/mysqld /var/lib/mysql
chown -R mysql:mysql /var/run/mysqld /var/lib/mysql
chmod 777 /var/run/mysqld

# Initialize database if not already done
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB service
mysqld --user=mysql &
sleep 5  # Wait for MySQL to fully start

# Create database configuration
mysql << EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
EOF

# Stop background MariaDB process
if [ -f "/var/run/mysqld/mysqld.pid" ]; then
    kill $(cat /var/run/mysqld/mysqld.pid)
    while [ -f "/var/run/mysqld/mysqld.pid" ]; do
        sleep 1
    done
fi

# Start MariaDB in foreground mode with proper permissions
exec mysqld --user=mysql --console