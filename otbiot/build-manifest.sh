#!/bin/bash
set -e 

VERSION=`cat VERSION`
echo "Create piersfinlayson/otbiot manifests"
echo "       version: ${VERSION}"

docker login

# Create VERSION manifest
docker manifest create piersfinlayson/otbiot:${VERSION} piersfinlayson/otbiot-amd64:${VERSION} piersfinlayson/otbiot-armv7l:${VERSION}
docker manifest create piersfinlayson/otbiot:${VERSION} piersfinlayson/otbiot-amd64:${VERSION} piersfinlayson/otbiot-armv6l:${VERSION} piersfinlayson/otbiot-armv7l:${VERSION}
docker manifest annotate --arch amd64 --os linux piersfinlayson/otbiot:${VERSION} piersfinlayson/otbiot-amd64:${VERSION}
docker manifest annotate --arch arm --os linux --variant armv6l piersfinlayson/otbiot:${VERSION} piersfinlayson/otbiot-armv6l:${VERSION}
docker manifest annotate --arch arm --os linux --variant armv7l piersfinlayson/otbiot:${VERSION} piersfinlayson/otbiot-armv7l:${VERSION}
docker manifest inspect piersfinlayson/otbiot:${VERSION}
docker manifest push --purge piersfinlayson/otbiot:${VERSION}

# Create latest manifest
docker manifest create piersfinlayson/otbiot:latest piersfinlayson/otbiot-amd64:${VERSION} piersfinlayson/otbiot-armv7l:${VERSION}
docker manifest create piersfinlayson/otbiot:latest piersfinlayson/otbiot-amd64:${VERSION} piersfinlayson/otbiot-armv6l:${VERSION} piersfinlayson/otbiot-armv7l:${VERSION}
docker manifest annotate --arch amd64 --os linux piersfinlayson/otbiot:latest piersfinlayson/otbiot-amd64:${VERSION}
docker manifest annotate --arch arm --os linux --variant armv6l piersfinlayson/otbiot:latest piersfinlayson/otbiot-armv6l:${VERSION}
docker manifest annotate --arch arm --os linux --variant armv7l piersfinlayson/otbiot:latest piersfinlayson/otbiot-armv7l:${VERSION}
docker manifest inspect piersfinlayson/otbiot:latest
docker manifest push --purge piersfinlayson/otbiot:latest


