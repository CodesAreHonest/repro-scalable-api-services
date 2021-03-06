#!/usr/bin/env bash

## 1. Configuring Master

docker exec -it ambc_master_db mysql -uroot -psecurerootpassword \
  -e "INSTALL PLUGIN rpl_semi_sync_master SONAME 'semisync_master.so';" \
  -e "SET GLOBAL rpl_semi_sync_master_enabled = 1;" \
  -e "SET GLOBAL rpl_semi_sync_master_wait_for_slave_count = 2;" \
  -e "SHOW VARIABLES LIKE 'rpl_semi_sync%';"

## 2. Configuring master node replication user and get the initial replication co-ordinates

docker exec -it ambc_master_db mysql -uroot -psecurerootpassword \
  -e "CREATE USER 'repl'@'%' IDENTIFIED WITH mysql_native_password BY 'slavepass';" \
  -e "GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';" \
  -e "SHOW MASTER STATUS;"

## 3. Configuring Slave

for N in 1 2; do
  docker exec -it ambc_slave_db_$N mysql -uroot -psecurerootpassword \
    -e "INSTALL PLUGIN rpl_semi_sync_slave SONAME 'semisync_slave.so';" \
    -e "SET GLOBAL rpl_semi_sync_slave_enabled = 1;" \
    -e "SHOW VARIABLES LIKE 'rpl_semi_sync%';"
done

## 4. Enable Logs
##  - The Error Log - It contains information about errors that occur while the server is running (also server start and stop)
##  - The General Query Log - This is a general record of what mysqld is doing (connect, disconnect, queries)
##  - The Slow Query Log -  Ιt consists of "slow" SQL statements (as indicated by its name).
docker exec -it ambc_master_db mysql -uroot -psecurerootpassword \
  -e "SET GLOBAL general_log = 'on';" \
  -e "SET GLOBAL slow_query_log = 'on';" \
  -e "SET GLOBAL long_query_time = 1;" \
  -e "SET GLOBAL log_output = 'table';" 


## 5. Show Master Status
docker exec -it ambc_master_db mysql -uroot -psecurerootpassword \
  -e "SHOW MASTER STATUS;"
