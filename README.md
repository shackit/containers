# Containers

> Local development with various containers/ container orchestrators and Vagrant.

## Useful commands

Build a docker image and tag it. Assumes a `Dockerfile` is in the current directory.

		$ sudo docker build -t 'shackit/docker-demo' .

Run the previously built docker image.

		$ sudo docker run 'shackit/docker-demo'

Run the previously built docker image, detached and expose port 8080.

		$ sudo docker run -d -p 8080:8080 'shackit/docker-demo'

Remove all docker containers.

		$ sudo docker rm $(sudo docker ps -a -q)

Removes a docker image, container needs to be removed first.

		$ sudo docker rmi %image_tag_or_id%

## Docker

> Purpose: Single docker host, hosting a single node.js container.

## Docker Compose

> Purpose: Single docker host, hosting an nginx container and two node.js containers

## Docker Swarm

> Purpose: Multi docker host
