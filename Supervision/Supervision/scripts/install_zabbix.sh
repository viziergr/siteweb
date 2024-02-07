#!/bin/bash

## install Mariadb server (ex Mysql))

APT_OPT="-o Dpkg::Progress-Fancy="0" -q -y"
DEBIAN_FRONTEND="noninteractive"
LOG_FILE="/vagrant/logs/install_zabbix.log"

echo "START - Install Zabbix"

echo "[1] - Téléchargement du package Zabbix"
cd /tmp/
wget https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/zabbix-release_6.4-1+debian11_all.deb >> $LOG_FILE 2>&1 

echo "[2] - Installation du package Zabbix"
dpkg -i zabbix-release_6.4-1+debian11_all.deb >> $LOG_FILE 2>&1
apt update -y >> $LOG_FILE 2>&1

echo "[3] - Installation de Mariadb"
apt-get install $APT_OPT \
	mariadb-server \
	mariadb-client \
   >> $LOG_FILE 2>&1

echo "[4] - Installation des dépendances de Zabbix"
apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent -y >> $LOG_FILE 2>&1

echo "[5] - Création de la base de données et de l'utilisateur zabbix"
mysql -e "create database zabbix character set utf8mb4 collate utf8mb4_bin;"
mysql -e "create user zabbix@localhost identified by 'zabbix';"
mysql -e "grant all privileges on zabbix.* to zabbix@localhost;"
mysql -e "set global log_bin_trust_function_creators = 1;"

echo "[6] - Création automatique des tables"
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -pzabbix zabbix >> $LOG_FILE 2>&1

echo "[7] - Dernières modifications mineures"
mysql -e "set global log_bin_trust_function_creators = 0;"
sed -i "s/# DBPassword=/DBPassword=zabbix/g" /etc/zabbix/zabbix_server.conf

echo "[8] - Restart des services pour que les changements prennent effet"
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2

echo "STOP - Install Zabbix"