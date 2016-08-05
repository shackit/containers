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

sudo hostnamectl set-hostname manager --static
sudo hostnamectl set-hostname worker1 --static
sudo hostnamectl set-hostname worker2 --static

To start a swarm cluster, issue the following on the master:

	$ sudo docker swarm init --advertise-addr 192.168.1.20:2377

	sudo docker swarm join \
    --token SWMTKN-1-1yv6abz31eyiq0d0fgk071j3t9t5klvpgr4fgq5an5r3kggs4g-43ozdn45nmcj2qfquysceit0w \
    192.168.1.20:2377

### Creaete a service

	sudo docker service create --replicas 1 --name node-demo shackit/node-demo

	sudo docker service create --replicas 1 --name node-demo --publish 8080:8080 shackit/node-demo

	sudo docker service create --replicas 1 --name node-demo --publish 30001:8080 shackit/node-demo

## Inspect the service

	sudo docker service inspect node-demo

	sudo docker service inspect --format='{{.Spec.Mode.Replicated.Replicas}}' node-demo

## Scale a service

	sudo docker service scale node-demo=3
