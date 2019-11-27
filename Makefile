create-dind:
	docker run --privileged --network-alias dind --name dind -d -p 2376:2375 docker:18.06-dind --storage-driver overlay2

start-dind:
	docker start dind

stop-dind:
	docker stop dind
		
build-executor:
	docker build -t executor .

build-tester:
	docker build -t tester ./test
	
start-executor:
	docker run -it --rm -e DOCKER_HOST=tcp://172.17.0.2:2375 -w /executor executor

prepare: build-tester
	docker pull node:10-alpine
	docker pull redis:5.0-alpine
	docker pull ruby:2-alpine3.9

test3: build-tester
	# III. Store config in the environment
	./test/scenarios/test3/run.sh
	
test4: build-tester
	# IV. Backing services
	./test/scenarios/test4/run.sh

test5: build-tester
	# V. Strictly separate build and run stages
	./test/scenarios/test5/run.sh
	
test9: build-tester
	# IX. Maximize robustness with fast startup and graceful shutdown
	./test/scenarios/test9/run.sh

test11: build-tester
	# XI. Treat logs as event streams
	./test/scenarios/test11/run.sh
	
test: build-tester
	# XI. Treat logs as event streams
	./test/scenarios/testall/run.sh
	
start-executor-sync:
	# docker run -it --rm -e DOCKER_HOST=tcp://172.17.0.2:2375 -v $PWD:/executor -w /executor executor
	docker run -it --rm -e DOCKER_HOST=tcp://172.17.0.2:2375 -v 12factor-sync:/data -w /executor executor
