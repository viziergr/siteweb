#!/bin/bash

## Relier les deux VM

APT_OPT="-o Dpkg::Progress-Fancy="0" -q -y"
LOG_FILE="/vagrant/logs/modif_pass.log"
DEBIAN_FRONTEND="noninteractive"

echo "START - Modification des mots de passe "

mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('root');"

echo "END - Modification des mots de passe"

service mariadb restart
