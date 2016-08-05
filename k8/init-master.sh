#!/bin/bash

source /vagrant/common.sh

update_host master

sudo yum -y install etcd kubernetes

echo ETCD_NAME=default | sudo tee /etc/etcd/etcd.conf
echo ETCD_DATA_DIR="/var/lib/etcd/default.etcd" | sudo tee -a /etc/etcd/etcd.conf
echo ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379" | sudo tee -a /etc/etcd/etcd.conf
echo ETCD_ADVERTISE_CLIENT_URLS="http://localhost:2379" | sudo tee -a /etc/etcd/etcd.conf

echo KUBE_API_ADDRESS="--address=0.0.0.0" | sudo tee /etc/kubernetes/apiserver
echo KUBE_API_PORT="--port=8080" | sudo tee -a /etc/kubernetes/apiserver
echo KUBELET_PORT="--kubelet_port=10250" | sudo tee -a /etc/kubernetes/apiserver
echo KUBE_ETCD_SERVERS="--etcd_servers=http://127.0.0.1:2379" | sudo tee -a /etc/kubernetes/apiserver
echo KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=172.17.0.0/16" | sudo tee -a /etc/kubernetes/apiserver
echo KUBE_ADMISSION_CONTROL="--admission_control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ResourceQuota" | sudo tee -a /etc/kubernetes/apiserver
echo KUBE_API_ARGS="" | sudo tee -a /etc/kubernetes/apiserver

for SVC in etcd kube-apiserver kube-controller-manager kube-scheduler; do
  systemctl restart $SVC
  systemctl enable $SVC
  systemctl status $SVC
done

etcdctl mk /atomic.io/network/config '{"Network":"172.17.0.0/16"}'
