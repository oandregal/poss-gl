#!/bin/bash


# Is poxml installed in the system?
if [ ! -x /usr/bin/po2xml ] ; then
	echo "Please, install the poxml package if you are in"
	echo "a Debian based system"
	exit 1
fi

ls -1 en |
sed 's/\.xml//' |
awk '{ \
	print "echo \"Generating xml files for "$1"...\";"
	print "po2xml en/"$1".xml ../po/gl/"$1".po > gl/"$1".xml" \
}' |
 sh
