#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Update:
sudo yum -y update

# Download Docker some pre-requisites for compose:
sudo yum -y install docker

# Enable and start the docker daemon:
sudo systemctl enable docker.service
sudo systemctl start docker.service
