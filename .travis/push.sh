#!/usr/bin/env bash
LOGIN=$1
PASSWORD=$2
BRANCH=$3
PR=$4
VER=`cat VERSION`
if [[ "$BRANCH" == "master" && ! ${PR} ]]; then
  echo "$PASSWORD" | docker login -u "$LOGIN" --password-stdin || exit 1
  docker push krow7/hlds:${VER} || exit 1
fi || exit 1