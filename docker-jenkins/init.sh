#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Update:
sudo yum -y update

# Install Docker - 1.12 variant's:
curl -fsSL https://get.docker.com/ | sh

# Enable and start the docker daemon:
sudo systemctl enable docker
sudo systemctl start docker

# Start Jenkins
sudo docker run -d -p 8080:8080 \
--env JAVA_OPTS="-Djenkins.install.runSetupWizard=false" \
--name=jenkins-master jenkins

# Project Blue
sudo docker run -d -p 8888:8080 \
--env JAVA_OPTS="-Djenkins.install.runSetupWizard=false" \
--name=jenkins-blue-master jenkinsci/blueocean:latest
