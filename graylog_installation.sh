#!/bin/bash

# WARNING: Don't use this in production since all passwords are kept at their default.
#This script is helpfull in installation of the graylog, elasticsearch, mongodb and java since these are the dependency of graylog-server
#graylog-web will be also installed using this

#after successful installation graylog can be accessed from

#http://serverip:9000
#default user name and password will be
#admin/password
#before running this script please confirm that user is added in suduers list

# mongodb
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
sudo apt-get update
sudo apt-get install mongodb-org

# Install Java
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install oracle-java8-installer


# elastic search
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/1.7/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-1.7.x.list
sudo apt-get update
sudo apt-get -y install elasticsearch
sudo update-rc.d elasticsearch defaults 95 10
curl -XGET 'http://localhost:9200/_cluster/health?pretty=true'

# Graylog
wget https://packages.graylog2.org/repo/packages/graylog-1.3-repository-ubuntu14.04_latest.deb
sudo dpkg -i graylog-1.3-repository-ubuntu14.04_latest.deb
sudo apt-get update
sudo apt-get install apt-transport-https
sudo apt-get install graylog-server
sudo apt-get install pwgen
SECRET=$(pwgen -s 96 1)
sudo -E sed -i -e 's/password_secret =.*/password_secret = '$SECRET'/' /etc/graylog/server/server.conf

# generate the admin password for graylog (replace password by yourpassword)
PASSWORD=$(echo -n password | shasum -a 256 | awk '{print $1}')
sudo -E sed -i -e 's/root_password_sha2 =.*/root_password_sha2 = '$PASSWORD'/' /etc/graylog/server/server.conf

## edit the file /etc/graylog/server/server.conf 
#rest_transport_uri = http://127.0.0.1:12900/
#elasticsearch_shards = 1
#elasticsearch_cluster_name = graylog-development
#elasticsearch_discovery_zen_ping_multicast_enabled = false
#elasticsearch_discovery_zen_ping_unicast_hosts = 127.0.0.1:9300
sudo start graylog-server



## Install Graylog-web

sudo apt-get install graylog-web
SECRET=$(pwgen -s 96 1)
sudo -E sed -i -e 's/application\.secret=""/application\.secret="'$SECRET'"/' /etc/graylog/web/web.conf

## now open sudo vi /etc/graylog/web/web.conf
#graylog2-server.uris="http://127.0.0.1:12900/"

sudo start graylog-web

##Configure Graylog to Receive syslog messages
#In a web browser:
#http://graylog_public_IP:9000/



#######################
#Create Syslog UDP Input

#To add an input to receive syslog messages, click on the System drop-down in the top menu.

#Now, from the drop-down menu, select Inputs.

#Select Syslog UDP from the drop-down menu and click the Launch new input button.

#A "Launch a new input: Syslog UDP" modal window will pop up. Enter the following information (substitute in your server's private IP address for the bind address):

#Title: syslog
#Port: 8514
#Bind address: graylog_private_IP

###################################

#######Configure Rsyslog to Send Syslogs to Graylog Server
#On all of your client servers, the servers that you want to send syslog messages to Graylog, do the following steps.

#Create an rsyslog configuration file in /etc/rsyslog.d. We will call ours 90-graylog.conf:

#sudo vi /etc/rsyslog.d/90-graylog.conf
#In this file, add the following lines to configure rsyslog to send syslog messages to your Graylog server (replace graylog_private_IP with your Graylog server's private IP address):

#/etc/rsyslog.d/90-graylog.conf
#$template GRAYLOGRFC5424,"<%pri%>%protocol-version% %timestamp:::date-rfc3339% %HOSTNAME% %app-name% %procid% %msg%\n"
#*.* @graylog_private_IP:8514;GRAYLOGRFC5424
#Save and quit. This file will be loaded as part of your rsyslog configuration from now on. Now you need to restart rsyslog to put your change into effect.

#sudo service rsyslog restart
#After you are finished configuring rsyslog on all of the servers you want to monitor, go back to the Graylog web interface.

#Viewing Your Graylog Sources
#In your favorite web browser, go to the port 9000 of your server's public IP address:

#In a web browser:
#http://graylog_public_IP:9000/
#Click on Sources in the top bar. You will see a list of all of the servers that you configured rsyslog on.

#The hostname of the sources is on the left, with the number of messages received by Graylog on the right.





# graylog2


#paushd /opt/graylog2
#    ln -sf graylog2-server-0.9.6p1 graylog2-server
#    cp graylog2-server/graylog2.conf.example /etc/graylog2.conf
#popd

#cat <<EOF | mongo
#use graylog2
#db.addUser("grayloguser", "123")
#exit
#EOF

