#!/bin/sh
find /var/log/mysql -type f | while read f; do sudo sh -c "echo -ne '' > $f;"; done;
tail -f /var/log/mysql/mysql-query.log