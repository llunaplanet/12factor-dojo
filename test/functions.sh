build_sut() {
  FLAVOR=$1
  echo "Building SUT ... [$FLAVOR]"
  docker build --quiet -t sut $PWD/app/$FLAVOR
  # docker build --quiet -t sut $PWD/app_final
}

build_test_runner() {
  echo "Building Test runner ... "
  docker build --quiet -t test-runner ./test  
}

start_test_harness() {
  FACTOR_NUMBER=$1
  echo "Starting test harness ... [factor${FACTOR_NUMBER}]"
  docker-compose -p factor${FACTOR_NUMBER} -f ./test/scenarios/factor${FACTOR_NUMBER}/docker-compose.yml up --quiet-pull -d > /dev/null
}

# start_test_harness() {
#   NAMESPACE=$1
#   echo "Starting test harness..."
#   docker-compose -p $NAMESPACE -f ./test/scenarios/$NAMESPACE/docker-compose.yml up --quiet-pull -d > /dev/null
# }

stop_test_harness() {
  FACTOR_NUMBER=$1
  echo "Stopping test harness [factor${FACTOR_NUMBER}]"
  docker-compose -p factor${FACTOR_NUMBER} -f ./test/scenarios/factor${FACTOR_NUMBER}/docker-compose.yml stop > /dev/null
}

build_test_harness() {
  FACTOR_NUMBER=$1
  echo "Destroying test harness [factor${FACTOR_NUMBER}]..."
  docker-compose -p factor${FACTOR_NUMBER} -f ./test/scenarios/factor${FACTOR_NUMBER}/docker-compose.yml build
}

test() {
  FACTOR_NUMBER=$1
  sabor=$(cat .sabor)
  build_sut $sabor
  build_test_runner
  start_test_harness $1
  set +e
  run_test_suite $1 $2
  stop_test_harness $1
}

inspect() {
  NAMESPACE=factor${1}
  docker run -it --rm --network ${NAMESPACE}_default alpine
}

logs() {
  FACTOR_NUMBER=$1
  echo "Showing test harness logs..."
  docker-compose -p factor${FACTOR_NUMBER} -f ./test/scenarios/factor${FACTOR_NUMBER}/docker-compose.yml logs --tail="all"
}

clean() {
  FACTOR_NUMBER=$1
  echo "Destroying test harness ... [factor${FACTOR_NUMBER}]..."
  docker-compose -p factor${FACTOR_NUMBER} -f ./test/scenarios/factor${FACTOR_NUMBER}/docker-compose.yml down --remove-orphans > /dev/null
}

run_test_suite() {
  FACTOR_NUMBER=$1
  echo "Running test suite ... [factor${FACTOR_NUMBER}]"
  docker run -e DOCKER_HOST=$DOCKER_HOST -it --rm --network "factor${FACTOR_NUMBER}_default" test-runner rspec spec/factor${FACTOR_NUMBER}
}

patch_code() {
  FACTOR_NUMBER=$1
  FLAVOR=$2
  git apply --reject --whitespace=nowarn --whitespace=fix test/patches/${FLAVOR}/factor${FACTOR_NUMBER}.patch
}

test_all() {
  FACTOR_NUMBER=$1
  sabor=$(cat .sabor)
  build_sut $sabor
  start_test_harness all
  set +e
  run_test_suite 3
  run_test_suite 4
  run_test_suite 5
  run_test_suite 6
  run_test_suite 8
  run_test_suite 11
  run_test_suite 9
  stop_test_harness all
}
