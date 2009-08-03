#!/usr/bin/env python

from xml.etree.ElementTree import ElementTree
import sys
import code

tree = ElementTree(file=open(sys.argv[1]))
print tree.getroot()
code.interact(local=locals())
