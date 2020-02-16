#!/bin/bash
set -e 

VERSION=$1
ARG2=$2
ARCH=$(docker info 2> /dev/null|grep Architecture|awk '{print $2}')
if [ $ARCH == x86_64 ]
  then
    ARCH=amd64
fi

if [ $ARCH == amd64 ]
  then
    PARALLEL_MAKE="-j4"
else
  # Run out of RAM doing parallel make on raspberry pis
  PARALLEL_MAKE=""
fi

echo "Create piersfinlayson/build container"
echo "        version: ${VERSION}"
echo "   architecture: ${ARCH}"
echo "  PARALLEL_MAKE: ${PARALLEL_MAKE}"
echo "      other arg: ${ARG2}"
echo "${VERSION}" > ./VERSION

docker build $ARG2 --build-arg PARALLEL_MAKE=$PARALLEL_MAKE -t piersfinlayson/build-${ARCH}:${VERSION} .
docker login -u piersfinlayson
docker push piersfinlayson/build-${ARCH}:${VERSION}


