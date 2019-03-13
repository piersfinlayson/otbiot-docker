#!/bin/bash
set -e 

VERSION=`cat VERSION`
echo "Create piersfinlayson/build manifests"
echo "       version: ${VERSION}"

docker login

# Create VERSION manifest
docker manifest create piersfinlayson/build:${VERSION} piersfinlayson/build-amd64:${VERSION} piersfinlayson/build-armv6l:${VERSION} piersfinlayson/build-armv7l:${VERSION}
docker manifest annotate --arch amd64 --os linux piersfinlayson/build:${VERSION} piersfinlayson/build-amd64:${VERSION}
docker manifest annotate --arch arm --os linux --variant armv6l piersfinlayson/build:${VERSION} piersfinlayson/build-armv6l:${VERSION}
docker manifest annotate --arch arm --os linux --variant armv7l piersfinlayson/build:${VERSION} piersfinlayson/build-armv7l:${VERSION}
docker manifest inspect piersfinlayson/build:${VERSION}
docker manifest push --purge piersfinlayson/build:${VERSION}

# Create latest manifest
docker manifest create piersfinlayson/build:latest piersfinlayson/build-amd64:${VERSION} piersfinlayson/build-armv6l:${VERSION} piersfinlayson/build-armv7l:${VERSION}
docker manifest annotate --arch amd64 --os linux piersfinlayson/build:latest piersfinlayson/build-amd64:${VERSION}
docker manifest annotate --arch arm --os linux --variant armv6l piersfinlayson/build:latest piersfinlayson/build-armv6l:${VERSION}
docker manifest annotate --arch arm --os linux --variant armv7l piersfinlayson/build:latest piersfinlayson/build-armv7l:${VERSION}
docker manifest inspect piersfinlayson/build:latest
docker manifest push --purge piersfinlayson/build:latest

docker pull piersfinlayson/build:latest
