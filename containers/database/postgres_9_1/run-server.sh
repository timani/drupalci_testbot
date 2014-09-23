#!/bin/bash

TAG="drupal/testbot-pgsql_9_1"
NAME="drupaltestbot-db-pgsql_9_1"
STALLED=$(docker ps -a | grep ${TAG} | grep Exit | awk '{print $1}')
RUNNING=$(docker ps | grep ${TAG} | grep 5432)
if [[ $RUNNING != "" ]]
  then 
    echo "Found database container:" 
    echo "$RUNNING already running..."
    exit 0
  elif [[ $STALLED != "" ]]
    then
    echo "Found old container $STALLED. Removing..."
    docker rm $STALLED
    if ( ls -d /tmp/tmp.*pgsql/ ); then
      rm -fr /tmp/tmp.*pgsql || /bin/true
      umount -f /tmp/tmp.*pgsql || /bin/true
      rm -fr /tmp/tmp.*pgsql || /bin/true
    fi
fi
  
TMPDIR=$(mktemp -d --suffix=pgsql)
mount -t tmpfs -o size=16000M tmpfs $TMPDIR

docker run -d -p=5432 --name=${NAME} -v="$TMPDIR":/var/lib/postgresql ${TAG}
CONTAINER_ID=$(docker ps | grep ${TAG} | awk '{print $1}')

#PORT=$(docker port $MYSQL_ID 5432 | cut -d":" -f2)
#TAG="drupal/testbot-pgsql_9_1"

echo "CONTAINER STARTED: $CONTAINER_ID"

docker ps | grep "drupal/testbot-pgsql_9_1"
