#!/usr/bin/env bash

DB=$1;

sudo mysql --host=localhost --user=root -e "CREATE DATABASE IF NOT EXISTS \`$DB\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci";