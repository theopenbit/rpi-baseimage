#!/bin/bash
# ~/.docker/config.json must include
#  "experimental": "enabled"
#
mkdir build
cd build
git clone -b 0.11 https://github.com/phusion/baseimage-docker.git
cd baseimage-docker/image
basetag=$(docker manifest inspect ubuntu:18.04 | jq -r '.manifests[] | select(.platform.architecture == "arm" and .platform.variant == "v7") | .digest')
sed -i "1s/.*/FROM ubuntu@$basetag/" Dockerfile
sed -n -i 'p;3a MAINTAINER theOpenbit' Dockerfile
sed -n -i 'p;4a ENV DEBIAN_FRONTEND=noninteractive' Dockerfile
DOCKER_TAG='latest'
if [ -n "$TRAVIS_TAG" ]; then DOCKER_TAG=$TRAVIS_TAG; fi
docker build --build-arg CONTAINER_TIMEZONE=Europe/Brussels -t theopenbit/rpi-baseimage:$DOCKER_TAG .
docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
docker push theopenbit/rpi-baseimage:$DOCKER_TAG
