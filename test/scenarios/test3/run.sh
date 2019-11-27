#!/bin/sh
export COMPOSE_FILE=./test/scenarios/test3/docker-compose.yml
docker-compose -p test3 build sut-a sut-b
docker-compose -p test3 up -d
docker run -it --rm --network test3_default tester rspec spec/01_test3_spec.rb
docker-compose -p test3 down
