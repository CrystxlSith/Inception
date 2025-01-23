all: up

up:
	sudo docker-compose -f srcs/docker-compose.yml up -d --build 

down:
	sudo docker-compose -f srcs/docker-compose.yml down

stop:
	sudo docker-compose -f srcs/docker-compose.yml stop

build:
	docker-compose build

restart:
	sudo docker-compose -f srcs/docker-compose.yml down && sudo docker-compose -f srcs/docker-compose.yml up -d

logs:
	sudo docker-compose -f srcs/docker-compose.yml logs -f

status:
	sudo docker compose -f srcs/docker-compose.yml ps -a