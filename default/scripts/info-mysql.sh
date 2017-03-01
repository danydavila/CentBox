#!/usr/bin/env bash

echo 'MySQL Version:'
sudo mysql --host=localhost --user=root -e "SELECT User,Host FROM mysql.user;"
sudo mysql --host=localhost --user=root -e "show databases;"
sudo mysqladmin --user=root version