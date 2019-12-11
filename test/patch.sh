#!/bin/sh
set -e
BASEDIR=$(dirname "$0")
source $BASEDIR/functions.sh
sabor=$(cat .sabor) 

patch_code $1 $sabor
