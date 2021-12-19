# Setup Kubernetes cluster on Azure using `Kubeadm`

## Provision VMs

Run the powershell script `k8s-azure.ps1` to provision 3 VMs. 1 for master and 2 worker nodes.

---

## Install Docker and Kubeadm 

### Install docker and kubeadm on all the nodes

ssh into each node using the public iP addresses and run the following set of commands

```bash

sudo apt update

# Install Docker
sudo apt install docker.io -y
sudo systemctl enable docker

# Get the gpg keys for Kubeadm
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

# Install Kubeadm
sudo apt install kubeadm=1.22.0-00 kubectl=1.22.0-00 kubelet=1.22.0-00 -y

```
### Configure Docker daemon to use systemd

```

sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

```

### Restart Docker and enable on boot

```bash

sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker

```

### Initialize kubeadm on master node

Follow the steps to configure the cgroup driver for kubelet as specified in the [docs](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/#configuring-the-kubelet-cgroup-driver)

```bash

sudo kubeadm init --config kubeadm-config.yaml

```

### Copy admin.conf to run kubectl as normal user

```bash

mkdir $HOME/.kube

# Copy conf file to .kube directory for current user
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config

# Change ownership of file to current user and group
sudo chown $(id -u):$(id -g) $HOME/.kube/config

```

### Run the join command on worker nodes

```bash

sudo kubeadm join <<master node IP>>:6443 --token <<token value>> \
    --discovery-token-ca-cert-hash <<token hash>>

```

### Install Pod network

Install Weave

```bash

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

```

Verify pods are running

```bash

kubectl get pods -n kube-system

```

---

## Deploy test container

### Deploy Nginx container and expose it using service

```bash

# Create a test deployment
kubectl run --image=nginx webserver

# Create a service
kubectl expose --type NodePort --port 80 pod webserver

# Get the Port for the service
kubectl get svc

```

_Note_ the port number for the service. Open the NSG port e.g. 31094 by specifying the correct resource group name and the VM name for the master node

```bash

az vm open-port `
--resource-group demo-kubeadm `
--name kube-master --port 31094

```

Browse the URL with port number to access Nginx
http://kubeadm-master.southeastasia.cloudapp.azure.com:31094

---

## References

- [Medium post](https://medium.com/@patnaikshekhar/creating-a-kubernetes-cluster-in-azure-using-kubeadm-96e7c1ede4a) on setting Kubernetes cluster on AKS with kubeadm
- [Single node kubernetes master on Azure](https://dev.to/adudko/setting-up-a-single-master-kubernetes-cluster-on-azure-using-kubeadm-1cjn)
- [Unmanaged Kubernetes cluster in Azure using Kubeadm](https://help.mayadata.io/hc/en-us/articles/360036744451-Creating-an-unmanaged-Kubernetes-cluster-in-Azure-using-kubeadm)
