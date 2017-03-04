#!/usr/bin/env bash
set -x
# Script Name: provision-initialize.sh
# Author: Dany Davila <danydavila@gmail.com>
# Version: 0.2.0
# Configure the vm for the first time
#
if [ -f "/var/vagrant_provisioned" ]; then
    exit 0
fi

PATH_SSL="/etc/nginx/ssl"
PATH_KEY="${PATH_SSL}/centbox.key"
PATH_CSR="${PATH_SSL}/centbox.csr"
PATH_CRT="${PATH_SSL}/centbox.crt"
IPADDRESS=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | head -1)

echo "Generating Default SSL"
sudo mkdir -p ${PATH_SSL}

if [ ! -f $PATH_KEY ] || [ ! -f $PATH_CSR ] || [ ! -f $PATH_CRT ]
then
    sudo openssl genrsa -out "$PATH_KEY" 2048 2>/dev/null
    sudo openssl req -new -key "$PATH_KEY" -out "$PATH_CSR" -subj "/CN=centbox.app/O=Vagrant/C=US" 2>/dev/null
    sudo openssl x509 -req -days 365 -in "$PATH_CSR" -signkey "$PATH_KEY" -out "$PATH_CRT" 2>/dev/null
fi

echo "Ensure docker is up and running"
if [ "`systemctl is-active docker`" != "active" ]
   then
    echo "docker is running so attempting restart"
    systemctl start docker
    systemctl enable docker
    systemctl is-active docker
fi

echo 'Installing Mailcatcher'
# Source Repository / Contribute / Fork this project on Github. https://github.com/danydavila/centos-mailcatcher
sudo docker pull danydavila/centos-mailcatcher
sudo docker run --name mailcatcher --restart on-failure:5 -p 1025:1025 -p 1080:1080 -d danydavila/centos-mailcatcher
sudo cp -f /etc/postfix/main.cf /etc/postfix/main.cf.bk
# sudo sh -c "echo 'relayhost = 127.0.0.1:1025' >> /etc/postfix/main.cf"
sudo sed -i -r "s#relayhost = (.*)#relayhost = 127.0.0.1:1025#g" /etc/postfix/main.cf
sudo postsuper -d ALL && sudo postsuper -d ALL deferred
sudo systemctl restart postfix
echo "Test Email" | mail -s "Welcome to CentBox" test@domain.com
echo "Login To MailCatcher"
echo "http://127.0.0.1:1080"

echo 'Installing PHPMyAdmin'
sudo docker run --name phpmyadmin --restart on-failure:5 -e PMA_HOST=$IPADDRESS -p 8080:80 -d phpmyadmin/phpmyadmin

echo "Login To PHPMyAdmin"
echo "http://127.0.0.1:8080"
echo "username: admin"
echo "username: centbox"

if [ -f /srv/database/init.sql ]
  then
    echo "Running /srv/database/init.sql"
    sudo mysql --host=localhost --user=root < /srv/database/init.sql
fi

# Let this script know not to run again
sudo touch /var/vagrant_provisioned

# exit this scripts successfully
exit 0;