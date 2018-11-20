#!/bin/sh
set -e

WGET_VERSION=1.18

apt-get update
apt-get install -y --force-yes --no-install-recommends libssl-dev
rm -rf /var/lib/apt/lists/*

cd $(mktemp -d)

wget http://ftp.gnu.org/gnu/wget/wget-$WGET_VERSION.tar.gz
tar xvzf wget-$WGET_VERSION.tar.gz
cd wget-$WGET_VERSION
./configure --with-ssl=openssl
make
make install
