# Apache v2 license
#  Copyright (C) <2019> Intel Corporation
#
#  SPDX-License-Identifier: Apache-2.0
#

.PHONY: build deploy stop init

MICROSERVICES=inventory-service cloud-connector-service alert-service product-data-service mqtt-device-service data-provider-service
BUILDABLE=$(MICROSERVICES) demo-ui
.PHONY: $(BUILDABLE)

GIT_SHA=$(shell git rev-parse HEAD)

build: $(BUILDABLE)

$(MICROSERVICES):
	docker build --rm \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		-f $@/Dockerfile_dev \
		--label "git_sha=$(GIT_SHA)" \
		 -t rsp/$@:dev \
		 ./$@

demo-ui:
	docker build --rm \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		-f $@/Dockerfile \
		--label "git_sha=$(GIT_SHA)" \
		 -t rsp/$@:dev \
		 ./$@

secrets/db%: secrets/configuration.json
	@python secrets/parseConf.py $^ db$* $@

deploy: init secrets/dbUser secrets/dbPass
	docker stack deploy \
		--with-registry-auth \
		--compose-file docker-compose.yml \
		--compose-file docker-compose-edinburgh-1.0.1.yml \
		Inventory-Suite-Dev

init:
	docker swarm init 2>/dev/null || true

stop:
	docker stack rm Inventory-Suite-Dev

