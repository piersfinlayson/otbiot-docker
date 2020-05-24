#!/bin/sh

set -e
cd /home/build/builds/
echo "$(cat /VERSION)"
exec "$@"
