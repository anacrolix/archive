import os
os.environ["PATH"] += os.pathsep + r"gtk\bin"
#sys.path.append(
from distutils.core import setup
import py2exe

setup(
        windows=[{"script": "lanshare-gtk.py"}],
        options={"py2exe": {
                "packages": "encodings",
                "includes": "cairo, pango, pangocairo, atk, gobject",
            }},
    )
