#!/bin/bash

function download() {
  cd /tmp

	# docker:
  curl -L https://get.docker.com/builds/Linux/x86_64/docker-1.11.2.tgz -O
	tar -xvf docker-1.11.2.tgz
	sudo cp docker/docker* /usr/bin/

	# CNI:
	curl -L https://storage.googleapis.com/kubernetes-release/network-plugins/cni-c864f0e1ea73719b8f4582402b0847064f9883b0.tar.gz -O
	sudo tar -xvf cni-c864f0e1ea73719b8f4582402b0847064f9883b0.tar.gz -C /opt/cni/

	# Kubernetes binaries:
	curl -L https://storage.googleapis.com/kubernetes-release/release/v1.3.0/bin/linux/amd64/kubectl -O
	curl -L https://storage.googleapis.com/kubernetes-release/release/v1.3.0/bin/linux/amd64/kube-proxy -O
	curl -L https://storage.googleapis.com/kubernetes-release/release/v1.3.0/bin/linux/amd64/kubelet -O

	chmod +x kubectl kube-proxy kubelet

	sudo mv kubectl kube-proxy kubelet /usr/bin/
}

source /vagrant/common.sh

update_host worker

conf_dir=/var/lib/kubernetes

sudo mkdir -p ${conf_dir}
sudo mkdir -p /var/lib/kubelet
sudo mkdir -p /opt/cni

download

# Kubeconfig:
if [ ! -f /var/lib/kubelet/kubeconfig ]; then
	sudo tee -a /var/lib/kubelet/kubeconfig <<-EOF
		apiVersion: v1
		kind: Config
		clusters:
		- cluster:
		    server: http://192.168.1.21:8080
		  name: kubernetes
		contexts:
		- context:
		    cluster: kubernetes
		    user: kubelet
		  name: kubelet
		current-context: kubelet
		EOF
fi

# Kubelet:
if [ ! -f /etc/systemd/system/kubelet.service ]; then
	sudo tee -a /etc/systemd/system/kubelet.service <<-EOF
		[Unit]
		Description=Kubernetes Kubelet
		Documentation=https://github.com/GoogleCloudPlatform/kubernetes
		After=docker.service
		Requires=docker.service

		[Service]
		ExecStart=/usr/bin/kubelet \
		  --allow-privileged=true \
		  --api-servers=http://192.168.1.21:8080 \
		  --cluster-dns=10.32.0.10 \
		  --cluster-domain=cluster.local \
		  --configure-cbr0=false \
		  --container-runtime=docker \
		  --docker=unix:///var/run/docker.sock \
		  --network-plugin=kubenet \
		  --kubeconfig=/var/lib/kubelet/kubeconfig \
		  --reconcile-cidr=true \
		  --serialize-image-pulls=false \
		  --v=2

		Restart=on-failure
		RestartSec=5

		[Install]
		WantedBy=multi-user.target
		EOF
fi

# Docker:
if [ ! -f /etc/systemd/system/docker.service ]; then
	sudo tee -a /etc/systemd/system/docker.service <<-EOF
		[Unit]
		Description=Docker Application Container Engine
		Documentation=http://docs.docker.io

		[Service]
		ExecStart=/usr/bin/docker daemon \
		  --iptables=false \
		  --ip-masq=false \
		  --host=unix:///var/run/docker.sock \
		  --log-level=error \
		  --storage-driver=overlay
		Restart=on-failure
		RestartSec=5

		[Install]
		WantedBy=multi-user.target
		EOF
fi

# Kube proxy:
if [ ! -f /etc/systemd/system/kube-proxy.service ]; then
	sudo tee -a /etc/systemd/system/kube-proxy.service ] <<-EOF
		[Unit]
		Description=Kubernetes Kube Proxy
		Documentation=https://github.com/GoogleCloudPlatform/kubernetes

		[Service]
		ExecStart=/usr/bin/kube-proxy \
		--master=http://192.168.1.21:8080 \
		--kubeconfig=/var/lib/kubelet/kubeconfig \
		--proxy-mode=iptables \
		--v=2

		Restart=on-failure
		RestartSec=5

		[Install]
		WantedBy=multi-user.target
		EOF
fi

for SVC in docker kubelet kube-proxy; do
	systemctl enable $SVC
	systemctl restart $SVC
	systemctl status $SVC
done

# delete the default docker0 if it exists
rc=0
ip link show docker0 >/dev/null 2>&1 || rc="$?"
if [[ "$rc" -eq "0" ]]; then
	sudo iptables -t nat -F
  sudo ip link set docker0 down
  sudo ip link delete docker0
fi

# create cbr0, if it doesn't exist already
cbr=0
ip link show cbr0 >/dev/null 2>&1 || cbr="$?"
if [[ ! "$cbr" -eq "0" ]]; then
  sudo ip link add name cbr0 type bridge
	sudo ip link set dev cbr0 mtu 1460
	sudo ip addr add 172.168.1.1/24 dev cbr0
	sudo ip link set dev cbr0 up
fi
