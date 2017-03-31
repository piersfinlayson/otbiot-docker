#!/bin/sh

set -e
cd /scripts/
if [ "$1" = 'bash' ]; then
  /bin/bash
else
  exec "$@"
fi
