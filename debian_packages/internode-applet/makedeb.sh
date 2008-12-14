#!/bin/bash

wget -c http://www.users.on.net/~spohlenz/internode/internode-applet-1.6.tar.gz
tar -xvzf internode-applet-1.6.tar.gz
cd internode-applet-1.6
python setup.py install --root=../debroot
cd ..
mkdir -p debroot/DEBIAN
cp control debroot/DEBIAN
dpkg-deb -b debroot .
