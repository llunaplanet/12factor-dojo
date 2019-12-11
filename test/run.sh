#!/bin/sh
set -e
BASEDIR=$(dirname "$0")
source $BASEDIR/functions.sh
sabor=$(cat .sabor) 

build_sut $sabor
start_test_harness $1
run_test_suite $1 $2
stop_test_harness $1
