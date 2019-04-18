#!/bin/bash
sudo su
cd
apt-get update -y
apt-get install apache2 -y
service apache2 start
chkconfig apache2 on
cd /var/www/html
