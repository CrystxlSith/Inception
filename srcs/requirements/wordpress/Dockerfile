FROM debian:latest

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
    && rm -rf /var/lib/apt/lists/*


# I need to install wp_cli command and put it in the right directory /usr/local/bin
#Create the folder to enable php start
RUN if [ ! -d /run/php ]; then mkdir -p /run/php; fi

WORKDIR /var/www/html

RUN wget http://wordpress.org/latest.tar.gz && \
  tar xfz latest.tar.gz && \
  mv wordpress/* . && \
  rm -rf latest.tar.gz && \
  rm -rf wordpress


#we copy the script, give the right to launch it in local on our computer
COPY ./conf/script.sh /
COPY ./conf/wp-config.php /

RUN chmod +x /script.sh

EXPOSE 9000

CMD [ "/script.sh" ]