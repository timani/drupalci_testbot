#!/bin/bash

TAG="drupal/testbot-mysql_5_5"
NAME="drupaltestbot-db-mysql_5_5"
STALLED=$(docker ps -a | grep ${TAG} | grep Exit | awk '{print $1}')
RUNNING=$(docker ps | grep ${TAG} | grep 3306 | awk '{print $1}')

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
    if ( ls -d /tmp/tmp.*mysql/ ); then
      rm -fr /tmp/tmp.*mysql || /bin/true
      umount -f /tmp/tmp.*mysql || /bin/true
      rm -fr /tmp/tmp.*mysql || /bin/true
    fi
fi

docker rm ${NAME} 2>/dev/null || :
