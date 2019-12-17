build_sut() {
  FLAVOR=$1
  echo "Building SUT ... [$FLAVOR]"
  docker build --quiet -t sut $PWD/app/$FLAVOR
  # docker build --quiet -t sut $PWD/app_final
}

start_test_harness() {
  FACTOR_NUMBER=$1
  echo "Starting test harness ... [factor${FACTOR_NUMBER}]"
  docker-compose -p test${FACTOR_NUMBER} -f ./test/scenarios/factor${FACTOR_NUMBER}/docker-compose.yml up --quiet-pull -d > /dev/null
}

# start_test_harness() {
#   NAMESPACE=$1
#   echo "Starting test harness..."
#   docker-compose -p $NAMESPACE -f ./test/scenarios/$NAMESPACE/docker-compose.yml up --quiet-pull -d > /dev/null
# }

stop_test_harness() {
  FACTOR_NUMBER=$1
  echo "Stopping test harness [factor${FACTOR_NUMBER}]"
  docker-compose -p test${FACTOR_NUMBER} -f ./test/scenarios/factor${FACTOR_NUMBER}/docker-compose.yml stop > /dev/null
}

build_test_harness() {
  NAMESPACE=$1
  echo "Destroying test harness [$NAMESPACE]..."
  docker-compose -p $NAMESPACE -f ./test/scenarios/$NAMESPACE/docker-compose.yml build
}

inspect() {
  NAMESPACE=test${1}
  docker run -it --rm --network ${NAMESPACE}_default alpine
}

logs() {
  NAMESPACE=$1
  echo "Showing test harness logs..."
  docker-compose -p factor${NAMESPACE} -f ./test/scenarios/factor${NAMESPACE}/docker-compose.yml logs --tail="all"
}

clean() {
  NAMESPACE=$1
  echo "Destroying test harness ... [factor${NAMESPACE}]..."
  docker-compose -p factor${NAMESPACE} -f ./test/scenarios/factor${NAMESPACE}/docker-compose.yml down --remove-orphans > /dev/null
}

run_test_suite() {
  FACTOR_NUMBER=$1
  echo "Running test suite ... [factor${FACTOR_NUMBER}]"
  docker run -e DOCKER_HOST=$DOCKER_HOST -it --rm --network "test${FACTOR_NUMBER}_default" test-runner rspec spec/factor${FACTOR_NUMBER}
}

patch_code() {
  FACTOR_NUMBER=$1
  FLAVOR=$2
  git apply --reject --whitespace=nowarn --whitespace=fix test/patches/${FLAVOR}/factor${FACTOR_NUMBER}.patch
}
