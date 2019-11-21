 # INTEL CONFIDENTIAL
 # Copyright (2019) Intel Corporation.
 #
 # The source code contained or described herein and all documents related to the source code ("Material")
 # are owned by Intel Corporation or its suppliers or licensors. Title to the Material remains with
 # Intel Corporation or its suppliers and licensors. The Material may contain trade secrets and proprietary
 # and confidential information of Intel Corporation and its suppliers and licensors, and is protected by
 # worldwide copyright and trade secret laws and treaty provisions. No part of the Material may be used,
 # copied, reproduced, modified, published, uploaded, posted, transmitted, distributed, or disclosed in
 # any way without Intel/'s prior express written permission.
 # No license under any patent, copyright, trade secret or other intellectual property right is granted
 # to or conferred upon you by disclosure or delivery of the Materials, either expressly, by implication,
 # inducement, estoppel or otherwise. Any license under such intellectual property rights must be express
 # and approved by Intel in writing.
 # Unless otherwise agreed by Intel in writing, you may not remove or alter this notice or any other
 # notice embedded in Materials by Intel or Intel's suppliers or licensors in any way.

.PHONY: build deploy stop grafana init 

MICROSERVICES=inventory-service cloud-connector-service rfid-alert-service product-data-service mqtt-device-service data-provider-service
BUILDABLE=$(MICROSERVICES) edgex-demo-ui
.PHONY: $(BUILDABLE)

GIT_SHA=$(shell git rev-parse HEAD)

build: $(BUILDABLE)

$(MICROSERVICES):
	docker build --rm \
		--build-arg GIT_TOKEN=${GIT_TOKEN} \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		-f $@/Dockerfile_dev \
		--label "git_sha=$(GIT_SHA)" \
		 -t rsp/$@:dev \
		 ./$@

edgex-demo-ui:
	# uses a different Dockerfile name and lacks GIT_TOKEN
	docker build --rm \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		-f $@/Dockerfile \
		--label "git_sha=$(GIT_SHA)" \
		 -t rsp/$@:dev \
		 ./$@

deploy: init
	docker stack deploy \
		--with-registry-auth \
		--compose-file docker-compose.yml \
		--compose-file docker-compose-edinburgh-1.0.1.yml \
		--compose-file docker-compose-telegraf.yml \
		Inventory-Suite-Dev

init: 
	docker swarm init 2>/dev/null || true

stop:	
	docker stack rm Inventory-Suite-Dev RRP-Telemetry

