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

> Purpose: To test out new swarm capability in Docker 1.12

https://docs.docker.com/engine/swarm/swarm-tutorial/

| host| ip  |
| --- | --- |
| manager |	192.168.1.20 |
| worker1	|	192.168.1.21 |
| worker2	|	192.168.1.22 |

To start a swarm cluster, issue the following on the master:

	$ sudo docker swarm init --listen-addr 192.168.1.20:2377

	No --secret provided. Generated random secret:
		0sa7rfalm42zgr6a7fu5pbdn9

	Swarm initialized: current node (cisgamwlwewdmzamot0dm7h7a) is now a manager.

	To add a worker to this swarm, run the following command:
		docker swarm join \
		--secret 0sa7rfalm42zgr6a7fu5pbdn9 \
		--ca-hash sha256:61ce413bfb2a43729a82e55591d69f927579d3a8b3ad565cd0bbda45e25b8049 \
		192.168.1.20:2377
