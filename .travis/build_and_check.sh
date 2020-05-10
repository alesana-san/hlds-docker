#!/usr/bin/env bash
VER=`cat VERSION`
echo "version: $VER"
docker build -t krow7/hlds:${VER} .
docker-compose up -d
sleep 70
docker ps -a