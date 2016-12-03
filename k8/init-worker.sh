#!/bin/bash

source /vagrant/common.sh

update_host worker

sudo yum -y install flannel kubernetes

# Configure the kubelet:
echo KUBELET_ADDRESS="--address=0.0.0.0" | sudo tee /etc/kubernetes/kubelet
echo KUBELET_PORT="--port=10250" | sudo tee -a /etc/kubernetes/kubelet
echo KUBELET_HOSTNAME="--hostname_override=192.168.1.81" | sudo tee -a /etc/kubernetes/kubelet
echo KUBELET_API_SERVER="--api_servers=http://${MASTER_IP}:8080" | sudo tee -a /etc/kubernetes/kubelet
echo KUBELET_ARGS="" | sudo tee -a /etc/kubernetes/kubelet

# Point flannel to Master IP:
sudo sed -i "s/FLANNEL_ETCD=\"http:\/\/127.0.0.1:2379\"/FLANNEL_ETCD=\"http:\/\/${MASTER_IP}:2379\"/g" /etc/sysconfig/flanneld

# Point kubernetes to Master IP:
sudo sed -i "s/KUBE_MASTER=\"--master=http:\/\/127.0.0.1:8080\"/KUBE_MASTER=\"--master=http:\/\/${MASTER_IP}:8080\"/g" /etc/kubernetes/config

# Enable and restart all kuberenets related services:
for SVC in kube-proxy kubelet docker flanneld; do
    systemctl restart $SVC
    systemctl enable  $SVC
    systemctl status  $SVC
done
