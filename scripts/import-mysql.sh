#!/usr/bin/env bash
# ------------------------------------------------------------------
# Script Name: reload.nginx.sh
#
# Author: Dany Davila <danydavila@gmail.com>
# Move into the newly mapped backups directory, where mysqldump(ed) SQL files are stored

printf "\nStart MySQL Database Import\n"
cd /srv/database/import

# Parse through each file in the directory and use the file name to
# import the SQL file into the database of the same name
sql_count=`ls -1 *.sql 2>/dev/null | wc -l`
if [ $sql_count != 0 ]
then
	for file in $( ls -1 *.sql )
	do
	pre_dot=${file%%.sql}
	mysql_cmd='SHOW TABLES FROM `'$pre_dot'`' # Required to support hypens in database names
	db_exist=`sudo mysql --host=localhost --user=root --skip-column-names -e "$mysql_cmd"`
	if [ "$?" != "0" ]
	then
		printf "  * Error - Create $pre_dot database via init.sql before attempting import\n\n"
	else
		if [ "" == "$db_exist" ]
		then
			printf "mysql -uroot $pre_dot < $pre_dot.sql\n"
			sudo mysql --host=localhost --user=root $pre_dot < $pre_dot.sql
			printf "  * Import of $pre_dot successful\n"
		else
			printf "  * Skipped import of $pre_dot - tables exist\n"
		fi
	fi
	done
	printf "Databases imported\n"
else
	printf "No custom databases to import\n"
fi
# exit this scripts successfully
exit 0;