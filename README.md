# CentBox

That setup is heavily inspired by [Laravel Homestead](https://laravel.com/docs/5.4/homestead).

## What's inside ##

* CentOS 7.4 (1708) x86_64 build (3.10.0-693.21.1.el7.x86_64)
* Docker version 17.12.1-ce, build 7390fc6
* Nginx 1.12.2
* PHP-FPM 5.6 & PHP-FPM 7.1
* MySQL 5.6 (Percona)
* NodeJS v8.10.0 LTS
* Javascript Package Manager (npm)
* PHP Composer & PHPunit
* Python 2.7.5
* Perl 5, version 16
* Ansible 2.4.2.0
* epel-release enabled
* Git, visudo, Nano, wget, curl, netool, tree, p7zip, nmap-ncat, zip, htop, rSync, and others basic linux tools. 

## Prerequisites ##

1. Linux or Mac
2. Vagrant ([latest version](https://www.vagrantup.com/downloads.html))
4. Virtual Box ([download](https://www.virtualbox.org/wiki/Downloads))
 
## Documentation ##

* MacOS Port Forwarding  ([download](https://github.com/danydavila/CentBox/tree/master/docs/MacOS-PortForwarding.md))
* PHP config  ([download](https://github.com/danydavila/CentBox/tree/master/docs/CentBox-PHP.md))
* Vagrant Example ([download](https://github.com/danydavila/CentBox/tree/master/docs/Vagrant-CentBox.md))
    
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
