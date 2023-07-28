#!/bin/bash

shopt -s nocasematch
cd "/Users/zsolt/servers/phpdev"

echo -e "\033]50;SetProfile=DBserver\a"

if [[ "$1" == "i" ]];then
	docker exec -it php-mariadb bash -c "./import.sh && exec /bin/sh"
	clear
else
	docker exec -it php-mariadb bash
fi

echo -e "\033]50;SetProfile=Default\a"