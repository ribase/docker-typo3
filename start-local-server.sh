#!/usr/bin/env bash


cat <<EOF
██████╗  ██████╗  ██████╗██╗  ██╗███████╗██████╗ ███╗   ███╗ █████╗  ██████╗ ██╗ ██████╗
██╔══██╗██╔═══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗████╗ ████║██╔══██╗██╔════╝ ██║██╔════╝
██║  ██║██║   ██║██║     █████╔╝ █████╗  ██████╔╝██╔████╔██║███████║██║  ███╗██║██║
██║  ██║██║   ██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗██║╚██╔╝██║██╔══██║██║   ██║██║██║
██████╔╝╚██████╔╝╚██████╗██║  ██╗███████╗██║  ██║██║ ╚═╝ ██║██║  ██║╚██████╔╝██║╚██████╗
╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝ ╚═════╝

EOF

if [ "$1" == "--database" ] || [ "$2" == "--database" ] || [ "$3" == "--database" ]; then

    echo "Please define your foreign Database"


    read -p "Database: " database
    read -p "Host: " host
    read -p "Name: " name
    read -p "Password: " password

    export TYPO3__DATABASE__HOST=$database
    export TYPO3__DATABASE__NAME=$host
    export TYPO3__DATABASE__USER=$name
    export TYPO3__DATABASE__PASSWORD=$password
    /usr/local/mysql/bin/mysqldump --show-progress-size -u$TYPO3__DATABASE__USER -p$TYPO3__DATABASE__PASSWORD -h$TYPO3__DATABASE__HOST $TYPO3__DATABASE__NAME > docker/db/database.sql
fi
mkdir -p src
mkdir -p src/web
if [ "$1" == "--reinstall" ] || [ "$2" == "--reinstall" ] || [ "$3" == "--reinstall" ]; then
   touch src/web/FIRST_INSTALL
fi

if [ "$1" == "--install" ] || [ "$2" == "--install" ] || [ "$3" == "--install" ]; then
   touch src/web/FIRST_INSTALL
fi

cd docker ; docker-compose up --build --remove-orphans  -d

if [ "$1" == "--database" ] || [ "$2" == "--database" ] || [ "$3" == "--database" ]; then
    docker exec -ti docker_db_1 bash -c "mysql -u typo3 -ptypo3 -h db typo3 < /database.sql"
fi

if [ "$1" == "--reinstall" ] || [ "$2" == "--reinstall" ] || [ "$3" == "--reinstall" ]; then
   docker-compose exec --user www-data php bash -c "composer update -d /var/www/"
fi

if [ "$1" == "--install" ] || [ "$2" == "--install" ] || [ "$3" == "--install" ]; then
   docker-compose exec --user www-data php bash -c "composer install -d /var/www/"
fi

echo "Add host to /etc/hosts"
if grep -q "www.typo3.local" /etc/hosts; then
    echo "Exists"
else
    sudo bash -c "echo '127.0.0.1     www.typo3.local' >> /etc/hosts"
fi