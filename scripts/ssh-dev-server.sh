#!/bin/bash
valid_versions=(74 81)
default_version=74
selected_version=$default_version

in_array () { 
    local array="$1[@]"
    local seeking=$2
    local in=1
    for element in "${!array}"; do
        if [[ $element == "$seeking" ]]; then
            in=0
            break
        fi
    done
    return $in
}

# echo "-----------------------------------------"
# echo "Params for PHP version: 74, 81"
# echo " (default: $default_version)"
# echo "-----------------------------------------"

if [ "$1" != "" ] ;then
	in_array valid_versions $1 && selected_version=$1 || selected_version=$default_version
fi

cd "/Users/zsolt/servers/phpdev"

echo -e "\033]50;SetProfile=DevServer\a"

docker exec -it "php$selected_version-fpm" /bin/sh -c "clear && php -v && exec /bin/sh"

echo -e "\033]50;SetProfile=Default\a"

