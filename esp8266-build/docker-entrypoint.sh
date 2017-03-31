#!/bin/sh

set -e
cd /home/esp/builds/
if [ "$1" = 'make' ]; then
  cd $2 && make $3
elif [ "$1" = 'bash' ]; then
  /bin/bash
else
  exec "$@"
fi
