#!/bin/bash

set -ex

OPENSSL_VER=${1:-"1.1.1q"}
# apt install -y openssl
SSLDIR=$(openssl version -d | cut -d: -f2 | tr -d [:space:]\")

curl -OJL https://www.openssl.org/source/openssl-${OPENSSL_VER}.tar.gz
tar xf openssl-${OPENSSL_VER}.tar.gz
cd openssl-${OPENSSL_VER}
./config -fPIC --prefix=/opt/local/openssl --openssldir=${SSLDIR} zlib shared && \
    make -j$(nproc) &&\
    make install_sw
