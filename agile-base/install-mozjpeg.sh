#!/bin/sh
set -e

apt-get update
apt-get install -y --force-yes --no-install-recommends autoconf automake libtool nasm make pkg-config
rm -rf /var/lib/apt/lists/*

cd $(mktemp -d)

wget https://github.com/mozilla/mozjpeg/archive/master.zip
unzip master.zip
cd mozjpeg-master

autoreconf -fiv
./configure
make
make install

ln -s /opt/mozjpeg/bin/jpegtran /usr/bin/mozjpeg
