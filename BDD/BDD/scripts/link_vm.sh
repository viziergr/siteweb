#!/bin/bash

## Relier les deux VM

IP=$(hostname -I | awk '{print $2}')

APT_OPT="-o Dpkg::Progress-Fancy="0" -q -y"
LOG_FILE="/vagrant/logs/linkvm.log"
DEBIAN_FRONTEND="noninteractive"

echo "START - Link des deux VM - "$IP
echo "=> [1] - Partie MySQL"

mysql -e "CREATE DATABASE BDD1;"
mysql -e "CREATE DATABASE BDD2;"

mysql -e "CREATE USER 'user1'@'%' identified by 'network';"
mysql -e "CREATE USER 'user2'@'%' identified by 'network';"
mysql -e "GRANT ALL PRIVILEGES ON BDD1.* TO 'user1'@'%' WITH GRANT OPTION;"
mysql -e "GRANT ALL PRIVILEGES ON BDD2.* TO 'user2'@'%' WITH GRANT OPTION;"
mysql -e "FLUSH PRIVILEGES;"

echo "=> [2] - Modification des fichiers de configuration"
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i 's/# port = 3306/port = 3306/g' /etc/mysql/my.cnf

service mariadb restart

echo "END - Link des deux VM"
