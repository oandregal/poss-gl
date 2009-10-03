#!/usr/bin/python
# -*- coding: utf-8 -*-

# This script creates a po file with:
# - msgids from file1 msgids
# - msgstr from file2 msgids

# Licensed by GPL3

import sys

file_ids    = sys.argv[1]
file_strs   = sys.argv[2]
file_po = sys.argv[3]

f_ids  = open(file_ids, 'r')
f_strs = open(file_strs, 'r')
f_po   = open(file_po, 'w')

for line in f_ids:
    if line.find("msgstr") == 0:
        f_po.write(f_strs.readline())
    else:
        f_po.write(line)

f_ids.close()
f_strs.close()
f_po.close()
