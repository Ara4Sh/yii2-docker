#!/bin/bash
CONFIG_FILE=$PWD/config.conf
if [ ! -f $CONFIG_FILE ]
then
    echo '********************************************'
    echo '* can not load config file :'$CONFIG_FILE
    echo '********************************************'
    exit
fi
. $CONFIG_FILE

confirm () {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case $response in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
	    echo 'canceled by user';
            exit
            ;;
    esac
}

if [ -f docker-compose.yml ]
then
    echo "ATTENTION :
	docker-compose.yml is exist ! 
	this action maybe lost your files !!!!"

    confirm "	are you want to overwrite [y/N] ?"
      

fi

echo '****************************************'
echo '* start to creating docker-compose.yml '
echo '****************************************'
touch docker-compose.yml
echo "
percona:
 image: percona
 restart: alway
 container_name: $MYSQL_CONTAINER_NAME
 hostname: $MYSQL_CONTAINER_NAME
 volumes:
  - $APP_MYSQL_FOLDER:/var/lib/mysql
  - $SHARING_FOLDER:/share
 environment:
  - MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD
  - MYSQL_DATABASE=$MYSQL_DB_NAME
  - MYSQL_USER=$MYSQL_DB_USER
  - MYSQL_PASSWORD=$MYSQL_DB_PASS
web:
 build: $PWD/web
 restart: always
 container_name: $WEB_CONTAINER_NAME
 hostname: $WEB_CONTAINER_NAME
 ports:
  - $HTTP_PORT:80
 volumes:
  - $APP_WEB_FOLDER:$SITE_ROOT
  - $SHARING_FOLDER:/share
 environment:
  - SITE_NAME_FRONTEND=$FRONTEND_SITE_NAME
  - SITE_NAME_BACKEND=$BACKEND_SITE_NAME
 links:
  - percona:mysql" > docker-compose.yml
cat docker-compose.yml
echo '****************************************'
echo '* docker-compose.yml created successfull.'
echo '****************************************'
echo "~~~~~ Now you can run 'make run' ~~~~~~~"