#!/usr/bin/env bash
BRANCH=$1
LOGIN=$2
PASSWORD=$3
if [[ "$BRANCH" == "test-build" ]]; then
  echo "$PASSWORD" | docker login -u "$LOGIN" --password-stdin;
  docker push krow7/hlds:1.1;
fi