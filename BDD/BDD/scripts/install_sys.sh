#!/bin/bash
## install base system
## [GV JL] Creation d'un script qui installe tous les packages necessaires à
## une VM LAMP (Linux Apache Mysql PHP)

APT_OPT="-o Dpkg::Progress-Fancy="0" -q -y"
LOG_FILE="/vagrant/logs/install_sys.log"
DEBIAN_FRONTEND=noninteractive

echo "START - Install Base System"

echo "=> [1]: Installing system packages..."
apt-get update $APT_OPT \
  >> $LOG_FILE 2>&1

apt-get install $APT_OPT \
  wget \
  gnupg \
  unzip \
  git \
  >> $LOG_FILE 2>&1

echo "END - install Base System"