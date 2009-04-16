import buildsys
import lang

from classes import \
    BuildStep, Configure, ExplicitRule, ImplicitRule, \
    Install, LibraryConfig, PhonyRule, SystemTask
from functions import pybake_main, clean_targets

functions.initialize()
