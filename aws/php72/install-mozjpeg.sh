#!/bin/sh
set -eu

VERSION=3.3.1

apt-get update
apt-get install --yes --no-install-recommends autoconf automake libtool nasm make pkg-config
rm -rf /var/lib/apt/lists/*

cd $(mktemp -d)

wget "https://github.com/mozilla/mozjpeg/archive/v$VERSION.tar.gz"
tar -xvf "v$VERSION.tar.gz"

cd "mozjpeg-$VERSION"

autoreconf -fiv
./configure
make
make install

apt-get purge --yes --auto-remove libtool nasm

ln -s /opt/mozjpeg/bin/jpegtran /usr/bin/mozjpeg
