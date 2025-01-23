FROM debian:latest

RUN apt-get update && apt upgrade && apt-get install -y php-fpm \
nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]