BUILDING

windows:
 * if pyconfig.h is missing, you can get it from the source package in PC/
 * debug configuration will compile against release build, this can be changed

linux:
 * you will need something like: python-dev, libboost-filesystem-dev, libboost-dev, g++

RUNNING

 * accepts the gtest parameters, plus an optional number of SGM files to search (from 000 to the number you give)
 * run reuters.py to download and extract the expected SGM scan targets and keyword lists
