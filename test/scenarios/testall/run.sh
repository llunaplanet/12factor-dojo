#!/bin/sh
export COMPOSE_FILE=./test/scenarios/testall/docker-compose.yml
docker-compose -p testall build sut-a sut-b
docker-compose -p testall up -d
docker run -it --rm --network testall_default tester rspec
docker-compose -p testall down
