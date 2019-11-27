#!/bin/sh
export COMPOSE_FILE=./test/scenarios/test9/docker-compose.yml
docker-compose -p test9 build sut-a
docker-compose -p test9 up -d
docker run -it --rm --network test9_default tester rspec spec/05_test9_spec.rb
docker-compose -p test9 down
