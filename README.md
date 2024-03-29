DISCONTINUATION OF PROJECT. 

This project will no longer be maintained by Intel.

This project has been identified as having known security escapes.

Intel has ceased development and contributions including, but not limited to, maintenance, bug fixes, new releases, or updates, to this project.  

Intel no longer accepts patches to this project.
# Getting Started with Intel® RFID Sensor Platform (RSP) - Inventory Suite on Linux

The Intel® RSP Inventory Suite is open source reference IoT software that enables you to gather data from multiple sensors and combine with your RFID data via edge analytics.

The Inventory Suite software is installed on an edge computer and gathers data from Intel® RSP RFID Sensors (also often referred to as “RFID readers”) and other potential IoT sensors and data sources. The Intel® Inventory Suite has the capability to combine and run analytics on data from multiple sensors (e.g. – temperature, video, accelerometer). It also orchestrates the behavior of the RFID sensors to optimize the data collection process. The data can then move to the cloud or other connected devices in the customer’s infrastructure. Additionally, a cloud-based remote management console can be used to control and configure IoT deployments remotely.

Intel provides: Intel® RSP Inventory Suite (Edge Software) via open source software.intel.com and RSP Sensors can be purchased via an authorized distributor (ie – Atlas RFID)

This software is only a reference intended to be used by software developers and businesses creating their own software offering.

In the future, Intel® authorized distributors will provide a dev kit that includes pre-validated hardware and software plus documentation and support via an authorized distributor and Intel

Intel does not provide: Instructions for connecting other third party sensors to the RSP Inventory Suite, this capability does exist and instructions can be found via www.EdgeXfoundry.org

