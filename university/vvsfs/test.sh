#!/bin/bash

mntdir="mountdir"
loopdev="testblock"

cleanup () {
	sudo umount -v "$mntdir"
	sudo rmmod -v vvsfs
	rmdir -v "$mntdir"
	rm -v "$loopdev"
}

if [ "$1" == "down" ]; then
	cleanup
	exit 0
fi
cusdir=/usr/src/linux
[ -n "$KSRCDIR" ] && cusdir="$KSRCDIR"
make KSRCDIR="$cusdir" all || exit 1
dd if=/dev/zero of="$loopdev" bs=512 count=100
./mkfs.vvsfs "$loopdev"
mkdir "$mntdir"
sudo insmod vvsfs.ko
sudo mount -vo loop -t vvsfs "$loopdev" "$mntdir"
if [ "$1" == "up" ]; then
	exit 0
fi
[ -d "$mntdir" ] && cd "$mntdir"
for fn in a b c d e ; do
	echo $fn > $fn
done
for z in 1 2 3; do
	for fn in * ; do
		cp -v $fn "${fn}${fn}"
	done
done
cat *
for fn in * ; do
	echo '' > $fn
	echo lol > $fn
done
cat *
rm -v *
cd ..
cleanup
exit 0
