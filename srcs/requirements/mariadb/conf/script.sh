#!/bin/bash

# Setup directories
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld /var/lib/mysql

# Initialize if needed
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    # Start MySQL temporarily
    mysqld --user=mysql --bootstrap << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
fi

# Start MariaDB
mysqld
# #!/bin/bash



# service mysql start 


# echo "CREATE DATABASE IF NOT EXISTS $db1_name ;" > db1.sql
# echo "CREATE USER IF NOT EXISTS '$db1_user'@'%' IDENTIFIED BY '$db1_pwd' ;" >> db1.sql
# echo "GRANT ALL PRIVILEGES ON $db1_name.* TO '$db1_user'@'%' ;" >> db1.sql
# echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '12345' ;" >> db1.sql
# echo "FLUSH PRIVILEGES;" >> db1.sql

# mysql < db1.sql

# kill $(cat /var/run/mysqld/mysqld.pid)

# mysqld