## Contents
  * [Inventory Suite Overview](#inventory-suite-overview)
  * [System Overview](#system-overview)
  * [Pre-requisites](#pre-requisites)
  * [Installing the RSP Inventory Suite](#installing-the-rsp-inventory-suite)

## Inventory Suite Overview
 
The RSP Inventory Suite, in conjunction with EdgeX's core services allows for:
1. Command and control of certain RSP Sensor and Controller Application behavior.
2. Consume and aggregate the high volume and raw data RSP Sensor events.
3. Generate meaningful inventory events (e.g., "item exited"), alerts, and system status notifications.
4. Perform additional business logic on those events.
5. Provide an IoT platform to build applications that can fuse heterogeneous sensor data to solve various inventory related use cases.

## System Overview

The image below is an example of a robust inventory management system built on Intel RSP. The computer, RSP Controller Application, RSP Inventory Suite and EdgeX core services are referred to as the edge computer, which functions as a data gateway for connected RSP sensors and other IoT devices.
   * The RSP reader activates the RFID tags within its range and passes tag data, along with information from other on-board sensors, to the RSP Controller application running on an on-premises computer. 
   * The RSP Controller Application, with the help of the RSP Inventory suite passes the data to EdgeX.
   * The RSP Inventory Suite consumes the data to form meaning inventory events and perform various business logic on those events.

 ![](docs/solution-structure.png)

## Warnings
> ![](docs/images/alert-48.png) **Warning**
> 
> This software is a **Dev-Kit** and is **NOT** intended to be deployed into
> production without extra steps to **secure and harden your installation**.
> This is imperative to complete before deploying this software outside of a development environment.
> **Please consult our [Hardening Guide](#hardening-your-installation) for more information.**

## Pre-requisites 

### Intel® RSP Controller Application

> ![](docs/images/alert-24.png) **Notice**
> 
> Before starting this Getting Started Guide for the Intel® RSP 
> Inventory Suite, you must have completed the [*Getting Started with
> Intel® RFID Sensor Platform (RSP) on Linux*](https://software.intel.com/en-us/getting-started-with-intel-rfid-sensor-platform-on-linux)

*   This document assumes an edge computer running Ubuntu 18.04, which is preinstalled on the RDK, but other Linux distributions compatible with JRE 8+ should also be compatible with RSP.
*   Must have the RSP Controller Application running.

### Docker

```bash
sudo apt update
sudo apt -y install docker.io
```  

## Installing the RSP Inventory Suite

### Clone repo and submodules
```bash
$ git clone -b <branch_name> --recurse-submodules https://github.com/intel/rsp-sw-toolkit-im-suite-inventory-suite
```

## Secrets
The [secrets](secrets) directory contains configuration files with sensitive information
needed by the system (passwords, client secrets, and the like). These secrets are mounted
as configuration files in the containers for their respective services, so you'll need to
edit them before launching.

### Database Username and Password
Before launching, you should configure a username/password pair for the database
in [configuration.json](secrets/configuration.json):

- username: `dbUser`; initially set to `postgres`, but it's arbitrary.
- password: `dbPass`; initially empty; you must set it before deploying. 

When you deploy, the Makefile will use those values to generate some necessary files
(`dbUser` and `dbPass`), which are passed as secrets to the `postgres` service.
If you try to deploy before setting `dbPass`, you'll get an error saying 
`You must set dbPass in configuration.json`. You don't need to edit the `secrets/dbUser`
or `secrets/dbPass` files -- those are automatically created by the Makefile. You only
need to edit the `configuration.json` file.

> Important Toubleshooting Tip: When the `postgres` service runs, it only runs its 
> initialization if it hasn't done so before; if you run into an issue during setup
> and want to try again, consider removing unused volumes, which can be done as so:
>   - stop the services with `make stop` or `docker stack rm Inventory-Suite`
>   - wait about 10s for all containers to stop; check with `docker ps`
>   - remove stopped containers that weren't automatically cleaned up with `docker container prune -f`
>   - remove volumes not attached to containers with `docker volume prune -f`


### Other Secrets
There are some other secrets you can set in the 
[secrets/configuration.json](secrets/configuration.json), or you can leave them blank for now.
Although the individual services describe the configuration values in more detail,
here is a list of values you may consider setting:

- eventDestination, heartbeastDestination, alertDestination: URLs to which certain messages are sent
- eventDestinationAuthType, alertDestinationAuthType: type (e.g., oauth) for authentication, if these endpoints use it 
- eventDestinationAuthEndpoint, alertDestinationAuthEndpoint: for token-based auth, the URL for tokens
- eventDestinationClientID, alertDestinationClientID: client ID for token-based auth
- eventDestinationClientSecret, eventDestinationClientSecret: client secret for token-based auth

If your environment has non-EPC-encoded tags, the proprietary tag configuration items can be set to
define how those tags are decoded to URIs; otherwise, they can be left alone. The service docs has 
more information about their meaning, but here's a brief rundown:

- proprietaryTagBitBoundary: a string of "."-delimited ints indicating the bit-width of each tag field
- proprietaryTagProductIdx: an integer indicating the 0-based field index containing the product ID
- tagURIAuthorityName: the URL used for constructing the "tag" URN
- tagURIAuthorityDate: a "YYYY-MM-dd" on which the tagURIAuthorityName was owned by the URN minter.


The keys under `data-provider-service` typically do not need to be edited, but you can read more
about them in the documentation for that service.


### Deploy Inventory Suite and EdgeX services

Using a text editor, insert your own eventDestination, alertDestination and heartbeatDestination urls in the docker-compose.yml

```bash
$ cd inventory-suite
$ ./build.sh
```
![](docs/images/coffee-cup-sm2.png)  This step may take a some time depending on internet connectivity speeds. 

### Stop services

```bash
$ sudo make stop
```

## Hardening your installation
### Encrypting Docker Data
Encrypting data in Docker volumes and between Docker nodes is wise practice,
particularly if you're handling data of any sensitivity.
When doing so, there are many different options available,
and which to choose depends largely upon factors specific to your application
and goals.

Below is a list of suggestions with some rough ideas of pros and cons.
Remember that technology changes rapidly,
so it's worth regularly evaluating whether 
any particular solution continues to meet your needs
and security requirements; moreover, while this advice attempts to be relevant,
it's also important to examine whether information in this guide
still meets security best-practices.

In short, there is no "one-size-fits-all" solution,
and you should consider the information here as a starting point for further research.

### The easy stuff
First of all, you should ensure your host(s) are at least following basic
[Docker security best practices](https://docs.docker.com/engine/security/security/).

### Encrypting data at rest

#### Full drive encryption
Ubuntu allows you to encrypt the entire OS during the installation step:

![](docs/images/ubuntu-encrypt-disk.png)

Selecting this will prompt you to create a security key that will be needed on startup to decrypt the drive:

![](docs/images/ubuntu-encrypt-choose-security-key.jpg)

#### Volume encryption
You can configure Docker to use various different drivers when creating and using Docker volumes. At least one of them allow you to encrypt the data at rest.

[Docker Data Volume Snapshots and Encryption with LVM and LUKS (Blog)](https://medium.com/@kalahari/docker-data-volume-snapshots-and-encryption-with-lvm-and-luks-ce80e0555225)

[Docker Volume Driver for lvm volumes (GitHub)](https://github.com/containers/docker-lvm-plugin)

### TLS
By default Docker swarm nodes will encrypt and authenticate information they exchange between nodes.

In order to encypt the communication between ALL containers/services within Docker, create an Overlay network with encryption enabled.

[Docker swarm mode overlay network security model](https://docs.docker.com/v17.09/engine/userguide/networking/overlay-security-model/)

### Secure PostgreSQL database

Although Docker swarm comes secure out the box using gossip protocol, if you want to increase the security between client/server communication, PostgreSQL has a native support for SSL connections. [SSL Support](https://www.postgresql.org/docs/9.1/libpq-ssl.html).
Be aware that clients will require openssl libraries installed.
