# k8

Run a kubernetes setup locally with Vagrant.

## Configure DNS

Setup the kube-system namespace

    kubectl create namespace kube-system

Deploy DNS

    kubectl create -f /vagrant/pods/kube-dns-rc.yaml


## Deploy the kubernetes dashboard

The kube-system namespace and DNS are pre-requisites.

    kubectl create -f /vagrant/pods/kubernetes-dashboard.yaml

## Basic example running nginx

    kubectl run nginx --image=nginx --replicas=2 --port=80

This didn't work locally on vagrant

    kubectl expose deployment nginx --port=80

Explicitly expose a deployment on a particular IP

    kubectl expose deployment nginx --port=80 --external-ip=192.168.1.81

## Basic example running a custom container

Create the pod

    kubectl create -f /vagrant/pods/node-demo-pod.yml

Create the service

    kubectl create -f /vagrant/pods/node-demo-svc.yml
