#!/bin/bash
VERSION=$1
ARCH=$2
echo "Create piersfinlayson/build container"
echo "       version: ${VERSION}"
echo "  architecture: ${ARCH}"
echo "${VERSION}" > ./VERSION

docker login
docker build -t piersfinlayson/build-${ARCH}:${VERSION} .
docker push piersfinlayson/build-${ARCH}:${VERSION}


