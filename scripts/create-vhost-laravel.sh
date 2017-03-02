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

    autoindex    Off;
    sendfile off;
    client_max_body_size 100m;
    location / {
          try_files   \$uri \$uri/ /index.php?\$query_string;
     }
     # Remove trailing slash to please routing system.
       if (!-d \$request_filename) {
           rewrite     ^/(.+)/$ /\$1 permanent;
       }
    error_page 404 /index.php;

    # Log Files
    #error_log  /var/log/nginx/$1-error.log error;
    include /etc/nginx/sites_conf/common_log.conf;

    location ~ \.php$ {
                         try_files \$uri =404;
                         fastcgi_split_path_info ^(.+\.php)(/.+)$;
                         fastcgi_pass    127.0.0.1:9001; #For PHP 7.1
                         #fastcgi_pass    127.0.0.1:9000; #for PHP 5.6
                         include /etc/nginx/sites_conf/phpfpm_params.conf;
                       }
}
"
sudo test -e /etc/nginx/sites_enabled/$1.conf || sudo touch /etc/nginx/sites_enabled/$1.conf
sudo sh -c "echo '$block' > /etc/nginx/sites_enabled/$1.conf"
