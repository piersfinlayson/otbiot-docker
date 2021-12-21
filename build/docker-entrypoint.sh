#!/bin/bash

set -e
cd /home/build/builds/
echo "$(cat /VERSION)"

OPENSSL_CUR_VER=$OPENSSL_VERSION
if [ -z $OPENSSL_CUR_VER ]
then
  echo "No version of OpenSSL provided"
  exit 1
fi
echo "Current version of OpenSSL is $OPENSSL_CUR_VER"
#OPENSSL_CUR_VER_DL="https://www.openssl.org/source/openssl-$OPENSSL_CUR_VER.tar.gz"

OPENSSL_NEW_VER=`/usr/bin/python3 << EOF
import sys
ssl_ver="$OPENSSL_CUR_VER"
bits = ssl_ver.split('.')
if len(bits) != 3 or len(bits[2]) != 2:
  print("Invalid ssl_ver")
  usage()
  exit(1)
verA = int(bits[0])
verB = int(bits[1])
verC = int(bits[2][0])
verLet = bits[2][1]
newVerLet = chr(ord(verLet) + 1)
print("%d.%d.%d%c" % (verA, verB, verC, newVerLet))
EOF
`
OPENSSL_NEW_VER_DL="https://www.openssl.org/source/openssl-$OPENSSL_NEW_VER.tar.gz"
OPENSSL_NEW_VER_RC=`curl -o /dev/null -s -w "%{http_code}\n" $OPENSSL_NEW_VER_DL`
if [ $OPENSSL_NEW_VER_RC -ne 404 ]
then
  echo "!!!!! New version of OpenSSL available $OPENSSL_NEW_VER"
else
  echo "No new version of OpenSSL available - latest is $OPENSSL_CUR_VER"
fi

set +e
RUST_CHECK=$(rustup check | grep linux | grep -o "Up to date" )
set -e
if [ -z "$RUST_CHECK" ]
then
  echo "!!!!! New verson of Rust available: $(rustup check)"
else
  echo "No new version of Rust available"
fi

exec "$@"
