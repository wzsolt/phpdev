#!/bin/bash
CERT_DIR=../certs
ENABLED_DIR=../sites

# [ -f "$ENABLED_DIR/ssl.conf" ] && echo -e "Error Script: $ENABLED_DIR/ssl.conf already exist!" && exit 0
# RootCA
./createRootCA.sh && echo RootCA CREATED
# localhost
./createLocalhost.sh localhost && echo "localhost.(crt|key|csr) CREATED"

OUTPUT=`cat <<'EOF'
server {
	server_name ~^ssl(\.localhost)?$;
	return 301 https://$host$request_uri;
}

server {
    include /etc/nginx/snippets/ssl-domain.conf;
	server_name ~^ssl(\.localhost)?$;

	index index.html index.php;
    root /vhosts/ssl/httpdocs;
	location / {
		try_files $uri $uri/ /index.php$is_args$args;
	}

	include /etc/nginx/snippets/php-fpm-default.conf;
}

# SUBDOMAINS
server {
	server_name ~^((?<subdomain>.*)\.)ssl(\.localhost)?$;
	return 301 https://$host$request_uri;
}

server {
	include /etc/nginx/snippets/ssl-domain.conf;
	server_name ~^((?<subdomain>.*)\.)ssl(\.localhost)?$;

	index index.html index.php;
	root /vhosts/ssl/subdomains/${subdomain}/httpdocs;
	location / {
		try_files $uri $uri/ /index.php$is_args$args;
	}

	include /etc/nginx/snippets/php-fpm-default.conf;
}
EOF
`
# OUTPUT: EOF

echo -e "$OUTPUT" > $ENABLED_DIR/ssl.conf
echo DONE.