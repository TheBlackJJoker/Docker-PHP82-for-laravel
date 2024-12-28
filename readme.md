# Docker for Laravel
PHP 8.4, Composer, MySQL 9.1, Ngnix, xDebug 

## 

Run docker containers
```` bash
    make up
````

Build docker containers
```` bash
    make build
````

Down docker containers
```` bash
    make down
````

Go into php container console
```` bash
    make php
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

## Fix storage permission for laravel
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