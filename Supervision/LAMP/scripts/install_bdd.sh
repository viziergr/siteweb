#!/bin/bash

## install Mariadb server (ex Mysql))

APT_OPT="-o Dpkg::Progress-Fancy="0" -q -y"
LOG_FILE="/vagrant/logs/install_bdd.log"
DEBIAN_FRONTEND="noninteractive"
MYADMIN_VERSION="5.1.1"

echo "START - install MariaDB"
echo "=> [1]: Install required packages ..."
DEBIAN_FRONTEND=noninteractive
WWW_REP="/var/www/html"

apt-get install $APT_OPT \
	mariadb-server \
	mariadb-client \
   >> $LOG_FILE 2>&1

echo "END - install MariaDB"

echo "START - Installation de phpMyAdmin "

echo "=> [1]: Install required packages ...."
apt-get install $APT_OPT \
  openssl \
  php-mbstring \
  php-zip \
  php-gd \
  php-xml \
  php-pear \
  php-gettext \
  php-cgi \
  >> $LOG_FILE 2>&1

echo "=> [2]: Download files"
wget -q -O /tmp/myadmin.zip \
https://files.phpmyadmin.net/phpMyAdmin/${MYADMIN_VERSION}/phpMyAdmin-${MYADMIN_VERSION}-all-languages.zip \
>> $LOG_FILE 2>&1

unzip /tmp/myadmin.zip -d ${WWW_REP} \
>> $LOG_FILE 2>&1

rm /tmp/myadmin.zip

echo "=> [3] - Configuration files for phpmyadmin  "
ln -s ${WWW_REP}/phpMyAdmin-${MYADMIN_VERSION}-all-languages ${WWW_REP}/myadmin
mkdir ${WWW_REP}/myadmin/tmp
chown www-data:www-data ${WWW_REP}/myadmin/tmp
randomBlowfishSecret=$(openssl rand -base64 32)
sed -e "s|cfg\['blowfish_secret'\] = ''|cfg['blowfish_secret'] = '$randomBlowfishSecret'|" \
  ${WWW_REP}/myadmin/config.sample.inc.php \
  > ${WWW_REP}/myadmin/config.inc.php

echo "=> [4] - Restarting Apache..."
service apache2 restart

echo "=> [5] - Modif mot de passe root"
mysql -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('root');"

echo "END - Configuration phpMyAdmin"
