#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Update:
sudo yum -y update

# Install Docker - 1.12.0-rc4:
curl -fsSL https://get.docker.com/ | sh

# Enable and start the docker daemon:
sudo systemctl enable docker
sudo systemctl start docker
