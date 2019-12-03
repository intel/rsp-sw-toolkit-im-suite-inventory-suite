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
## Secrets
The [secrets](secrets) directory contains configuration files with sensitive information
needed by the system (passwords, client secrets, and the like). These secrets are mounted
as configuration files in the containers for their respective services, so you'll need to
edit them before launching.

### Database Username and Password
When the `postgres` service of the Inventory Suite runs for the first time, it looks for
a couple of files -- one containing the database username and another containing the password.
These values then persist to future runs. Edit the values in these two files to set them: 

- [username](secrets/dbUser)
- [password](secrets/dbPass)

Other services that connect to the database then need the same username/password pair, so 
they must also be set to the same values in [configuration.json](secrets/configuration.json):

- username: `dbUser`
- password: `dbPass`

### Other Secrets
There are some other secrets you can set in the 
[secrets/configuration.json](secrets/configuration.json).
Although the individual services describe the configuration values in more detail,
here is a list of values you should consider setting:

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
