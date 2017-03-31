#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Update:
sudo yum -y clean all
sudo yum -y update

# Install pip & docker
sudo yum -y install python-pip docker

# Pip is out of date on CentOS7
sudo pip install --upgrade pip

# Install Docker Compose
sudo pip install docker-compose

# Enable and start the docker daemon:
sudo systemctl enable docker.service
sudo systemctl start docker.service

# Compose Lifecycle
#
# Start the stack defined in /vagrant/docker-compose.yaml
#
# pushd /vagrant
# sudo docker-compose up
#
# Stop the stack defined in /vagrant/docker-compose.yaml
# sudo docker-compose stop
#
# Removed the stack
# sudo docker-compose rm -f

# Jenkins Project Blue
#sudo docker run -d -p 8080:8080 \
#--env JAVA_OPTS="-Djenkins.install.runSetupWizard=false" \
#--name=jenkins-blue-master jenkinsci/blueocean:latest
