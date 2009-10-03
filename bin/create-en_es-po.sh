#!/bin/bash

# Licensed by GPL3

# script to create a po file with:
# - msgid from file_ids (the original strings, i.e.: po file with english strings as msgid)
# - msgstrs from file_strs (i.e.: a po file with the spanish strings as msgid)

file_ids=$1
file_strs=$2
file_po=$3

file_strs_only='/tmp/foo'
file_aux='/tmp/aux'

cat $file_strs | grep ^msgid > $file_aux
sed 's/msgid/msgstr/' $file_aux > $file_strs_only

python generate-po.py $file_ids $file_strs_only $file_po

#dir_with_pos=$4
#bash change-headers.sh $4
