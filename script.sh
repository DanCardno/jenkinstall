#!/bin/bash

# Directions
# 1) Copy script to a temp location, e.g. /tmp/InstallJenkins.sh
# 2) Make executable, e.g. chmod a+x /tmp/InstallJenkins.sh
# 3) Execute as su, e.g. sudo /tmp/InstallJenkins.sh

platform=`uname -v`

# Install and configure pre-requisites


if [[ "$platform" = *'Ubuntu'* ]] || [[ "$platform" = *'Debian'* ]]; then
##############################   Debian Install   ###################################
#Install and configure pre-requisites
clear
echo "* Start Deb / Ubuntu install"
sudo apt-get update
sudo apt-get install -y wget
sudo apt-get install -y apt-transport-https
sudo apt-get install -y default-jre
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
echo deb https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
sudo apt-get update
#install Jenkins
sudo apt-get install -y jenkins
#Change Port
sudo cp /etc/default/jenkins /etc/default/jenkins_org
sudo sed -i -e 's/8080/8000/' /etc/default/jenkins
#Firewall exception
sudo ufw allow 8000/tcp
#Start Jenkins
sudo service jenkins restart

clear
echo "* Install complete"
echo "* jenkins running on port 8000"
ips=($(hostname -I))
for ip in "${ips[@]}"
do
echo "* launch http://"$ip":8000"
done
################################ END DEBIAN INSTALL ############################

else

##############################   Centos Install   ###################################
# Install and configure pre-requisites
clear
echo "* Start Centos 7 install"
sudo yum install -y wget
sudo yum install -y java-1.8.0-openjdk.x86_64
sudo cp /etc/profile /etc/profile_backup
echo 'export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk' | sudo tee -a /etc/profile
echo 'export JRE_HOME=/usr/lib/jvm/jre' | sudo tee -a /etc/profile
source /etc/profile

# Install Jenkins

sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install -y jenkins

# Change Jenkins port

sudo cp /etc/sysconfig/jenkins /etc/sysconfig/jenkins_org
sudo sed -i -e 's/8080/8000/' /etc/sysconfig/jenkins

# Adjust firewall

sudo firewall-cmd --zone=public --permanent --add-port=8000/tcp
sudo firewall-cmd --reload

# Start and enable service
sudo systemctl start jenkins.service
sudo /sbin/chkconfig jenkins on

clear
echo "* Install complete"
echo "* jenkins running on port 8000"
ips=($(hostname -I))
for ip in "${ips[@]}"
do
echo "* launch http://"$ip":8000"
done

#################### END CENTOS INSTALL ############################################

fi


