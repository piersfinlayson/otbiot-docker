#!/bin/bash
set -e 

VERSION=$1
ARG2=$2
./build-container-no-upload.sh $1 $2
ARCH=$(docker info 2> /dev/null|grep Architecture|awk '{print $2}')
if [ $ARCH == x86_64 ]
  then
    ARCH=amd64
fi

echo "Upload piersfinlayson/build container"
echo "        version: ${VERSION}"
echo "   architecture: ${ARCH}"

docker login -u piersfinlayson
docker push piersfinlayson/build-${ARCH}:${VERSION}


