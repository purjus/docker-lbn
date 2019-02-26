#!/bin/sh
set -e

VERSION=1.18

apt-get update
apt-get install -qq --no-install-recommends libssl-dev
rm -rf /var/lib/apt/lists/*

cd /tmp

wget http://ftp.gnu.org/gnu/wget/wget-$VERSION.tar.gz
tar xvzf wget-$VERSION.tar.gz
cd wget-$VERSION
./configure --with-ssl=openssl
make
make install

cd -
rm -Rf wget-$VERSION wget-$VERSION.tar.gz
