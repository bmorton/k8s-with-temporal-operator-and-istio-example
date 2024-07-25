# `temporal-operator` exploration

## Prerequisites

- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [istioctl](https://istio.io/latest/docs/setup/getting-started/#download)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Configuration

* Kubernetes
* cert-manager
* Istio
* temporal-operator
* Postgres

## Setup

```
make up
```

## Port-forward to the Temporal Web UI

```
make port-forward
```

## Teardown

```
make down
```
