#!/bin/bash

# this will install cassandra server over single node for testing or developement 
# the script is written for ubuntu14.04LTS
#Cassandra requires JRE to run its binary since it is developed on java


sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install oracle-java8-set-default -y
java -version
echo "deb http://www.apache.org/dist/cassandra/debian 22x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
echo "deb-src http://www.apache.org/dist/cassandra/debian 22x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
sudo gpg --keyserver pgp.mit.edu --recv-keys F758CE318D77295D
sudo gpg --export --armor F758CE318D77295D | sudo apt-key add -
sudo gpg --keyserver pgp.mit.edu --recv-keys 2B5C1B00
sudo gpg --export --armor 2B5C1B00 | sudo apt-key add -
sudo gpg --keyserver pgp.mit.edu --recv-keys 0353B12C
sudo gpg --export --armor 0353B12C | sudo apt-key add -
sudo apt-get update
sudo apt-get install cassandra
sudo service cassandra status
###___________________________troubleshoot cassendra for startup___________________
## if you see the out put as 
#Output
#* could not access pidfile for Cassandra
#then edit the init script of cassendra server 
#sudo nano +60 /etc/init.d/cassandra
#** this line should be in /etc/init.d/cassandra
#CMD_PATT="cassandra.+CassandraDaemon"
#cahnge it to 
#CMD_PATT="cassandra"
#you have to reboot the server 
#sudo reboot
#once started check for the status
#sudo service cassandra status
#it should be up and running, check for the status of the cluster
sudo nodetool status

#its status should be UN (Up and Normal)
# you can connect to cassendra server using 'cqlsh'


