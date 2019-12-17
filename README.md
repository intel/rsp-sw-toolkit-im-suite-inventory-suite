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

## Pre-requisites 

### Intel® RSP Controller Application

*   :warning: :warning: Before starting this Getting Started Guide for the Intel® RSP Inventory Suite, you must have completed the [*Getting Started with Intel® RFID Sensor Platform (RSP) on Linux*](https://software.intel.com/en-us/getting-started-with-intel-rfid-sensor-platform-on-linux)
*   This document assumes an edge computer running Ubuntu 18.04, which is preinstalled on the RDK, but other Linux distributions compatible with JRE 8+ should also be compatible with RSP.
*   Must have the RSP Controller Application running.

### Docker

```bash
sudo apt update
sudo apt -y install docker.io
```  

## Installing the RSP Inventory Suite

### Clone repo and submodules

To avoid git requesting authentication, run the following commands:

```bash
$ git config --global credential.helper store
$ set +x && echo "https://YOUR_GIT_TOKEN:x-oauth-basic@github.impcloud.net" > ~/.git-credentials
$ export GIT_TOKEN=YOUR_GIT_TOKEN
```

```bash
$ git clone -b edinburgh --recurse-submodules https://github.impcloud.net/RSP-Inventory-Suite/inventory-suite.git
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

### Secure PostgreSQL database

Although Docker swarm comes secure out the box using gossip protocol, if you want to increase the security between client/server communication, PostgreSQL has a native support for SSL connections. [SSL Support](https://www.postgresql.org/docs/9.1/libpq-ssl.html).
Be aware that clients will require openssl installed.