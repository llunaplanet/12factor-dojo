#!/bin/sh
export COMPOSE_FILE=./test/scenarios/test4/docker-compose.yml
docker-compose -p test4 build sut-a sut-b
docker-compose -p test4 up -d
docker run -it --rm --network test4_default tester rspec spec/02_test4_spec.rb
docker-compose -p test4 down
