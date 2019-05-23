# inventory-suite

Installer for Inventory Suite and EdgeX services 

## Pre-requisites 

[Docker engine](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

Mqtt-Moquitto broker from RFID-Controller must be running. This creates **Inventory-Suite_mqtt-net** docker network

## Clone repo and submodules

```bash
$ git clone --recurse-submodules https://github.impcloud.net/RSP-Inventory-Suite/inventory-suite.git
```

## Deploy Inventory Suite and EdgeX services

Note: You may need to run these commands as **sudo** 

```bash
$ GIT_TOKEN=your_impcloud_token make build
$ make deploy
```
If you are behind an enterprise proxy, add env variables to make build as:

```bash
$ GIT_TOKEN=your_impcloud_token http_proxy=proxy_url https_proxy=proxy_url make build
```

## Stop services

```bash
$ make stop
```
