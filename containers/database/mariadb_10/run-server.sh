#!/bin/bash

TAG="drupal/testbot-mariadb_10"
NAME="drupaltestbot-db-mariadb_10"
STALLED=$(docker ps -a | grep ${TAG} | grep Exit | awk '{print $1}')
RUNNING=$(docker ps | grep ${TAG} | grep 3306)
if [[ $RUNNING != "" ]]
  then
    echo "Found database container:"
    echo "$RUNNING already running..."
    exit 0
  elif [[ $STALLED != "" ]]
    then
    echo "Found old container $STALLED. Removing..."
    docker rm $STALLED
    if ( ls -d /tmp/tmp.*mariadb_10_0/ ); then
      rm -fr /tmp/tmp.*mariadb_10_0 || /bin/true
      umount -f /tmp/tmp.*mariadb_10_0 || /bin/true
      rm -fr /tmp/tmp.*mariadb_10_0 || /bin/true
    fi
fi

TMPDIR=$(mktemp -d --suffix=mariadb_10_0)
mount -t tmpfs -o size=16000M tmpfs $TMPDIR

docker run -d -p=3306 --name=${NAME} -v="$TMPDIR":/var/lib/mysql ${TAG}
CONTAINER_ID=$(docker ps | grep ${TAG} | awk '{print $1}')

#PORT=$(docker port $MYSQL_ID 3606 | cut -d":" -f2)
#TAG="drupal/testbot-mysql"

echo "CONTAINER STARTED: $CONTAINER_ID"

docker ps | grep "drupal/testbot-mariadb_10"

