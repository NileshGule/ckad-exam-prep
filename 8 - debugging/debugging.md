# Debugging related commands

## force pod to delete without waiting

```bash

k delete nginx --force --grace-priod=0

k delete nginx --force --grace-priod=0

```

## Get events for specific pod named `kibana` in hte `elastic-stack` namespace

```bash 

k get events -n elastic-stack --field-selector involvedObject.name=kibana

```