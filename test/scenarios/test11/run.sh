#!/bin/sh
export COMPOSE_FILE=./test/scenarios/test11/docker-compose.yml
docker-compose -p test11 build sut-a
docker-compose -p test11 up -d
docker run -it --rm --network test11_default tester rspec spec/04_test11_spec.rb
docker-compose -p test11 down
