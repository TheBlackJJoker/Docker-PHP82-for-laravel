ifneq ("$(wildcard .env)", "")
    include .env
endif

CURRENT_USER_ID = $(shell id --user)
CURRENT_USER_GROUP_ID = $(shell id --group)

.PHONY: init set-app-name

check-env:
	@if [ ! -f .env ]; then \
		echo ".env nie istnieje. Użyj make init przed wykonaniem tego kroku."; \
		exit 1; \
	fi

check-laravel:
	@if [ -f artisan ]; then \
		echo "Laravel jest już zainstalowany."; \
		exit 1; \
	fi

check-is-laravel:
	@if [ ! -f artisan ]; then \
		echo "Laravel nie jest zainstalowany. Użyj make laravel."; \
		exit 1; \
	fi

init:
	@if [ -f .env ]; then \
    	read -p ".env już istnieje. Nadpisać? (t/n): " CONFIRM; \
    	if [ "$$CONFIRM" = "t" ]; then \
    		cp .env.example .env; \
    		echo "Utworzono .env"; \
    		make set-app-name; \
    	else \
    		echo "Anulowano."; \
    	fi; \
    else \
    	cp .env.example .env; \
    	echo "Utworzono .env"; \
    	make set-app-name; \
    fi

set-app-name: check-env
	@if [ -f .env ]; then \
		read -p "Podaj nazwę aplikacji: " APP_NAME2; \
		APP_NAME2=$$(echo "$$APP_NAME2" | sed 's/ /_/g'); \
		if grep -q "^APP_NAME=" .env; then \
			sed -i "s/^APP_NAME=.*/APP_NAME=$$APP_NAME2/" .env \
		else \
			echo "APP_NAME=$$APP_NAME2" >> .env; \
		fi; \
		echo "Zmieniono nazwę aplikacji na $$APP_NAME2 w pliku .env"; \
	fi

up: check-env
	docker-compose up -d

rebuild: check-env
	docker-compose rm -vsf
	docker-compose down -v --remove-orphans
	docker-compose build
	docker-compose up -d

down: check-env
	docker-compose down

laravel: check-env check-laravel up
	echo "Instalowanie Laravel w kontenerze ${DOCKER_PHP_FPM}..."
	docker exec --user "${CURRENT_USER_ID}:${CURRENT_USER_GROUP_ID}" ${DOCKER_PHP_FPM} bash -c "composer create-project --prefer-dist laravel/laravel Laravel"
	rm ./Laravel/vite.config.js
	rm ./Laravel/.env
	rm ./Laravel/README.md
	rm ./Laravel/.env.example
	rm ./Laravel/.gitignore
	mv -v ./Laravel/* ./
	mv -v ./Laravel/.[!.]* ./
	rm -r ./Laravel
	sudo chown -R "${CURRENT_USER_ID}:${CURRENT_USER_GROUP_ID}" storage bootstrap/cache
	sudo chmod -R 777 storage bootstrap/cache
	mv  ./welcome.blade.php ./resources/views/
	mkdir -p public/assets/css
	touch public/assets/css/style.css
	docker exec --user "${CURRENT_USER_ID}:${CURRENT_USER_GROUP_ID}" ${DOCKER_PHP_FPM} bash -c "php artisan key:generate"
	docker exec --user "${CURRENT_USER_ID}:${CURRENT_USER_GROUP_ID}" ${DOCKER_PHP_FPM} bash -c "php artisan storage:link"
	wait 5
	docker exec --user "${CURRENT_USER_ID}:${CURRENT_USER_GROUP_ID}" ${DOCKER_PHP_FPM} bash -c "php artisan migrate"
	sudo chown -R "${CURRENT_USER_ID}:${CURRENT_USER_GROUP_ID}" storage bootstrap/cache
	sudo chmod -R 777 storage bootstrap/cache
	docker exec --user "${CURRENT_USER_ID}:${CURRENT_USER_GROUP_ID}" ${DOCKER_PHP_FPM} bash -c "php artisan optimize"
	make node-install
	echo "Instalacja Laravel zakończona."
	make dev

php: check-env
	docker exec -it --user "${CURRENT_USER_ID}:${CURRENT_USER_GROUP_ID}" ${DOCKER_PHP_FPM} /bin/bash

node-install: up
	docker exec --user "${CURRENT_USER_ID}:${CURRENT_USER_GROUP_ID}" ${DOCKER_NODE} npm install
dev: up
	docker exec --user "${CURRENT_USER_ID}:${CURRENT_USER_GROUP_ID}" ${DOCKER_NODE} npm run dev

build: up
	docker exec --user "${CURRENT_USER_ID}:${CURRENT_USER_GROUP_ID}" ${DOCKER_NODE} npm run build

filament-install: check-env check-is-laravel up
	docker exec --user "${CURRENT_USER_ID}:${CURRENT_USER_GROUP_ID}" ${DOCKER_PHP_FPM} bash -c "composer require filament/filament:"^3.2" -W"
	docker exec -it --user "${CURRENT_USER_ID}:${CURRENT_USER_GROUP_ID}" ${DOCKER_PHP_FPM} bash -c "php artisan filament:install --panels"
	docker exec -it --user "${CURRENT_USER_ID}:${CURRENT_USER_GROUP_ID}" ${DOCKER_PHP_FPM} bash -c "php artisan make:filament-user"
	docker exec --user "${CURRENT_USER_ID}:${CURRENT_USER_GROUP_ID}" ${DOCKER_PHP_FPM} bash -c "php artisan optimize"
