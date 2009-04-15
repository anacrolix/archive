import sys
sys.path.append(".")

from classes import BuildStep, Configure, ExplicitRule, ImplicitRule, PhonyRule, SystemTask
from compiler import *
from functions import pybake_main, clean_targets

import buildsys

functions.initialize()
