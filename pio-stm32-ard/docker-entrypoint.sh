#!/bin/sh

set -e
cd builds/
if [ "$1" = 'bash' ]; then
  /bin/bash
else
  exec "$@"
fi
