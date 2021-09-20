#!/bin/bash

if [[ $1 == "on" || $1 == "off" ]];
then
    sed -i -E "/autoindex/ s/on|off/$1/" /etc/nginx/sites-available/nginx.conf
    echo "Autoindex has been turned $1"
    service nginx restart
else
    echo "Please, enter 'on' or 'off'"
fi