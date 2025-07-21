all: up

up:
	sudo docker-compose -f srcs/docker-compose.yml up -d --build 

down:
	sudo docker-compose -f srcs/docker-compose.yml down

stop:
	sudo docker-compose -f srcs/docker-compose.yml stop

build:
	docker-compose build

shell:
	@if [ -z "$(CONTAINER)" ]; then echo "Usage: make shell CONTAINER=<name>"; exit 1; fi
	sudo docker exec -it $(CONTAINER) /bin/bash

mariadb:
	@if [ -z "$(MYSQL_USER)" ]; then echo "Usage: make mariadb MYSQL_USER=<user>"; exit 1; fi
	docker exec -it mariadb mysql -u $(MYSQL_USER) -p
volume:
	sudo docker volume ls

inspect:
	sudo docker volume inspect wordpress mariadb

restart:
	sudo docker-compose -f srcs/docker-compose.yml down && sudo docker-compose -f srcs/docker-compose.yml up -d --build

logs:
	sudo docker-compose -f srcs/docker-compose.yml logs -f

status:
	sudo docker compose -f srcs/docker-compose.yml ps -a


clean:
	docker system prune -a