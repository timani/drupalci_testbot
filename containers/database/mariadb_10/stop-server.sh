#!/bin/bash

# Check if we are a member of the "docker" group or have root powers
USERNAME=$(whoami)
TEST=$(groups $USERNAME | grep -c '\bdocker\b')
if [ $TEST -eq 0 ];
then
  if [ `whoami` != root ]; then
    echo "Please run this script as root or using sudo"
    exit 1
  fi
fi

TAG="drupal/testbot-mariadb_10"
NAME="drupaltestbot-db-mariadb_10"
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
    if ( ls -d /tmp/tmp.*mariadb_10_0/ ); then
      rm -fr /tmp/tmp.*mariadb_10_0 || /bin/true
      umount -f /tmp/tmp.*mariadb_10_0 || /bin/true
      rm -fr /tmp/tmp.*mariadb_10_0 || /bin/true
    fi
fi

docker rm ${NAME} 2>/dev/null || :
