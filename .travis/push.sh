#!/usr/bin/env bash
BRANCH=$1
LOGIN=$2
PASSWORD=$3
if [[ "$BRANCH" == "feature-fix-travis" ]]; then
  echo "$PASSWORD" | docker login -u "$LOGIN" --password-stdin || exit 1
  docker push krow7/hlds:1.1 || exit 1
fi || exit 1