#!/bin/bash

DB_USER="root"
DB_PASSWORD="root"
VALID_DATABASES=()
re='^[0-9]+$'
database=""
filename=""
moddate=""
filesize=""

COLOR_BLACK="30"
COLOR_RED="31"
COLOR_GREEN="32"
COLOR_YELLOW="33"
COLOR_BLUE="34"
COLOR_MAGENTA="35"
COLOR_CYAN="36"
COLOR_GRAY="90"
COLOR_WHITE="97"

BG_COLOR_BLACK="40"
BG_COLOR_RED="41"
BG_COLOR_GREEN="42"
BG_COLOR_YELLOW="43"
BG_COLOR_BLUE="44"
BG_COLOR_MAGENTA="45"
BG_COLOR_CYAN="46"
BG_COLOR_GRAY="100"
BG_COLOR_WHITE="107"

RED="\e[${COLOR_RED}m"
GREEN="\e[${COLOR_GREEN}m"
YELLOW="\e[${COLOR_YELLOW}m"
WHITE="\e[${COLOR_WHITE}m"

BOLDGREEN="\e[1;${COLOR_GREEN}m"
BOLDRED="\e[1;${COLOR_RED}m"
BOLDWHITE="\e[1;${COLOR_WHITE}m"

ENDCOLOR="\e[0m"

get_databases() {
	mapfile -t VALID_DATABASES < <( mysql -u $DB_USER -p$DB_PASSWORD -B -N -e 'SHOW DATABASES WHERE `Database` NOT IN ("mysql", "information_schema", "performance_schema", "phpmyadmin");' )

	VALID_DATABASES=("${RED}EXIT from import script (or type: exit)${ENDCOLOR}\n" "${VALID_DATABASES[@]}")
}

input_database() {
	clear
	echo -e "Please select the number of the DATABASE:\n"
	for index in "${!VALID_DATABASES[@]}"; do printf "${BOLDWHITE}%4s${ENDCOLOR} : ${YELLOW}%b${ENDCOLOR}\n" $index "${VALID_DATABASES[$index]}"; done

	count=${#VALID_DATABASES[*]}
	count=$((count-1))

	echo -en "\nEnter number ${BOLDWHITE}(0-$count)${ENDCOLOR}: "
	read database

	if [ "$database" == 0 ] || [[ "$database" == "exit" ]] ;then
	    echo "Exiting import script... Bye!"
		exit
	fi	

	if ! [[ $database =~ $re ]] || [ "${VALID_DATABASES[$database]}" == "" ] ; then
	   database=""
	fi

	return $database
}

input_file() {
	read -e -p "$(echo -e Please enter the ${BOLDWHITE}FILE NAME${ENDCOLOR}:) " filename
}

import_data(){
	if [ -f "$filename" ]; then
		echo -e "\nImporting file: ${BOLDWHITE}${filename}${ENDCOLOR}, please wait..."

	    mysql -u $DB_USER -p$DB_PASSWORD -f ${VALID_DATABASES[$database]} < $filename
	    echo -e "${BOLDGREEN}Import DONE!${ENDCOLOR}"

	    remove_file
	else 
	    echo -e "${BOLDRED}File: \"$filename\" does not exist.${ENDCOLOR}"
	fi
	
	echo -e "------------------------------------------------------------\n"
}

remove_file() {
	echo -en "------------------------------------------------------------\n"
	echo -en "${BOLDRED}Do you want to delete the: ${BOLDGREEN}$filename${BOLDRED} file? ${BOLDWHITE}(Y/N)${ENDCOLOR}: "
	read -n1 dodelete
	dodelete=${dodelete:-n}

	if [[ "$dodelete" == "y" ]] ;then
		rm $filename
		echo -en "\n${BOLDRED}File deleted!${ENDCOLOR}\n"
	fi	
}

get_databases

shopt -s nocasematch

while [[ -z "$database" ]]
do
  input_database
done

echo "------------------------------------------------------------"
echo -e "Selected database: ${BOLDGREEN}${VALID_DATABASES[$database]}${ENDCOLOR}"

filename="${VALID_DATABASES[$database]}.sql"
if [ -f "$filename" ]; then
	moddate=$(stat --printf="%.16y" $filename)
	filesize=$(stat -c "%s" $filename | numfmt --to=iec)

    echo -en "\n${BOLDGREEN}$filename${ENDCOLOR} exists. (Last modified: ${BOLDWHITE}$moddate${ENDCOLOR}, file size: ${BOLDWHITE}$filesize${ENDCOLOR})"
    echo -en "\nDo you want to import it? ${BOLDWHITE}(Y, Enter or N)${ENDCOLOR}: "
	read -n1 doimport
	doimport=${doimport:-yes}

	if [[ "$doimport" != "y" ]] && [[ "$doimport" != "yes" ]] ;then
		echo -e "\n"
	    input_file
	fi	

else 
    echo -e "${BOLDRED}$filename${ENDCOLOR} does not exist. "
    input_file
fi

import_data



