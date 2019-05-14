.PHONY: docker

SERVICES=inventory-service cloud-connector-service rfid-alert-service

GIT_SHA=$(shell git rev-parse HEAD)

GIT_TOKEN=4f5abe72b7afd9dcd47e1d063383f56bdba6f5bb
proxy_http=http://proxy-chain.intel.com:911
proxy_https=http://proxy-chain.intel.com:912

run: $(SERVICES) inventory edgex deploy

inventory-service:
	docker build \
		--build-arg GIT_TOKEN=$(GIT_TOKEN)
		--build-arg proxy_http=$(proxy_http)
		--build-arg proxy_https=$(proxy_https)
		-f inventory-service/Dockerfile_dev \
		--label "git_sha=$(GIT_SHA)" \
		-t rsp/inventory-service:$(GIT_SHA) \		
		.

cloud-connector-service:
	docker build \
		--build-arg GIT_TOKEN=$(GIT_TOKEN)
		--build-arg proxy_http=$(proxy_http)
		--build-arg proxy_https=$(proxy_https)
		-f cloud-connector-service/Dockerfile_dev \
		--label "git_sha=$(GIT_SHA)" \
		-t rsp/cloud-connector-service:$(GIT_SHA) \		
		.

rfid-alert-service:
	docker build \
		--build-arg GIT_TOKEN=$(GIT_TOKEN)
		--build-arg proxy_http=$(proxy_http)
		--build-arg proxy_https=$(proxy_https)
		-f rfid-alert-service/Dockerfile_dev \
		--label "git_sha=$(GIT_SHA)" \
		-t rsp/rfid-alert-service:$(GIT_SHA) \		
		.
		
inventory:
	docker-compose pull 

edgex:
	docker-compose pull -f docker-compose-edgex-delhi.yml

deploy:
	docker stack deploy \
		--with-registry-auth \
		--compose-file docker-compose.yml \
		--compose-file docker-compose-edgex-delhi.yml \
		Inventory-Suite

