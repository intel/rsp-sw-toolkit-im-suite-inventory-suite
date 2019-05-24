 # INTEL CONFIDENTIAL
 # Copyright (2017) Intel Corporation.
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

.PHONY: build deploy stop grafana

MICROSERVICES=inventory-service cloud-connector-service rfid-alert-service product-data-service inventory-probabilistic-algo mqtt-device-service
.PHONY: $(MICROSERVICES)

GIT_SHA=$(shell git rev-parse HEAD)

build: $(MICROSERVICES)

inventory-service:
	docker build \
		--build-arg GIT_TOKEN=$(GIT_TOKEN) \
		--build-arg http_proxy=$(http_proxy) \
		--build-arg https_proxy=$(https_proxy) \
		-f inventory-service/Dockerfile_dev \
		--label "git_sha=$(GIT_SHA)" \
		 -t rsp/inventory-service:$(GIT_SHA) -t rsp/inventory-service:dev \
		 ./inventory-service

cloud-connector-service:
	docker build \
		--build-arg GIT_TOKEN=$(GIT_TOKEN) \
		--build-arg http_proxy=$(http_proxy) \
		--build-arg https_proxy=$(https_proxy) \
		-f cloud-connector-service/Dockerfile_dev \
		--label "git_sha=$(GIT_SHA)" \
		 -t rsp/cloud-connector-service:$(GIT_SHA) -t rsp/cloud-connector-service:dev \
		 ./cloud-connector-service

rfid-alert-service:
	docker build \
		--build-arg GIT_TOKEN=$(GIT_TOKEN) \
		--build-arg http_proxy=$(http_proxy) \
		--build-arg https_proxy=$(https_proxy) \
		-f rfid-alert-service/Dockerfile_dev \
		--label "git_sha=$(GIT_SHA)" \
		-t rsp/rfid-alert-service:$(GIT_SHA) -t rsp/rfid-alert-service:dev \
		./rfid-alert-service

product-data-service:
	docker build \
		--build-arg GIT_TOKEN=$(GIT_TOKEN) \
		--build-arg http_proxy=$(http_proxy) \
		--build-arg https_proxy=$(https_proxy) \
		-f product-data-service/Dockerfile_dev \
		--label "git_sha=$(GIT_SHA)" \
		-t rsp/product-data-service:$(GIT_SHA) -t rsp/product-data-service:dev \
		./product-data-service

inventory-probabilistic-algo:
	docker build \
		--build-arg GIT_TOKEN=$(GIT_TOKEN) \
		--build-arg http_proxy=$(http_proxy) \
		--build-arg https_proxy=$(https_proxy) \
		-f inventory-probabilistic-algo/Dockerfile_dev \
		--label "git_sha=$(GIT_SHA)" \
		-t rsp/inventory-probabilistic-algo:$(GIT_SHA) -t rsp/inventory-probabilistic-algo:dev \
		./inventory-probabilistic-algo

mqtt-device-service:
	docker build \
		--build-arg GIT_TOKEN=$(GIT_TOKEN) \
		--build-arg http_proxy=$(http_proxy) \
		--build-arg https_proxy=$(https_proxy) \
		-f mqtt-device-service/Dockerfile_dev \
		--label "git_sha=$(GIT_SHA)" \
		-t rsp/mqtt-device-service:$(GIT_SHA) -t rsp/mqtt-device-service:dev \
		./mqtt-device-service
		
deploy: grafana
	docker stack deploy \
		--with-registry-auth \
		--compose-file docker-compose.yml \
		--compose-file docker-compose-delhi-0.7.1.yml \
		--compose-file docker-compose-telegraf.yml \
		Inventory-Suite-Dev

grafana:
	cd telemetry-dashboard && ./start.sh

stop:
	docker stack rm Inventory-Suite-Dev RRP-Telemetry
	
