from distutils.core import setup
import py2exe

import sys
sys.path.append("tibdb")

setup(
	windows=['prolepsis.pyw'],
	options={"py2exe": {
		    "includes": ['dbhash', 'dumbdbm']
		}
	    }
    )
