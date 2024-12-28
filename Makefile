ifneq ("$(wildcard .env)", "")
    include .env
endif

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

laravel: check-env check-laravel
	@echo "Instalowanie Laravel..."
	composer create-project --prefer-dist laravel/laravel Laravel
	@echo "Usuwam niepotrzebny plik vite.config.js..."
	rm ./Laravel/vite.config.js
	@echo "Przenoszę pliki Laravel do katalogu głównego..."
	mv -v ./Laravel/* ./
	mv -v ./Laravel/.[!.]* ./  # Przenosi ukryte pliki
	@echo "Usuwam katalog Laravel..."
	rm -rf Laravel

php: check-env
	docker exec -it -u 1000 ${DOCKER_PHP_FPM} /bin/bash