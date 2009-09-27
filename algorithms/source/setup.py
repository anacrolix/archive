#!/usr/bin/env python

from distutils.core import setup, Extension
extension_mod = Extension("chorspool", ["horspool.cpp", "horspool_pymod.cpp"])
setup(
        name="???",
        ext_modules=[extension_mod],
        #modules=["horspool"],
    )
