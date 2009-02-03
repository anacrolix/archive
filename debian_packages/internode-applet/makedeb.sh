#!/bin/bash

PACKAGE_NAME='internode-applet-1.6'
STAGE_DIR='debroot'
BUILD_ARCH=$(dpkg-architecture -qDEB_BUILD_ARCH)

wget -c http://www.users.on.net/~spohlenz/internode/${PACKAGE_NAME}.tar.gz
tar -xzf ${PACKAGE_NAME}.tar.gz
cd ${PACKAGE_NAME}
python setup.py install --root=../${STAGE_DIR}
cd ..
mkdir -p ${STAGE_DIR}/DEBIAN
sed "s/@BUILD_ARCH@/${BUILD_ARCH}/" control > ${STAGE_DIR}/DEBIAN/control
dpkg-deb -b ${STAGE_DIR} .

