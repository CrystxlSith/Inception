#!/bin/bash
if [ -f ./wp-config.php ]
then
	echo "wordpress already downloaded"
else
    mkdir -p /var/www/html
    cd /var/www/html
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
    
    wp core download --allow-root

    # Vérification et téléchargement du wp-config-sample.php si nécessaire
    if [ ! -f wp-config-sample.php ]; then
        wget https://raw.githubusercontent.com/WordPress/WordPress/master/wp-config-sample.php
    fi

    # Création du répertoire de données et copie du fichier sample
    mkdir -p /home/clarily/data/wordpress
    cp wp-config-sample.php /home/clarily/data/wordpress/
    
    # Configuration de wp-config.php
    cp wp-config-sample.php wp-config.php
    
    # Configuration de la base de données
    sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config.php
    sed -i "s/username_here/$MYSQL_USER/g" wp-config.php
    sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config.php
    sed -i "s/localhost/$MYSQL_HOSTNAME/g" wp-config.php

    # Génération des clés de sécurité
    KEYS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
    KEYS=$(echo "$KEYS" | sed 's/\$/\\$/g')
    sed -i "/define( 'AUTH_KEY'/,/define( 'NONCE_SALT'/c\\$KEYS" wp-config.php

    # Permissions
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html
    chown -R www-data:www-data /home/clarily/data/wordpress
    chmod -R 755 /home/clarily/data/wordpress

    echo "Keys updated successfully"
    grep "AUTH_KEY" wp-config.php
    # touch hello.test
    # mkdir -p /home/rottbliss/42/inception/srcs/wordpress

# Create the WordPress directory
    wp core download --allow-root
    mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    mv /home/clarily/Inception/srcs/requirements/wordpress/conf/wp-config.php /var/www/html/wp-config.php

    # # rm /var/www/html/wp-config.php
    mv wordpress/conf/wp-config.php /var/www/html/wp-config.php
    cp wordpress/conf/wp-config-sample.php /home/clarily/data/wordpress/wp-config-sample.php


    # #Inport env variables in the config file
    sed -i "s/username_here/$MYSQL_USER/g" wp-config.php
    sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config.php
    sed -i "s/localhost/$MYSQL_HOSTNAME/g" wp-config.php
    sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config.php
fi

sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/g' /etc/php/8.2/fpm/pool.d/www.conf

# exec "$@"
/usr/sbin/php-fpm8.2 -F