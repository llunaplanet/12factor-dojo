
setup: create-dind build-executor
hajime: start-executor

setup-nodejs:
	echo "Seeting up [nodejs] stack..."
	@echo "nodejs" > .stack	

setup-go:
	echo "Setting up [go] stack..."
	@echo "go" > .stack
	
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

build-tester:
	# touch build-tester
	docker build --quiet -t tester ./test

prepare: build-tester
	docker pull node:10-alpine
	docker pull redis:4.0-alpine
	docker pull redis:5.0-alpine
	docker pull ruby:2-alpine3.9

# III. Store config in the environment
test3: build-tester
	time ./test/run.sh test3 01_test3_spec.rb
	
# IV. Backing services
test4: build-tester
	time ./test/run.sh test4 02_test4_spec.rb
	
patch4:
	time ./test/patch.sh test4

# V. Strictly separate build and run stages
test5: build-tester
	time ./test/run.sh test5 03_test5_spec.rb
	
# IX. Maximize robustness with fast startup and graceful shutdown
test9: build-tester
	time ./test/run.sh test9 05_test9_spec.rb

# XI. Treat logs as event streams
test11: build-tester
	time ./test/run.sh test11 04_test11_spec.rb

patch11:
	time ./test/patch.sh test11

test-all: build-tester
	./test/scenarios/testall/run.sh
