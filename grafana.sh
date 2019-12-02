#!/bin/bash
wget https://grafanarel.s3.amazonaws.com/builds/grafana_3.0.2-1463383025_amd64.deb
sudo apt-get install -y adduser libfontconfig
sudo dpkg -i grafana_3.0.2-1463383025_amd64.deb
sudo echo "deb https://packagecloud.io/grafana/stable/debian/ wheezy main" > /etc/apt/sources.list.d/grafana.list
curl https://packagecloud.io/gpg.key | sudo apt-key add -
sudo apt-get update
sudo apt-get install grafana
sudo apt-get install -y apt-transport-https

echo "Installs binary to /usr/sbin/grafana-server
Installs Init.d script to /etc/init.d/grafana-server
Creates default file (environment vars) to /etc/default/grafana-server
Installs configuration file to /etc/grafana/grafana.ini
Installs systemd service (if systemd is available) name grafana-server.service
The default configuration sets the log file at /var/log/grafana/grafana.log
The default configuration specifies an sqlite3 db at /var/lib/grafana/grafana.db"

sudo service grafana-server start
