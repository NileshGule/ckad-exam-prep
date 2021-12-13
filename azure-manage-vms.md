# Azure CLI commands to mange master and worker nodes from terminal

## Stop VMs

```bash

az vm stop --ids $(az vm list -g demo-kubeadm-ckad --query "[].id" -o tsv)

```

## Start VMs

```bash

az vm start --ids $(az vm list -g demo-kubeadm-ckad --query "[].id" -o tsv)

```

## Restart VMs

```bash

az vm restart --ids $(az vm list -g demo-kubeadm-ckad --query "[].id" -o tsv)

```