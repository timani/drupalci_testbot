#!/bin/bash

# Remove intermediate containers after a successful build. Default is True.
DCI_REMOVEINTCONTAINERS=${DCI_REMOVEINTCONTAINERS:-"true"}

docker ps | grep "drupal/testbot-pgsql_8_3" | awk '{print $1}' | grep -v CONTAINER | xargs -n1 -I {} docker stop {}
docker ps -a | grep "drupal/testbot-pgsql_8_3" | awk '{print $1}' | grep -v CONTAINER | xargs -n1 -I {} docker rm {}

docker build --rm=${DCI_REMOVEINTCONTAINERS} -t drupal/testbot-pgsql_8_3 .
