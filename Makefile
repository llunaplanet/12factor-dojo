
setup: build-executor create-dind
hajime: start-executor
clean: delete-dind

setup-nodejs:
	echo "Seeting up [nodejs] stack..."
	@echo "nodejs" > .sabor

setup-go:
	echo "Setting up [go] stack..."
	@echo "go" > .sabor

# Targets to manage the DIND ( Execute in the host )

create-dind:
	docker run -d \
		-p 2376:2375 \
		--privileged \
		--network-alias dind \
		--name dind \
		-e DOCKER_TLS_CERTDIR="" \
		docker:20.10-dind --storage-driver overlay2

start-dind:
	docker start dind

stop-dind:
	docker stop dind

delete-dind: stop-dind
	docker rm dind

# Targets to manage the executor ( Execute in the host )

build-executor:
	docker build -t executor .

start-executor:
	DIND_HOST=$$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dind ); \
	docker run -it --rm \
		-e DOCKER_HOST=tcp://$$DIND_HOST:2375 \
		-v $$PWD:/dojo \
		-u $$(id -u):$$(id -g) \
		-w /dojo \
		executor

start-executor-sync:
	# docker run -it --rm -e DOCKER_HOST=tcp://172.17.0.2:2375 -v $PWD:/executor -w /executor executor
	docker run -it --rm -e DOCKER_HOST=tcp://172.17.0.2:2375 -v 12factor-sync:/data -w /executor executor

# Targets to execute the tests

build-test-runner:
	# touch build-test-runner
	docker build -t test-runner ./test

prepare: build-test-runner
	docker pull node:10-alpine
	docker pull redis:4.0-alpine
	docker pull redis:5.0-alpine
	docker pull ruby:2-alpine3.9
