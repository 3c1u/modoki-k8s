PROTOC = protoc
GO111MODULE = on
DOCKER_IMAGE = modokipaas/modoki-k8s
DOCKER_BUILDKIT = 1

.DEFAULT_GOAL := modokid

modokid: 
	go build -o modokid $(wildcard ./daemon/*.go)

.PHONY: all
all: modokid docker

.PHONY: docker-push
docker-push:
	docker push $(DOCKER_IMAGE)

.PHONY: docker
docker:
	docker build -t $(DOCKER_IMAGE) .

	if [ "$(CIRCLE_BRANCH)" = "master" ]; then
		docker push $(DOCKER_IMAGE)
	fi

	docker tag $(DOCKER_IMAGE) $(DOCKER_IMAGE):$(CIRCLE_SHA1)
	docker push $(DOCKER_IMAGE):$(CIRCLE_SHA1)

.PHONY: generate
generate: clean
	cd ./design && $(PROTOC) --go_out=plugins=grpc:../api *.proto

.PHONY: clean
clean:
	rm ./api/*.pb.go