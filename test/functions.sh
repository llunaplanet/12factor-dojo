build_sut() {
  FLAVOR=$1
  echo "Building SUT ... [$FLAVOR]"
  docker build --quiet -t sut $PWD/app/$FLAVOR
  # docker build --quiet -t sut $PWD/app_final
}

build_test_runner() {
  echo "Building Test runner ..."
  docker build --quiet -t test-runner ./test
}

start_test_harness() {
  FACTOR_NUMBER=$1
  if [[ $1 == "all" ]]
  then
    SCENARIO=$1
  else
    SCENARIO="factor$FACTOR_NUMBER"
  fi
  echo "Starting test harness for factor [${FACTOR_NUMBER}] ..."
  docker-compose -p ${SCENARIO} -f ./test/scenarios/${SCENARIO}/docker-compose.yml up --quiet-pull -d > /dev/null
}

stop_test_harness() {
  FACTOR_NUMBER=$1
  if [[ $1 == "all" ]]
  then
    SCENARIO=$1
  else
    SCENARIO="factor$FACTOR_NUMBER"
  fi
  echo "Stopping test harness for factor [${FACTOR_NUMBER}] ..."
  docker-compose -p ${SCENARIO} -f ./test/scenarios/${SCENARIO}/docker-compose.yml stop > /dev/null
}

build_test_harness() {
  FACTOR_NUMBER=$1
  if [[ $1 == "all" ]]
  then
    SCENARIO=$1
  else
    SCENARIO="factor$FACTOR_NUMBER"
  fi
  echo "Building test harness docker images for factor [${FACTOR_NUMBER}] ... "
  docker-compose -p ${SCENARIO} -f ./test/scenarios/${SCENARIO}/docker-compose.yml build
}

test() {
  FACTOR_NUMBER=$1
  if [[ $FACTOR_NUMBER == "all" ]]
  then
    test_all
  else
    test_one $FACTOR_NUMBER
  fi
}

test_one() {
  FACTOR_NUMBER=$1
  NETWORK_NAME="factor${FACTOR_NUMBER}_default"

  sabor=$(cat .sabor)
  build_sut $sabor
  build_test_runner
  start_test_harness $FACTOR_NUMBER
  set +e
  run_test_suite $FACTOR_NUMBER $NETWORK_NAME
  stop_test_harness $FACTOR_NUMBER
}

inspect() {
  NAMESPACE=factor${1}
  docker run -it --rm --network ${NAMESPACE}_default alpine
}

logs() {
  FACTOR_NUMBER=$1
  if [[ $1 == "all" ]]
  then
    SCENARIO=$1
  else
    SCENARIO="factor$FACTOR_NUMBER"
  fi
  echo "Showing test harness logs ..."
  docker-compose -p ${SCENARIO} -f ./test/scenarios/${SCENARIO}/docker-compose.yml logs --tail="all"
}

clean() {
  FACTOR_NUMBER=$1
  if [[ $1 == "all" ]]
  then
    SCENARIO=$1
  else
    SCENARIO="factor$FACTOR_NUMBER"
  fi
  echo "Destroying test harness for factor [${FACTOR_NUMBER}] ..."
  docker-compose -p ${SCENARIO} -f ./test/scenarios/${SCENARIO}/docker-compose.yml down --remove-orphans > /dev/null
}

run_test_suite() {
  FACTOR_NUMBER=$1
  NETWORK_NAME=$2
  echo "Running test suite for factor [${FACTOR_NUMBER}] ..."
  docker run -e DOCKER_HOST=$DOCKER_HOST -it --rm --network "$NETWORK_NAME" test-runner rspec spec/factor${FACTOR_NUMBER}
}

patch_code() {
  FACTOR_NUMBER=$1
  FLAVOR=$2
  git apply --reject --whitespace=nowarn --whitespace=fix test/patches/${FLAVOR}/factor${FACTOR_NUMBER}.patch
}

patch() {
  FACTOR_NUMBER=$1
  FLAVOR=$(cat .sabor)
  patch_code $FACTOR_NUMBER $FLAVOR
}

test_all() {
  NETWORK_NAME="all_default"
  sabor=$(cat .sabor)
  build_sut $sabor
  start_test_harness all
  set +e
  run_test_suite 3 $NETWORK_NAME
  run_test_suite 4 $NETWORK_NAME
  run_test_suite 5 $NETWORK_NAME
  run_test_suite 6 $NETWORK_NAME
  run_test_suite 11 $NETWORK_NAME
  run_test_suite 9 $NETWORK_NAME
  stop_test_harness all
}
