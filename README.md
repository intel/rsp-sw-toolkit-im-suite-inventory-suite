# inventory-suite

Installer for Inventory Suite and EdgeX services 

## Pre-requisites 

[Docker engine](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

## Clone repo and submodules

To avoid git requesting authentication, run the following commands:

```bash
$ git config --global credential.helper store
$ set +x && echo "https://YOUR_GIT_TOKEN:x-oauth-basic@github.impcloud.net" > ~/.git-credentials
$ export GIT_TOKEN=YOUR_GIT_TOKEN
```

```bash
$ git clone -b edinburgh --recurse-submodules https://github.impcloud.net/RSP-Inventory-Suite/inventory-suite.git
```

## Deploy Inventory Suite and EdgeX services

Using a text editor, insert your own eventDestination, alertDestination and heartbeatDestination urls in the docker-compose.yml

```bash
$ cd inventory-suite
$ sudo -E ./build.sh
```

## Run Grafana dashboard

open browser at **http://127.0.0.1:8010**  admin/admin

## Stop services

```bash
$ sudo make stop
```
