#!/bin/sh
export COMPOSE_FILE=./test/scenarios/test5/docker-compose.yml
docker-compose -p test5 build sut-a sut-b
docker-compose -p test5 up -d
docker run -it --rm --network test5_default tester rspec spec/03_test5_spec.rb
docker-compose -p test5 down
