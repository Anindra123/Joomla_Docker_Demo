#!/bin/bash 

SITE_NAME=$1
ADMIN_USERNAME=$2
ADMIN_EMAIL=$3
ADMIN_PASSWORD=$4

PASSWORD_LENGTH=${#ADMIN_PASSWORD}
NUM_OF_SITES=$(find ./sites -mindepth 1 -type d | wc -l) # find subdirectories and counts the lines
BASE_PORT=10010
PORT=$((BASE_PORT+NUM_OF_SITES)) # increase the number of ports based on the number of sites

export LC_CTYPE=C # so that tr doesn't return illegal characters for mac osx

# check whether passed username
if [[ -z  "$ADMIN_USERNAME" ]]; then 
    ADMIN_USERNAME='dev'
fi

# check whether passed email
if [[ -z  "$ADMIN_EMAIL" ]]; then 
    ADMIN_EMAIL='dev@mail.com'
fi

# check whether passed password
if [[ -z "$ADMIN_PASSWORD" ]]; then
    # tr reads bytes from stdin of Linux special random device /dev/urandom
    # tr then strips all characters except A-Z a-z 0-9
    # finally head -c 12 returns the first 12 bytes from the head of the string
    # this is not a secure password but given here for demo purpose
    ADMIN_PASSWORD=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 15 ) 
elif [[ PASSWORD_LENGTH -lt 13 ]]; then
    echo "Password must be longer than 12 characters"
    exit 1;
fi

# check if passed site name
if [[ -z "$SITE_NAME" ]]; then
    echo "Site Name is Required"
    exit 1;
fi

# create a folder from the site name
if [ ! -d ./sites/$SITE_NAME ]; then
    mkdir ./sites/$SITE_NAME/
fi

# copy the template to compose file inside the site folder 
# and run docker compose up to run the services
if [ -f ./sites/$SITE_NAME/compose.yml ]; then
    cd ./sites/$SITE_NAME
    docker compose up -d
else 
    cp ./template.yml ./sites/$SITE_NAME/compose.yml
    # replace template.yml variable value with bash variable value
    # added '' after -i which is for in-place so that it works on both
    # BSD and GNU
    sed -i'' "s/SITENAME/$SITE_NAME/g" ./sites/$SITE_NAME/compose.yml
    sed -i'' "s/JOOMLA_USERNAME/$ADMIN_USERNAME/g" ./sites/$SITE_NAME/compose.yml
    sed -i'' "s/JOOMLA_PASSWORD/$ADMIN_PASSWORD/g" ./sites/$SITE_NAME/compose.yml
    sed -i'' "s/JOOMLA_MAIL/$ADMIN_EMAIL/g" ./sites/$SITE_NAME/compose.yml
    sed -i'' "s/JOOMLA_PORT/$PORT/g" ./sites/$SITE_NAME/compose.yml
    cd ./sites/$SITE_NAME
    docker compose up -d
fi

SITE_URL="http://localhost:$PORT"

echo "Preparing your website. Please wait...."
sleep 10

echo "Your website is ready 🎉"
echo "Site url: $SITE_URL"
echo "Your site username: $ADMIN_USERNAME"
echo "Your site email   : $ADMIN_EMAIL"
echo "Your site password: $ADMIN_PASSWORD"
