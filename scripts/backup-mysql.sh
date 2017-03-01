#!/usr/bin/env bash

USER="root"
PASSWORD=""
OUTPUT="/srv/database/backups"
DATE=`date +%Y-%m-%d_%H:%M:%S`

# Delete files older than X days (currently 30 days)
find $OUTPUT/*.sql -mtime +30 -exec rm {} \;

databases=`mysql --user=$USER --password=$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
    if [[ "$db" != "mysql" ]]&& [[ "$db" != "performance_schema" ]] && [[ "$db" != "information_schema" ]] && [[ "$db" != _* ]];
    then
        echo "Dumping database: $db"
        mysqldump --force --opt --user=$USER --password=$PASSWORD --databases $db > $OUTPUT/$DATE.$db.sql
        gzip $OUTPUT/$DATE.$db.sql
    fi
done