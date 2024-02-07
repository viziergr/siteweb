#!/bin/bash

## install Mariadb server (ex Mysql))

APT_OPT="-o Dpkg::Progress-Fancy="0" -q -y"
LOG_FILE="/vagrant/logs/install_bdd.log"
DEBIAN_FRONTEND="noninteractive"
MYADMIN_VERSION="5.1.1"

echo "START - install MariaDB"

apt-get install $APT_OPT \
  mariadb-server \
  mariadb-client \
  >> $LOG_FILE 2>&1

echo "END - install MariaDB"
