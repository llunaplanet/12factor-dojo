
setup: create-dind build-executor
hajime: start-executor

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
	
# Targets to manage the executor ( Execute in the host )
		
build-executor:
	docker build -t executor .
	
start-executor:
	docker run -it --rm \
		-e DOCKER_HOST=tcp://172.17.0.2:2375 \
		-v ${PWD}:/dojo \
		-w /dojo \
		executor

start-executor-sync:
	# docker run -it --rm -e DOCKER_HOST=tcp://172.17.0.2:2375 -v $PWD:/executor -w /executor executor
	docker run -it --rm -e DOCKER_HOST=tcp://172.17.0.2:2375 -v 12factor-sync:/data -w /executor executor

# Targets to execute the tests

build-tester:
	docker build -t tester ./test

prepare: build-tester
	docker pull node:10-alpine
	docker pull redis:5.0-alpine
	docker pull ruby:2-alpine3.9

# III. Store config in the environment
test3: build-tester
	./test/scenarios/test3/run.sh
	
# IV. Backing services
test4: build-tester
	./test/scenarios/test4/run.sh
	
patch4:
	git apply --reject --whitespace=nowarn --whitespace=fix test/patches/test4.patch

# V. Strictly separate build and run stages
test5: build-tester
	./test/scenarios/test5/run.sh
	
# IX. Maximize robustness with fast startup and graceful shutdown
test9: build-tester
	./test/scenarios/test9/run.sh

# XI. Treat logs as event streams
test11: build-tester
	./test/scenarios/test11/run.sh

patch11:
	git apply --reject --whitespace=nowarn --whitespace=fix test/patches/test11.patch

test: build-tester
	./test/scenarios/testall/run.sh
