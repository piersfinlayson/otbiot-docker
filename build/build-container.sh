#!/bin/bash
set -e 

VERSION=$1
ARCH=$(docker info 2> /dev/null|grep Architecture|awk '{print $2}')
if [ $ARCH == x86_64 ]
  then
    ARCH=amd64
fi

if [ $ARCH == armv6l ]
  then
    # Raspberry Pi Zeros only have a single core and not enough RAM to do parallel building of GCC
    PARALLEL_MAKE=
else
  PARALLEL_MAKE="-j4"
fi

echo "Create piersfinlayson/build container"
echo "        version: ${VERSION}"
echo "   architecture: ${ARCH}"
echo "  PARALLEL_MAKE: ${PARALLEL_MAKE}"
echo "${VERSION}" > ./VERSION

docker build --build-arg PARALLEL_MAKE=$PARALLEL_MAKE -t piersfinlayson/build-${ARCH}:${VERSION} .
docker login
docker push piersfinlayson/build-${ARCH}:${VERSION}


