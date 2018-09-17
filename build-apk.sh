#!/bin/bash

SRC="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

if [ "$#" == "0" ]; then
  echo "usage: $0 <PACKAGE>..."
  exit 1
fi

while (( "$#" )); do
  PKG=$1

  if [ ! -d $SRC/xentec-aports/*/$PKG ]; then
    echo "package directory does not exist"
    exit 1
  fi

  pushd $SRC/xentec-aports/*/$PKG &> /dev/null

  echo "BUILDING: $PWD"

  docker run \
    -e MAKEFLAGS="-j $(($(nproc)+2))" \
    -e RSA_PRIVATE_KEY="$(cat ~/.abuild/kenneth.shaw@knq.io-5b9e5e63.rsa)" \
    -e RSA_PRIVATE_KEY_NAME="kenneth.shaw@knq.io-5b9e5e63.rsa" \
    -v "$PWD:/home/builder/package" \
    -v "$HOME/.abuild/packages:/packages" \
    -v "$HOME/.abuild/kenneth.shaw@knq.io-5b9e5e63.rsa.pub:/etc/apk/keys/kenneth.shaw@knq.io-5b9e5e63.rsa.pub" \
    andyshinn/alpine-abuild:edge

  popd &> /dev/null

  shift

done
