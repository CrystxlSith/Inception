FROM debian:bookworm

RUN apt-get update -y && apt-get install mariadb-server -y

# RUN groupadd -r mysql && useradd -r -g mysql mysql
# RUN chown -R mysql:mysql /var/lib/mysql
# RUN chown -R mysql:mysql /var/run/mysqld

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/


COPY ./tools/script.sh /

RUN chmod +x /script.sh

EXPOSE 3306

CMD ["/script.sh"]