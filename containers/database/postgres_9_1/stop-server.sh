#!/bin/bash

TAG="drupal/testbot-pgsql_9_1"
NAME="drupaltestbot-db-pgsql_9_1"
STALLED=$(docker ps -a | grep ${TAG} | grep Exit | awk '{print $1}')
RUNNING=$(docker ps | grep ${TAG} | grep 5432 | awk '{print $1}')

if [[ ${RUNNING} != "" ]]
  then 
    echo "Found database container: ${RUNNING} running..."
    echo "Stopping..."
    docker stop ${RUNNING}
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

docker rm ${NAME} 2>/dev/null || :
