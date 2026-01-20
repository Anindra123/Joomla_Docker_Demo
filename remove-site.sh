#!/bin/bash 

SITE_NAME=$1


if [ -d ./sites/$SITE_NAME ]; then
    cd ./sites/$SITE_NAME
    docker compose down
    cd ..
    rm -r ./$SITE_NAME
    docker volume rm "$SITE_NAME"_db_data
    docker volume rm "$SITE_NAME"_joomla_data
fi
