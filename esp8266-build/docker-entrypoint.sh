#!/bin/sh

set -e
cd /home/esp/builds/
if [ "$1" = 'make' ]; then
  echo "SDK Version $(cat /VERSION)"
  cd $2 && make $3
elif [ "$1" = 'bash' ]; then
  echo "SDK Version $(cat /VERSION)"
  /bin/bash
else
  echo "SDK Version $(cat /VERSION)"
  exec "$@"
fi
