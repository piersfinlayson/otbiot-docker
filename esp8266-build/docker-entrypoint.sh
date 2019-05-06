#!/bin/sh

set -e
echo "Container Version $(cat /VERSION)"
echo "SDK Version $(find ~/esp-open-sdk/ -name 'ESP*SDK*.zip' -print | awk -F"-" '{ print $4 }' | awk -F"." '{ print $1"."$2 }')"
cd /home/esp/builds/
if [ "$1" = 'make' ]; then
  cd $2 && make $3
elif [ "$1" = 'bash' ]; then
  /bin/bash
else
  exec "$@"
fi
