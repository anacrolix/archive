#!/bin/bash

set -eux

g++ -o conway main.cpp -I ../../utility/c `sdl-config --cflags --libs` -l boost_thread-mt
