#!/usr/bin/env bash
LOGIN=$1
PASSWORD=$2
BRANCH=$3
PR=$4
if [[ "$BRANCH" == "master" && ! ${PR} ]]; then
  echo "$PASSWORD" | docker login -u "$LOGIN" --password-stdin || exit 1
  docker push krow7/hlds:test || exit 1
fi || exit 1