#!/bin/sh

TAG="drupal/testbot-mariadb_10_0"
CONTAINER_ID=$(docker ps | grep $TAG | awk '{print $1}')
IP=$(docker inspect --format='{{.NetworkSettings.IPAddress}}' $CONTAINER_ID)

echo $IP
mysql -u drupaltestbot -pdrupaltestbotpw -h $IP
