#!/bin/bash

DIR='../po/gl/'

SCRIPT_PYTHON='charts.py'
DEBUG='True'

totalTraducidas=0
totalFuzzy=0
totalNoTraducidas=0


if [ $DEBUG == 'True' ] ; then
    echo "fichero : traducidos : fuzzy : notraducidos"
fi

for file in `find $DIR -iname '*.po'` ; do

    nameFile=`basename $file`
    cadena=`msgfmt --statistics -o /dev/null $file 2>&1 `

    traducidas=`echo $cadena | egrep '[0-9]+ translated message[s]*' -o | egrep '[0-9]+' -o`
    fuzzy=`echo $cadena | egrep '[0-9]+ fuzzy translation[s]*' -o | egrep '[0-9]+' -o`
    noTraducidas=`echo $cadena | egrep '[0-9]+ untranslated message[s]*' -o | egrep '[0-9]+' -o `

    if [ -z $traducidas ] ; then traducidas=0 ; fi
    if [ -z $fuzzy ] ; then fuzzy=0 ; fi
    if [ -z $noTraducidas ] ; then noTraducidas=0 ; fi

    if [ $DEBUG = 'True' ] ; then
        echo "$nameFile : $traducidas - $fuzzy - $noTraducidas"
    fi;

    totalTraducidas=`echo $((traducidas + totalTraducidas))`
    totalFuzzy=`echo $((fuzzy + totalFuzzy))`
    totalNoTraducidas=`echo $((noTraducidas + totalNoTraducidas))`

    python $SCRIPT_PYTHON $traducidas $fuzzy $noTraducidas $nameFile

done



if [ $DEBUG = 'True' ] ; then
    echo "Total : $totalTraducidas - $totalFuzzy - $totalNoTraducidas"
fi;

python $SCRIPT_PYTHON $totalTraducidas $totalFuzzy $totalNoTraducidas 'total.po'