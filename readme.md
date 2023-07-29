# Docker with PHP8.2, Composer, MySQL8, Redis, Ngnix
Ready to work containers for Laravel, solving the problem with permission to newly created files by the artisan console, when working with WSL2.

## 

Run docker containers
```` bash
docker-compose up -d
````

Go into php container as user (1000) for artisan command, or composer
```` bash
docker exec -it -u 1000  php /bin/bash
````

## Install Laravel and move to main folder
```` bash
composer create-project --prefer-dist laravel/laravel Laravel 
````
```` bash
mv -v ./Laravel/* ./Laravel/.* ./
````
```` bash
rm -rf Laravel
````

## Fix storage permission
```` bash
chmod 777 -R storage
````

## Database connection
    MYSQL_HOST = mysql <docker mysql container name>
    MYSQL_DATABASE = database
    MYSQL_USER = admin
    MYSQL_PASSWORD = password
    
## Links
http://localhost:61000 - website

http://localhost:8080 - Adminer (database management in browser)