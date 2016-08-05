# k8s

	$ kubectl get componentstatuses

	$ kubectl get nodes

	$ kubectl run nginx --image=nginx --port=80 --replicas=3

	$ kubectl get deployments

	$ kubectl delete deployments nginx

	$ kubectl get pods -o wide

	$ kubectl config use-context default-context

# Create the DNS Service

	$ kubectl create \
	-f https://raw.githubusercontent.com/kelseyhightower/kubernetes-the-hard-way/master/skydns-svc.yaml

	$ kubectl get

# Create the DNS Replication Controller

	$ kubectl create \
	-f https://raw.githubusercontent.com/kelseyhightower/kubernetes-the-hard-way/master/skydns-rc.yaml

	$ kubectl --namespace=kube-system get pods

	kubectl create -f https://rawgit.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml
