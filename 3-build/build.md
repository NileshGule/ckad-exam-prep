# commands related to build module

## build docker image

```bash

sudo docker build -t simpleapp .

```

## Verify image is build successfully

```bash

sudo docker images

```

## Run docker image

```bash

sudo docker run simpleapp

```

## locate date.out file generated by running container

```bash

sudo find / -name date.out

```

## tail the `date.out` content

```bash

sudo tail /var/lib/docker/overlay2/bb6209ea4fe436d1783dca67c7a707faadc42a8defdce2e7a25a4cd6588cdefa/diff/date.out

```

_Note_: the container hash will be different 