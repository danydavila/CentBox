# CentBox

That setup is heavily inspired by [Laravel Homestead](https://laravel.com/docs/5.4/homestead).

## What's inside ##

* CentOS 7.2.1511 64-bit
* Docker version 1.13.1
* Nginx 1.10.3
* PHP-FPM 5.6 & PHP-FPM 7.1
* MySQL 5.6 (Percona)
* NodeJS LTS
* Javascript Package manager (npm)
* Composer & PHPunit
* Redis
* Memcached
* Git, Nano, Rsync, etc.

## Prerequisites ##

1. Linux or Mac
2. Vagrant ([latest version](https://www.vagrantup.com/downloads.html))
4. Virtual Box ([download](https://www.virtualbox.org/wiki/Downloads))
    
## Setup steps ##

1. Copy `vagrant.example.yaml` to `vagrant.yaml`

    `cp vagrant.example.yaml vagrant.yaml`

2. Open `vagrant.yaml` with your favorite editor.

  * Change the box IP address (if needed).
  * Change to box name to your liking.
  * Set the amount of RAM for the box (MB).
  * Change any other settings, though default are usually sufficient.

3. Customize your box enviroment.

    `cp -r default/ user/`

4. Run `vagrant up`. You will be asked for your system password in the beginning and in the end of the installation.

5. Run `vagrant ssh` to login to your box. All sites folders are in `/user/sites` derectory.
