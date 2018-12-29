#!/bin/bash
set -e 

VERSION=$1
ARCH=$(docker info 2> /dev/null|grep Architecture|awk '{print $2}')
if [ $ARCH == x86_64 ]
  then
    ARCH=amd64
fi
echo "Create piersfinlayson/otbiot container"
echo "       version: ${VERSION}"
echo "  architecture: ${ARCH}"
echo "${VERSION}" > ./VERSION

# Need --no-cache for force git clone
docker build --no-cache -t piersfinlayson/otbiot-${ARCH}:${VERSION} .
docker login
docker push piersfinlayson/otbiot-${ARCH}:${VERSION}


