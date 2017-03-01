#!/usr/bin/env bash

# Author: Dany Davila <danydavila@gmail.com>
# Description: Sync configuration files from host to guest vm and reload nginx

sudo chown -R root:root /srv/config
sudo rsync -rlptgoDchW --progress --stats \
--exclude='$RECYCLE.BIN' --exclude='$Recycle.Bin' --exclude='.AppleDB' \
--exclude='.AppleDesktop' --exclude='.AppleDouble' \
--exclude='.com.apple.timemachine.supported' --exclude='.dbfseventsd' \
--exclude='.DocumentRevisions-V100*' --exclude='.DS_Store' \
--exclude='.fseventsd' --exclude='.PKInstallSandboxManager' \
--exclude='.Spotlight*' --exclude='.SymAV*' --exclude='.symSchedScanLockxz' \
--exclude='.TemporaryItems' --exclude='.Trash*' --exclude='.vol' \
--exclude='.VolumeIcon.icns' --exclude='Desktop DB' --exclude='Desktop DF' \
--exclude='hiberfil.sys' --exclude='lost+found' --exclude='Network Trash Folder'\
--exclude='pagefile.sys' --exclude='Recycled' --exclude='RECYCLER' \
--exclude='System Volume Information' --exclude='Temporary Items' \
--exclude='Thumbs.db' --exclude='.vagrant' --exclude='.git' --exclude='.gitkeep' \
/srv/config/ /

echo "Fixing Nginx config files for vagrant"
# https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/#virtualbox
# fixed virutalbox weird character at the end of the file
echo "Updating Nginx Configuration"
sudo sudo sed -i 's/^worker_processes.*/worker_processes 1;/' /etc/nginx/nginx.conf
sudo sudo sed -i "s/sendfile.*on/sendfile off/" /etc/nginx/nginx.conf

echo "Fixing Nginx config files for vagrant"
# https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/#virtualbox
# fixed virutalbox weird character at the end of the file
echo "Updating Nginx Configuration"
sudo sudo sed -i 's/^worker_processes.*/worker_processes 1;/' /etc/nginx/nginx.conf
sudo sudo sed -i "s/sendfile.*on/sendfile off/" /etc/nginx/nginx.conf

echo "Ensuring files exists and fixing Nginx file permissions"
if [[ ! -d "/var/log/nginx" ]]; then sudo mkdir -p "/var/log/nginx"; fi
if [[ ! -f "/var/log/nginx/access.log" ]]; then sudo touch "/var/log/nginx/access.log"; fi
if [[ ! -f "/var/log/nginx/error.log" ]]; then sudo touch "/var/log/nginx/error.log"; fi
sudo chown -R nginx:nginx /var/log/nginx;

echo "Ensuring files exists and fixing PHP file permissions"
if [[ ! -d "/var/log/php" ]]; then sudo mkdir -p "/var/log/php"; fi
if [[ ! -f "/var/log/php/php_error.log" ]]; then sudo touch "/var/log/php/php_error.log"; fi
if [[ ! -f "/var/log/php/php56_error.log" ]]; then sudo touch "/var/log/php/php56_error.log"; fi
if [[ ! -f "/var/log/php/php70_error.log" ]]; then sudo touch "/var/log/php/php70_error.log"; fi


echo "Updating PHP 5.6 php.ini Configuration"
sudo sed -i 's/short_open_tag = Off/short_open_tag = On/' /opt/remi/php56/root/etc/php.ini
sudo sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /opt/remi/php56/root/etc/php.ini
sudo sed -i 's/;date.timezone =.*/date.timezone = UTC/'  /opt/remi/php56/root/etc/php.ini
sudo sed -i 's/date.timezone =.*/date.timezone = UTC/'  /opt/remi/php56/root/etc/php.ini
sudo sed -i 's/log_errors = Off/log_errors = On/'  /opt/remi/php56/root/etc/php.ini
sudo sed -i 's/html_errors = Off/html_errors = On/'  /opt/remi/php56/root/etc/php.ini
sudo sed -i 's/display_errors = Off/display_errors = On/' /opt/remi/php56/root/etc/php.ini
sudo sed -i 's/error_log = .*/error_log = \/var\/log\/php\/php56_error.log/'  /opt/remi/php56/root/etc/php.ini
sudo sed -i 's/expose_php = Off/expose_php = On/'  /opt/remi/php56/root/etc/php.ini
sudo sed -i 's/error_reporting = E_ALL \& \~E_DEPRECATED \& \~E_STRICT/error_reporting = E_ALL/'  /opt/remi/php56/root/etc/php.ini
sudo sed -i 's/allow_url_fopen = Off/allow_url_fopen = On/'  /opt/remi/php56/root/etc/php.ini
sudo sed -i 's/allow_url_include = On/allow_url_include = Off/'  /opt/remi/php56/root/etc/php.ini
sudo sed -i 's/file_uploads = Off/file_uploads = On/' /opt/remi/php56/root/etc/php.ini

echo "Updating PHP 5.6 PHP-FPM Pool Configuration"
sudo sed -i 's/php_admin_value\[error_log\] = .*/php_admin_value[error_log] = \/var\/log\/php\/php56_error.log/'  /opt/remi/php56/root/etc/php-fpm.d/www.conf
sudo sed -i 's/user = .*/user = vagrant/'  /opt/remi/php56/root/etc/php-fpm.d/www.conf
sudo sed -i 's/group = .*/group = www-users/'  /opt/remi/php56/root/etc/php-fpm.d/www.conf

sudo systemctl restart php56-php-fpm
sudo systemctl restart php70-php-fpm

sudo nginx -t
sudo nginx -s reload
sudo systemctl restart nginx
sudo systemctl status nginx

echo "Fixing User SSH files permissions"
sudo chmod 700 /home/vagrant/.ssh
sudo chown vagrant:apache /home/vagrant/.ssh/authorized_keys
sudo chmod 600 /home/vagrant/.ssh/authorized_keys

echo 'Fixing MySQL permission'
sudo chmod 0644 /etc/my.cnf

echo "Fixing Web Server File config files permissions"
# stat -c "%a %n" /var/www
#sudo chmod 777 /var/www
sudo chown -R vagrant:apache /var/www
sudo chown -R vagrant:apache /home/vagrant

# exit this scripts successfully
exit 0;

