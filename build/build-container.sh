#!/bin/bash
set -e 

VERSION=$1
ARCH=$(docker info 2> /dev/null|grep Architecture|awk '{print $2}')
if [ $ARCH == x86_64 ]
  then
    ARCH=amd64
fi
echo "Create piersfinlayson/build container"
echo "       version: ${VERSION}"
echo "  architecture: ${ARCH}"
echo "${VERSION}" > ./VERSION

docker build -t piersfinlayson/build-${ARCH}:${VERSION} .
docker login
docker push piersfinlayson/build-${ARCH}:${VERSION}


