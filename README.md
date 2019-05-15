# inventory-suite

Installer for Inventory Suite and EdgeX services 

## Pre-requisites 

[Docker engine](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

[Docker-compose](https://docs.docker.com/compose/install/)

## Clone repo and submodules

```bash
$ git clone --recurse-submodules https://github.impcloud.net/RSP-Inventory-Suite/inventory-suite.git
```

## Deploy Inventory Suite and EdgeX services

```bash
$ GIT_TOKEN=[your_impcloud_token] make build
$ make deploy
```

## Note

If you are running behind proxies, edit Makefile proxy env variables.