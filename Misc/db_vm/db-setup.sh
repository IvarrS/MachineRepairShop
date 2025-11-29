#!/bin/bash
set -e

# Create the socket directory
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

cat > /etc/mysql/conf.d/bind.cnf <<EOF
[mysqld]
bind-address = 0.0.0.0
EOF

mysqld_safe --skip-grant-tables &
MYSQL_PID=$!

# Wait for MariaDB to be ready
for i in {1..30}; do
    if mysql --socket=/run/mysqld/mysqld.sock -e "SELECT 1" 2>/dev/null; then
        break
    fi
    sleep 1
done

mysql --socket=/run/mysqld/mysqld.sock <<EOF
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MARIADB_DATABASE};
FLUSH PRIVILEGES;
EOF


mysqladmin --socket=/run/mysqld/mysqld.sock -uroot -p${MARIADB_ROOT_PASSWORD} shutdown
wait $MYSQL_PID


mysqld_safe &
MYSQL_PID=$!

for i in {1..30}; do
    if mysql -uroot -p${MARIADB_ROOT_PASSWORD} -e "SELECT 1" 2>/dev/null; then
        break
    fi
    sleep 1
done

mysql -uroot -p${MARIADB_ROOT_PASSWORD} ${MARIADB_DATABASE} < /docker-entrypoint-initdb.d/data.sql
IMPORT_EXIT_CODE=$?


wait $MYSQL_PID
