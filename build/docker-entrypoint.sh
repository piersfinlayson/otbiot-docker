#!/bin/sh

set -e
cd /home/build/builds/
echo "Build Container Version $(cat /VERSION)"
exec "$@"
