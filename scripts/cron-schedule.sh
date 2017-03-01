#!/usr/bin/env bash

#write out current crontab
touch /tmp/cron_dbbackup
crontab -l > /tmp/cron_dbbackup

#echo new cron into cron file
echo "0 * * * * /usr/bin/bash /srv/scripts/backup-mysql.sh >/dev/null" >> /tmp/cron_dbbackup

#install new cron file
crontab /tmp/cron_dbbackup

# restart cron service
sudo systemctl restart crond