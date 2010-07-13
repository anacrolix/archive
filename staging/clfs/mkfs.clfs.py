#!/usr/bin/env python

import optparse
import os

import clfs
            
def main():
    parser = optparse.OptionParser()
    opts, args = parser.parse_args()
    print opts, args
    clfs.format_clusterfs(device_path=args[0])

if __name__ == "__main__":
    main()
