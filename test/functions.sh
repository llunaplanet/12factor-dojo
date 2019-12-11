build_sut() {
  FLAVOR=$1
  echo "Building SUT..."
  docker build --quiet -t sut $PWD/app/$FLAVOR
}

start_test_harness() {
  NAMESPACE=$1
  echo "Starting test harness..."
  docker-compose -p $NAMESPACE -f ./test/scenarios/$NAMESPACE/docker-compose.yml up --quiet-pull -d > /dev/null
  
}

stop_test_harness() {
  NAMESPACE=$1
  echo "Destroying test harness..."
  docker-compose -p $NAMESPACE -f ./test/scenarios/$NAMESPACE/docker-compose.yml down > /dev/null
}

run_test_suite() {
  NAMESPACE=$1
  SPEC_FILE=$2
  echo "Running test suite..."
  docker run -e DOCKER_HOST=$DOCKER_HOST -it --rm --network "${NAMESPACE}_default" tester rspec spec/$SPEC_FILE
}
