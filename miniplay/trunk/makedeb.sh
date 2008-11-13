#!/bin/sh

build_package() {
	make DESTDIR=sandbox install
	cp -r DEBIAN sandbox
	dpkg -b sandbox .
}

if [ "$1" == "install" ]; then
	build_package
	exit 0
fi

autoreconf -i
./configure --prefix=/usr
make
fakeroot $0 install
