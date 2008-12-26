#!/bin/bash

build_package() {
	rm -rf sandbox
	make DESTDIR=sandbox install
	cp -r DEBIAN sandbox/
	rm -rf sandbox/DEBIAN/.svn
	dpkg -b sandbox/ .
}

if [ "$1" == "install" ]; then
	build_package
	exit 0
fi

autoreconf -i
./configure --prefix=/usr
make
fakeroot $0 install
