# inventory-suite

Installer for Inventory Suite and EdgeX services 

## Pre-requisites 

[Docker engine](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

Mqtt-Moquitto broker from RFID-Controller must be running. This creates **Inventory-Suite_mqtt-net** docker network

## Clone repo and submodules

To avoid git requesting authentication, run the following commands:

```bash
$ git config --global credential.helper store
$ set +x && echo "https://YOUR_GIT_TOKEN:x-oauth-basic@github.impcloud.net" > ~/.git-credentials
```

```bash
$ git clone --recurse-submodules https://github.impcloud.net/RSP-Inventory-Suite/inventory-suite.git
```

## Deploy Inventory Suite and EdgeX services

Note: You may need to run these commands as **sudo** 

```bash
$ cd inventory-suite
$ sudo GIT_TOKEN=your_impcloud_token make build
```

**(if you have a fresh installation of Docker, initialize docker swarm)**
```bash
$ sudo docker swarm init
$ sudo make deploy
```
If you are behind an enterprise proxy, add env variables to make build as:

```bash
$ sudo GIT_TOKEN=your_impcloud_token http_proxy=proxy_url https_proxy=proxy_url make build
```

## Stop services

```bash
$ sudo make stop
```
