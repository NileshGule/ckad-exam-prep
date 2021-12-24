# Commands related to exposing service

## Setup Linkerd as service mesh

### use stable version of linkerd `2.10.1`

```bash

curl -sL run.linkerd.io/install > setup.sh

```

Edit `setup.sh` and update linkerd version to `2.10.1`

### Run `setup.sh`

```bash

sh setup.sh

```

### Add linkerd CLI to the PATH

```bash

export PATH=$PATH:/home/azuser/.linkerd2/bin

```

### Configure linkerd

```bash

linkerd check --pre                     # validate that Linkerd can be  installed
  linkerd install | kubectl apply -f -    # install the control plane into the 'linkerd' namespace
  linkerd check                           # validate everything worked!
  #linkerd dashboard                       # launch the dashboard

  linkerd viz install | kubectl apply -f -
  linkerd viz check

  linkerd viz dashboard &

```

### Edit linkerd to allow external access

```bash

k -n linkerd-viz edit deploy web

```

Set `enforced-host` to blank

```bash

- -enforced-host=

```

Set service type as `NodePort`

```bash

k -n linkerd-viz edit svc web

```

### Open port on VM

```bash

az vm open-port `
--resource-group demo-kubeadm-ckad `
--name kube-master --port 50750

az vm open-port `
--resource-group demo-kubeadm-ckad `
--name kube-master --port 31500 --priority 200

```

### Add `linkerd` annotation to the deployment

```bash

kubectl -n multitenant get deploy mainapp -o yaml | \linkerd inject - | kubectl apply -f -

```