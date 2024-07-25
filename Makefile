.PHONY: up down forward-ui

up:
	# Bring up a local Kubernetes cluster using KinD
	kind create cluster --name temporal-demo

	# Install Istio
	istioctl install --set profile=demo -y

	# Install cert-manager
	kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.1/cert-manager.yaml
	kubectl wait --for=condition=Ready --timeout=300s --namespace cert-manager pod --all

	# Install temporal-operator
	kubectl apply --server-side -f https://github.com/alexandrevilain/temporal-operator/releases/latest/download/temporal-operator.crds.yaml
	kubectl apply -f https://github.com/alexandrevilain/temporal-operator/releases/latest/download/temporal-operator.yaml
	kubectl wait --for=condition=Ready --timeout=300s --namespace temporal-system pod --all
	kubectl label namespace temporal-system istio-injection=enabled
	kubectl rollout restart deployment/temporal-operator-controller-manager -n temporal-system
	kubectl wait --for=condition=Ready --timeout=300s --namespace temporal-system pod --all

	# Setup demo namespace and dependencies
	kubectl apply -f 00-namespace.yaml
	kubectl apply -f 01-postgresql.yaml
	kubectl wait --for=condition=Ready --timeout=300s --namespace demo pod --all

	# Setup demo Temporal cluster
	kubectl apply -f 02-temporal-cluster.yaml
	kubectl apply -f 03-temporal-namespace.yaml

down:
	kind delete cluster --name temporal-demo

forward-ui:
	kubectl port-forward --namespace demo svc/prod-ui 0:8080
