#!/bin/bash
cd /maria_install
service mariadb start && sleep 10 && script -c 'mysql_secure_installation' < response_file.txt
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf && cat /etc/mysql/mariadb.conf.d/50-server.cnf | grep bind
sed -i 's/MYSQL_DB_NAME/${MYSQL_DB_NAME}/g; s/ARG_POWER_USER/${POWER_USER}/g; s/ARG_PU_PWD/${PU_PWD}/g' create_db_user.sql
## INSERT SQL HERE - START -- CUSTOMIZATION, USER Creation and DB Creation Script. Use either .sh or .sql file.
service mariadb start && sleep 5 && mysql -uroot -p${ROOT_PWD} < create_db_user.sql
##RUN /bin/bash -c "service mariadb start && sleep 5 && ./create_db_user.sh"
## INSERT SQL HERE - END
## Cleanup installation artifacts for security reasons.
cd /
rm -rf /maria_install
##RUN /bin/bash -c 'service mariadb start && tail -f /dev/null'
/usr/sbin/service mariadb start && /usr/bin/tail -f /dev/null
