#!/bin/bash

mntdir="testmountpoint"
loopdev="testvvsfs.img"

cleanup () {
	sudo umount $mntdir
	sudo rmmod vvsfs
	rm -rvf $mntdir
}

if [ "$1" == "down" ]; then
	cleanup
	exit 0
fi
make all || exit 1
dd if=/dev/zero of="$loopdev" bs=512 count=100
./mkfs.vvsfs "$loopdev"
mkdir "$mntdir"
sudo insmod vvsfs.ko
sudo mount -o loop "$loopdev" "$mntdir"
if [ "$1" == "up" ]; then
	exit 0
fi

cleanup
exit 0
