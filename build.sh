#!/bin/bash

IMAGE_REPO=cr.yandex/crps74sn87hcqhmnotok
VERSION=latest

docker build --platform linux/amd64 --build-arg VERSION=$VERSION --build-arg REPO=$IMAGE_REPO -f ./docker/base/Dockerfile -t $IMAGE_REPO/browserless/base:$VERSION .
docker build --platform linux/amd64 --build-arg VERSION=$VERSION --build-arg REPO=$IMAGE_REPO -f ./docker/firefox/Dockerfile -t $IMAGE_REPO/browserless/firefox:$VERSION .
