container_php=php

up:
	docker-compose up -d

build:
	docker-compose rm -vsf
	docker-compose down -v --remove-orphans
	docker-compose build
	docker-compose up -d

down:
	docker-compose down


php:
	docker exec -it -u 1000 ${container_php} /bin/bash