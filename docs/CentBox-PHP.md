# CentBox PHP
### Nginx & PHP

        PHP-FPM 5.6 is running on port 9000
        PHP-FPM 7.1 is running on port 9001
        
Enable specific version on your vhost file

        include /etc/nginx/sites_conf/common_php71.conf;
        include /etc/nginx/sites_conf/common_php56.conf;

### Find out PHP version

    php56 -v
    php71 -v

### PHP.ini path

    /etc/opt/remi/php71/php.ini  
    /opt/remi/php56/root/etc/php.ini 
 
### Search for available PHP modules

    sudo yum --enablerepo=remi-php71 search mongo
    sudo yum --enablerepo=remi-php71 search cassandra

### Install Aditional PHP module

    sudo yum -y --enablerepo=remi-php56 install php56-php-pecl-xdebug
    sudo yum -y --enablerepo=remi-php71 install php71-php-pecl-xdebug
    
### PHP 5.6 Systemctl

    sudo systemctl start php56-php-fpm
    sudo systemctl status php56-php-fpm
    sudo systemctl stop php56-php-fpm
    sudo systemctl restart php56-php-fpm
    sudo systemctl enable php56-php-fpm
    sudo systemctl disable php56-php-fpm

### PHP 7.1 Systemctl

    sudo systemctl start php71-php-fpm
    sudo systemctl status php71-php-fpm
    sudo systemctl stop php71-php-fpm
    sudo systemctl restart php71-php-fpm
    sudo systemctl enable php71-php-fpm
    sudo systemctl disable php71-php-fpm

