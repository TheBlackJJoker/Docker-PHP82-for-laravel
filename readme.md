# Docker for Laravel
PHP 8.4, Composer, MySQL 9.1, Ngnix, xDebug 

## 

## To do first

First init .env for work anything else
```` bash
    make init
````

## Docker managment

Run docker containers
```` bash
    make up
````

Down docker containers
```` bash
    make down
````

Rebuild docker containers
```` bash
    make rebuild
````

## Jump into php container for artisan or composer console
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

    
## Links
http://localhost:61000 - your application