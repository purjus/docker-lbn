#!/bin/sh
set -e

VERSION=3.3.1

cd /tmp

apt-get update
apt-get install -qq automake libtool nasm # autoconf make
rm -rf /var/lib/apt/lists/*

wget https://github.com/mozilla/mozjpeg/archive/v${VERSION}.tar.gz
tar -xvf v${VERSION}.tar.gz
cd mozjpeg-${VERSION}/
autoreconf -fiv
mkdir build && cd build
sh ../configure
make install
ln -s /opt/libmozjpeg/bin/jpegtran /usr/local/bin/mozjpeg

cd /tmp
rm -Rf v${VERSION}.tar.gz mozjpeg-${VERSION}
apt-get remove -qq automake autotools-dev libtool nasm 
