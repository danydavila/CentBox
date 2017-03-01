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

#ensure docker is up and running
if [ "`systemctl is-active docker`" != "active" ]
   then
    echo "docker is running so attempting restart"
    systemctl start docker
    systemctl enable docker
    systemctl is-active docker
fi

mailcatcher_setup() {
  echo 'installing mailcatcher_setup'
}

if [ -f /srv/database/init.sql ]
  then
    echo "Running /srv/database/init.sql"
    sudo mysql --host=localhost --user=root < /srv/database/init.sql
fi

# Let this script know not to run again
sudo touch /var/vagrant_provisioned

# exit this scripts successfully
exit 0;