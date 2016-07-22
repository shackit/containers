#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Update:
sudo yum -y clean all
sudo yum -y update

# Download Docker some pre-requisites for compose:
sudo yum -y install docker

# Enable and start the docker daemon:
sudo systemctl enable docker.service
sudo systemctl start docker.service

# Build the docker image:
cd /vagrant/node
sudo docker build -t 'shackit/docker-demo' .

# Launch the docker container from image:
sudo docker run -d -p 8080:8080 'shackit/docker-demo'
