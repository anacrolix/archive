#!/bin/bash

clean_up() {
	fusermount -u dir
}

quit_signal() {
	echo 'caught signal!'
	clean_up
	exit
}

trap clean_up SIGHUP SIGINT SIGTERM
./mount.clfs dev dir
clean_up
