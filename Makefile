
setup: create-dind build-executor
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
		docker:18.06-dind --storage-driver overlay2

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
		-w /dojo \
		executor

start-executor-sync:
	# docker run -it --rm -e DOCKER_HOST=tcp://172.17.0.2:2375 -v $PWD:/executor -w /executor executor
	docker run -it --rm -e DOCKER_HOST=tcp://172.17.0.2:2375 -v 12factor-sync:/data -w /executor executor

# Targets to execute the tests

build-test-runner:
	# touch build-test-runner
	docker build --quiet -t test-runner ./test

prepare: build-test-runner
	docker pull node:10-alpine
	docker pull redis:4.0-alpine
	docker pull redis:5.0-alpine
	docker pull ruby:2-alpine3.9

# III. Store config in the environment
test3: build-test-runner
	time ./test/run.sh 3
	
# IV. Backing services
test4: build-test-runner
	time ./test/run.sh 4
	
patch4:
	time ./test/patch.sh 4

# V. Strictly separate build and run stages
test5: build-test-runner
	time ./test/run.sh 5
	
# VI. Processes
test6: build-test-runner
	time ./test/run.sh 6
	
patch6:
	time ./test/patch.sh 6

# IX. Maximize robustness with fast startup and graceful shutdown
test9: build-test-runner
	time ./test/run.sh 9

patch9:
	time ./test/patch.sh 9


# XI. Treat logs as event streams
test11: build-test-runner
	time ./test/run.sh 11

patch11:
	time ./test/patch.sh 11

test-all: build-test-runner
	./test/scenarios/testall/run.sh
