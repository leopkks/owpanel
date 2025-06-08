#!/bin/bash

# Path to the file containing MySQL root password
MYSQL_PASS_FILE="/usr/local/lsws/Example/html/mypanel/etc/mysqlPassword"

# Read password from the file
MYSQL_PASSWORD=$(cat "$MYSQL_PASS_FILE")

# Database and user info
DB_NAME="panel"
DB_USER="root"

# SQL to add new integer column with default 0
SQL="ALTER TABLE packages ADD COLUMN allowed_subdomains INT DEFAULT 0;"

# Run the query
mysql -u "$DB_USER" -p"$MYSQL_PASSWORD" "$DB_NAME" -e "$SQL" > /dev/null 2>&1

SQL2="ALTER TABLE backup ADD COLUMN user_access INT DEFAULT 0;"

# Run the query
mysql -u "$DB_USER" -p"$MYSQL_PASSWORD" "$DB_NAME" -e "$SQL2" > /dev/null 2>&1

