import collections
import curses
import itertools
import math
import operator
import optparse
import os
import os.path
import pdb
import pprint
import pwd
import re
import signal
import socket
import string
import struct
import subprocess
import sys
import time
import unittest

PacketEndpoints = collections.namedtuple("PacketEndpoints", ("source", "destination", "family", "protocol"))
