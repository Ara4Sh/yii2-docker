#!/bin/bash

echo "*********************************************"
composer config -g github-oauth.github.com $GITHUB_TOKEN
echo 'set composer github token successfull'
echo "*********************************************"

if [ -e "/var/www/composer.json" ]; then
    echo "skip installation and running composer install"
    echo "*********************************************"
    cd /var/www/ && composer install 
else
    echo "starting to pull yii2 app advanced last version ..."
    echo "*********************************************"
    composer create-project --prefer-dist yiisoft/yii2-app-advanced /var/www
    echo "*********************************************"
    echo "pulling Yii2 app advanced successfull."
    echo "*********************************************"
fi


