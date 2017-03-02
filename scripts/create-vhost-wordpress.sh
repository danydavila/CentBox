#!/usr/bin/env bash
#/srv/scripts/create-vhost-laravel.sh "test.io" "/var/www"
sudo mkdir -p /etc/nginx/sites_enabled 2>/dev/null
sudo mkdir -p /etc/nginx/ssl 2>/dev/null

PATH_SSL="/etc/nginx/ssl"
PATH_KEY="${PATH_SSL}/${1}.key"
PATH_CSR="${PATH_SSL}/${1}.csr"
PATH_CRT="${PATH_SSL}/${1}.crt"

if [ ! -f $PATH_KEY ] || [ ! -f $PATH_CSR ] || [ ! -f $PATH_CRT ]
then
    sudo openssl genrsa -out "$PATH_KEY" 2048 2>/dev/null
    sudo openssl req -new -key "$PATH_KEY" -out "$PATH_CSR" -subj "/CN=$1/O=Vagrant/C=UK" 2>/dev/null
    sudo openssl x509 -req -days 365 -in "$PATH_CSR" -signkey "$PATH_KEY" -out "$PATH_CRT" 2>/dev/null
fi

block="server {
    listen ${3:-80};
    listen ${4:-443} ssl http2;
    server_name $1;
    root \"$2\";
    ssl_certificate     /etc/nginx/ssl/$1.crt;
    ssl_certificate_key /etc/nginx/ssl/$1.key;

    include /etc/nginx/sites_conf/common_general.conf;
    include /etc/nginx/sites_conf/common_wordpress.conf;
    include /etc/nginx/sites_conf/common_errors.conf;
    include /etc/nginx/sites_conf/common_log.conf;
    include /etc/nginx/sites_conf/common_php.conf;
}
"
sudo test -e /etc/nginx/sites_enabled/$1.conf || sudo touch /etc/nginx/sites_enabled/$1.conf
sudo sh -c "echo '$block' > /etc/nginx/sites_enabled/$1.conf"