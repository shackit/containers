#!/bin/bash

function download() {
  cd /tmp

  curl -L https://storage.googleapis.com/kubernetes-release/release/v1.3.0/bin/linux/amd64/kube-apiserver -O
  curl -L https://storage.googleapis.com/kubernetes-release/release/v1.3.0/bin/linux/amd64/kube-controller-manager -O
  curl -L https://storage.googleapis.com/kubernetes-release/release/v1.3.0/bin/linux/amd64/kube-scheduler -O
  curl -L https://storage.googleapis.com/kubernetes-release/release/v1.3.0/bin/linux/amd64/kubectl -O

  chmod +x kube-apiserver kube-controller-manager kube-scheduler kubectl

  sudo mv kube-apiserver kube-controller-manager kube-scheduler kubectl /usr/bin/
}

source ./common.sh

conf_dir=/var/lib/kubernetes

sudo mkdir -p ${conf_dir}

update_host master

download

# Kube API Service:
if [ ! -f /usr/lib/systemd/system/kube-apiserver.service ]; then
  sudo tee /usr/lib/systemd/system/kube-apiserver.service <<-EOF
    [Unit]
    Description=Kubernetes API Server
    Documentation=https://github.com/GoogleCloudPlatform/kubernetes

    [Service]
    ExecStart=/usr/bin/kube-apiserver \
    --admission-control=NamespaceLifecycle,LimitRanger,SecurityContextDeny,ResourceQuota \
    --advertise-address=192.168.1.21 \
    --allow-privileged=true \
    --apiserver-count=1 \
    --bind-address=0.0.0.0 \
    --enable-swagger-ui=true \
    --insecure-bind-address=0.0.0.0 \
    --etcd-servers=http://192.168.1.20:2379 \
    --service-cluster-ip-range=10.32.0.0/24 \
    --service-node-port-range=30000-32767 \
    --v=2
    Restart=on-failure
    RestartSec=5

    [Install]
    WantedBy=multi-user.target
		EOF
fi

# Kube Controller Service:
if [ ! -f /usr/lib/systemd/system/kube-controller-manager.service ]; then
	sudo tee -a /usr/lib/systemd/system/kube-controller-manager.service <<-EOF
		[Unit]
		Description=Kubernetes Controller Manager
		Documentation=https://github.com/GoogleCloudPlatform/kubernetes

		[Service]
		ExecStart=/usr/bin/kube-controller-manager \
			--allocate-node-cidrs=true \
			--cluster-cidr=10.200.0.0/16 \
			--cluster-name=kubernetes \
			--leader-elect=true \
			--master=http://192.168.1.21:8080 \
			--service-cluster-ip-range=10.32.0.0/24 \
			--v=2
		Restart=on-failure
		RestartSec=5

		[Install]
		WantedBy=multi-user.target
		EOF
fi

# Kube Scheduler:
if [ ! -f /usr/lib/systemd/system/kube-scheduler.service ]; then
	sudo tee -a /usr/lib/systemd/system/kube-scheduler.service <<-EOF
		[Unit]
		Description=Kubernetes Scheduler
		Documentation=https://github.com/GoogleCloudPlatform/kubernetes

		[Service]
		ExecStart=/usr/bin/kube-scheduler \
		  --leader-elect=true \
		  --master=http://192.168.1.21:8080 \
		  --v=2
		Restart=on-failure
		RestartSec=5

		[Install]
		WantedBy=multi-user.target
		EOF
fi

for SVC in kube-apiserver kube-controller-manager kube-scheduler; do
	systemctl enable $SVC
  systemctl restart $SVC
  systemctl status $SVC
done
