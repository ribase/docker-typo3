# TYPO3 with docker-compose

## How to use
You can start the docker-compose environment by the script in the root of this project `./start-local-server.sh --install`.
If you do your own custom stuff you can start the docker containers by cd into `./docker/` and type `docker-compose up --build -d` the `-d` is useful if you aren't interested in output from supervisord.

### Script usage (Alpha state, sorry)

##### Example:
You can start the script with your own database if you say:
```
./start-local-server.sh --database
```
In this case you have to provide your credentials to the script. It will dump your database and include in the docker-db-container.
```
Please define your foreign Database
Database: #database name
Host: #hostname (if local then localhost/127.0.0.1)
Name: #Username
Password: #No words needed but written
```


##### Example:
If you have no code at yours you are able to start from scratch:
```
./start-local-server.sh --install
```
In this case after the containers are up composer install will be triggered and executed on the container.
You can define in the composer.json in the webfolder `./web/` which dependencies you need. By default its only newest TYPO3 7.6.x

### Custom usage

#### The compose file
As you can see below there is the docker-compose.yml.
At the moment you can choose between php5 oder php7 and nginx or apache2.
```
version: '2'
services:
    db:
        build: db
        ports:
          - 3306:3306
        environment:
          MYSQL_ROOT_PASSWORD: typo3
          MYSQL_DATABASE: typo3
          MYSQL_USER: typo3
          MYSQL_PASSWORD: typo3
        volumes_from:
          - php
    php:
        build: php7-fpm #php5-fpm
        ports:
            - 9000:9000
        volumes:
            - ../web:/var/www/web
#    nginx:
#        build: nginx
#        ports:
#            - 80:80
#        links:
#            - php
#        volumes_from:
#            - php
#        volumes:
#            - ./logs/nginx/:/var/log/nginx
#        tty: true
    apache:
        build: apache
        ports:
            - 80:80
        links:
            - php
        volumes_from:
            - php
        volumes:
            - ./logs/apache/:/var/log/apache
        tty: true
```

#### The web folder
Into the webfolder you can paste your whole TYPO3 project and just start the containers with:
```
./start-local-server.sh --database
```
This will provide the database that you need to run your website properly.

## Credits
[Sebastian Thadewald](https://github.com/ribase/docker-typo3)

## License
See LICENSE.md in repository.

## Issues?
[Drop an issue](https://github.com/ribase/docker-typo3/issues)

## Thanks to [maxpou](https://github.com/maxpou) and his idea of docker-symfony