# inventory-suite

Installer for Inventory Suite and EdgeX services 

## Pre-requisites 

[Docker engine](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

### For Ubuntu 18.04 and above

```bash
$ sudo apt update
$ sudo apt install docker.io make git
```

Mqtt-Moquitto broker from RFID-Controller must be running. This creates **Inventory-Suite_mqtt-net** docker network

## Clone repo and submodules

To avoid git requesting authentication, run the following commands:

```bash
$ git config --global credential.helper store
$ set +x && echo "https://YOUR_GIT_TOKEN:x-oauth-basic@github.impcloud.net" > ~/.git-credentials
```

```bash
$ git clone -b grafana --recurse-submodules https://github.impcloud.net/RSP-Inventory-Suite/inventory-suite.git
```

## Deploy Inventory Suite and EdgeX services

Note: You may need to run these commands as **sudo** 

```bash
$ GIT_TOKEN=your_impcloud_token make build
```
**(if you have a fresh installation of Docker, initialize docker swarm)**
```bash
$ docker swarm init
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