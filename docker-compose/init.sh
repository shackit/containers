#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Update:
sudo yum -y clean all
sudo yum -y update

# Download Docker some pre-requisites for compose:
sudo yum -y install epel-release
sudo yum -y install python-pip docker

# Install docker-compose:
sudo pip install docker-compose

# Enable and start the docker daemon:
sudo systemctl enable docker.service
sudo systemctl start docker.service

# issue with compose dependancy
# see https://github.com/docker/compose/issues/3428
sudo pip install backports.ssl_match_hostname --upgrade

# Finally launch our stack with compose:
pushd /vagrant
sudo docker-compose up -d
popd
