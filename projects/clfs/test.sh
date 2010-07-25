#!/bin/bash

startdir=$(pwd)
cd dir
prove -r "../pjd-fstest-20080816/tests/$1"
cd "$startdir"
