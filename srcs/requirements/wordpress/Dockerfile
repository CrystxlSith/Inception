FROM debian:bookworm

# Install required packages
RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    php-curl \
    php-gd \
    php-intl \
    php-mbstring \
    php-soap \
    php-xml \
    php-xmlrpc \
    php-zip \
    wget \
    curl \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Install WP-CLI To manage WordPress from the command line
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Create the folder to enable php start
RUN if [ ! -d /run/php ]; then mkdir -p /run/php; fi

WORKDIR /var/www/html

RUN wget https://wordpress.org/wordpress-6.4.3.tar.gz && \
  tar xfz wordpress-6.4.3.tar.gz && \
  mv wordpress/* . && \
  rm -rf wordpress-6.4.3.tar.gz && \
  rm -rf wordpress

# Copy the script (but NOT wp-config.php - let the script create it)
COPY ./tools/script.sh /

RUN chmod +x /script.sh

EXPOSE 9000

CMD [ "/script.sh" ]