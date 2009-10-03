#!/bin/bash

# script to change metainfo in po files
# Licensed by GPL3

dir_with_pos=$1

aux='/tmp/foo'
for i in `ls $dir_with_pos/*.po`; do
    echo $i
    sed -e 's/SOME DESCRIPTIVE TITLE/Producing OSS - Translating project/g' \
        -e 's/PACKAGE VERSION/Producing OSS/g' \
        -e 's/LANGUAGE/Galician/g' \
        -e 's/http:\/\/bugs.kde.org/producingoss@listas.ghandalf.org/g' \
        -e 's/kde-i18n-doc@kde.org/producingoss@listas.ghandalf.org/g' \
        $i > $aux
    mv $aux $i
done
