#!/bin/bash
# Self-Signed Certificate Generator
# Author: Dany Davila <danydavila@gmail.com>
# Description: Generate a generate a self-signed SSL certificate and key

#Required
DOMAIN=$1
FILESNAME=$2
FILESNAME=centbox

SSL_DIR="/etc/nginx/ssl"
KEY_PATH=$SSL_DIR/$FILESNAME.key
CSR_PATH=$SSL_DIR/$FILESNAME.csr
CRT_PATH=$SSL_DIR/$FILESNAME.crt
SSL_CONFIG="/etc/nginx/sites_conf/common_ssl.conf"

echo "Removing all files";
sudo rm -f $KEY_PATH;
sudo rm -f $CSR_PATH;
sudo rm -f $CRT_PATH;
sudo rm -f $SSL_CONFIG;

#Change to your company details
commonname=$DOMAIN
country=US
state=NC
locality=Charlotte
organization=CentBox
organizationalunit=CentBox
email=noreply@localdomain.localhost

# Generate a passphrase
echo "Generating key passphrase for $KEY_PATH";
PASSPHRASE=$(head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head -c 128; echo)

echo "Generating key request for $DOMAIN"
sudo openssl genrsa -des3 -passout pass:$PASSPHRASE -out $KEY_PATH 4096 -noout

#Remove passphrase from the key. Comment the line out to keep the passphrase
# Strip the password so we don't have to type it every time we restart Apache
echo "Removing passphrase from key $KEY_PATH"
sudo openssl rsa -in $KEY_PATH -passin pass:$PASSPHRASE -out $KEY_PATH

#Create the request
echo "Creating CSR at $CSR_PATH"
sudo openssl req -new -nodes -sha256 -key $KEY_PATH -out $CSR_PATH -passin pass:$PASSPHRASE \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

# Generate the cert (good for 10 years)
echo "Generating certificate at $CRT_PATH that will be good for 10 years";
sudo openssl x509 -req -days 3650 -in $CSR_PATH -signkey $KEY_PATH -out $CRT_PATH

if [ -f "$SSL_DIR/dh4096.pem" ]
then
	echo "File $SSL_DIR/dh4096.pem found."
else
  echo "Generating stronger Ephemeral Diffie-Hellman (DHE) at $SSL_DIR/dh4096.pem ";
	openssl dhparam -out $SSL_DIR/dh4096.pem 4096
fi

sudo bash -c 'cat >> /etc/nginx/sites_conf/common_ssl.conf <<EOF
# Generated on: `date`
ssl  on;
ssl_prefer_server_ciphers On;
ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
ssl_ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!DSS:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-GCM-SHA384;
ssl_session_timeout           1d;
ssl_session_cache shared:SSL:50m;
ssl_certificate $CRT_PATH;
ssl_certificate_key $KEY_PATH;
ssl_dhparam $SSL_DIR/dh4096.pem;
EOF'

echo "on your nginx domain block copy/paste"
echo "include $SSL_CONFIG;";

# exit this scripts successfully
exit 0;
