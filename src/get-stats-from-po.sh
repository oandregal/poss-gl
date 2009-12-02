#!/bin/bash

DIR='../po/gl/'
IMG_DIR='../web/img/'
PORCENTAXE_FILE='../web/seccion-porcentaxe.html'

SCRIPT_PYTHON='charts.py'
PASS=''
USER='producingoss@outrafoto.net'
DEBUG='True'

totalTraducidas=0
totalFuzzy=0
totalNoTraducidas=0


usage() {
    echo -e "\n`basename $0` [-p password] [-h]\n"
    echo "-p password: Optional parameter. If it's specified, the script uploads the images and seccion-porcentaxe.html to the ftp"
    echo "-h : This message"
    exit -1
}



# Process input arguments
while [ $# -gt 0 ] ; do
    case $1
        in
        -p)
           PASS=$2
            shift 2 ;;

        *)
            usage ;;
    esac
done



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
        echo -e "\n$file : $traducidas - $fuzzy - $noTraducidas"
    fi;

    totalTraducidas=`echo $((traducidas + totalTraducidas))`
    totalFuzzy=`echo $((fuzzy + totalFuzzy))`
    totalNoTraducidas=`echo $((noTraducidas + totalNoTraducidas))`

    python $SCRIPT_PYTHON $traducidas $fuzzy $noTraducidas $nameFile

    if ! [ -z $PASS ] ; then
        curl -T $pngPathFile -u $USER:$PASS ftp://producingoss.ghandalf.org/img/
    fi

done

if [ $DEBUG = 'True' ] ; then
    echo -e "\nTotal : $totalTraducidas - $totalFuzzy - $totalNoTraducidas"
fi;

# Processing the statistics for the whole book
pngPathFile="${IMG_DIR}libro.png"
python $SCRIPT_PYTHON $totalTraducidas $totalFuzzy $totalNoTraducidas $pngPathFile
convert $pngPathFile -crop 100x35+2-2 +repage $pngPathFile

if ! [ -z $PASS ] ; then
    curl -T $pngPathFile -u $USER:$PASS ftp://producingoss.ghandalf.org/img/
    curl -T $PORCENTAXE_FILE -u $USER:$PASS ftp://producingoss.ghandalf.org/
fi
