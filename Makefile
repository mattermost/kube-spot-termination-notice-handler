NAME    := mattermost/kube-spot-termination-notice-handler
TAG     := v1.23.4

.PHONY: build-image
build-image:
	@echo Building Mattermost-kube-spot-termination-handler Docker Image
	echo $$DOCKERHUB_TOKEN | docker login --username $$DOCKERHUB_USERNAME --password-stdin && \
	docker buildx build \
	 --platform linux/arm64,linux/amd64 \
	. -f Dockerfile -t $(NAME):test \
	--no-cache \
	--push


.PHONY: build-image-with-tag
build-image-with-tag:
	@echo Building Mattermost-kube-spot-termination-handler Docker Image
	echo $$DOCKERHUB_TOKEN | docker login --username $$DOCKERHUB_USERNAME --password-stdin && \
	docker buildx build \
	 --platform linux/arm64,linux/amd64 \
	. -f Dockerfile -t $(NAME):$(TAG) \
	--no-cache \
	--push

.PHONY: all
all:
	@$(MAKE) build-image
	@$(MAKE) scan
	@$(MAKE) push-image

.PHONY: push-image-pr
push-image-pr:
	@echo Push Image PR
	./scripts/push-image-pr.sh

.PHONY: push-image
push-image:
	@echo Push Image
	./scripts/push-image.sh

.PHONY: scan
scan:
	docker scan ${NAME}:${TAG}

# Install dependencies for release notes
.PHONY: deps
deps:
	sudo apt update && sudo apt install hub git
	GO111MODULE=on go install k8s.io/release/cmd/release-notes@latest

# Cut a release
.PHONY: release
release:
	@echo Cut a release
	bash ./scripts/release.sh
