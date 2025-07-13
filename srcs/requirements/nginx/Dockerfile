FROM debian:bookworm

RUN apt-get update && apt upgrade -y && apt-get install -y nginx openssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=clarily.42.fr"

    
COPY ./tools/script.sh /
COPY ./conf/nginx.conf /etc/nginx/conf.d

RUN chmod 777 /script.sh

EXPOSE 443

CMD ["/script.sh"]