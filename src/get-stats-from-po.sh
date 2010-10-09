#!/bin/bash

DIR='../po/gl/'
IMG_DIR='../web/img/'
PORCENTAXE_FILE='../web/seccion-porcentaxe.html'
TEMPLATE_PORCENTAXE_FILE='../web/seccion-porcentaxe.tmp'

SCRIPT_PYTHON='charts.py'
PASS=''
USER='producingoss@outrafoto.net'
DEBUG='True'

totalPalabras=0
palabrasLibro=0
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
    echo "fichero : traducidos : fuzzy : notraducidos : totalpalabras"
fi

cp -f $TEMPLATE_PORCENTAXE_FILE $PORCENTAXE_FILE

for file in `find $DIR -iname '*.po'` ; do

    #Be aware: This will not work if the file have points in its filename
    code=`basename $file | cut -d'.' -f1 | tr '[:lower:]' '[:upper:]'` #used for identify the strings to substitute on TEMPLATE_PORCENTAXE_FILE
    pngPathFile=$IMG_DIR`basename $file | cut -d'.' -f1`.png
    totalPalabras=`pocount --short-words $file|egrep '[0-9]*' -o|sed '2!d'`
    cadena=`msgfmt --statistics -o /dev/null $file 2>&1 `

    if [ $LANG = 'es_ES.UTF-8' ] ; then
        traducidas=`echo $cadena | egrep '[0-9]+ mensaje[s]* traducidos' -o | egrep '[0-9]+' -o`
        fuzzy=`echo $cadena | egrep '[0-9]+ traducci.* difusa[s]*' -o | egrep '[0-9]+' -o`
        noTraducidas=`echo $cadena | egrep '[0-9]+ mensaje[s]* sin traducir' -o | egrep '[0-9]+' -o`
    else
        traducidas=`echo $cadena | egrep '[0-9]+ translated message[s]*' -o | egrep '[0-9]+' -o`
        fuzzy=`echo $cadena | egrep '[0-9]+ fuzzy translation[s]*' -o | egrep '[0-9]+' -o`
        noTraducidas=`echo $cadena | egrep '[0-9]+ untranslated message[s]*' -o | egrep '[0-9]+' -o `
    fi

    if [ -z $traducidas ] ; then traducidas=0 ; fi
    if [ -z $fuzzy ] ; then fuzzy=0 ; fi
    if [ -z $noTraducidas ] ; then noTraducidas=0 ; fi

    totalCadenas=$((traducidas + fuzzy + noTraducidas))

    sed -i "s/${code}_TRADUCIDAS/$traducidas/  " $PORCENTAXE_FILE
    sed -i "s/${code}_TOTAIS/$totalCadenas/" $PORCENTAXE_FILE
    sed -i "s/${code}_PALABRAS/$totalPalabras/" $PORCENTAXE_FILE

    if [ $DEBUG = 'True' ] ; then
        echo -e "\n$file : $traducidas - $fuzzy - $noTraducidas - $totalPalabras"
    fi;

    totalTraducidas=`echo $((traducidas + totalTraducidas))`
    totalFuzzy=`echo $((fuzzy + totalFuzzy))`
    totalNoTraducidas=`echo $((noTraducidas + totalNoTraducidas))`
    palabrasLibro=`echo $((totalPalabras + palabrasLibro))`
    echo "\n"+$palabrasLibro

    python $SCRIPT_PYTHON $traducidas $fuzzy $noTraducidas $pngPathFile
    convert $pngPathFile -crop 100x35+2-2 +repage $pngPathFile

    if ! [ -z $PASS ] ; then
        curl -T $pngPathFile -u $USER:$PASS ftp://producingoss.ghandalf.org/img/
    fi
done

if [ $DEBUG = 'True' ] ; then
    echo -e "\nTotal : $totalTraducidas - $totalFuzzy - $totalNoTraducidas - $palabrasLibro"
fi;

# Processing the statistics for the whole book
sed -i "s/LIBRO_TRADUCIDAS/$totalTraducidas/ " $PORCENTAXE_FILE
totalCadenas=$((totalTraducidas + totalFuzzy + totalNoTraducidas))
sed -i "s/LIBRO_TOTAIS/$totalCadenas/" $PORCENTAXE_FILE
pngPathFile="${IMG_DIR}libro.png"
sed -i "s/LIBRO_PALABRAS/$palabrasLibro/ " $PORCENTAXE_FILE
python $SCRIPT_PYTHON $totalTraducidas $totalFuzzy $totalNoTraducidas $pngPathFile
convert $pngPathFile -crop 100x35+2-2 +repage $pngPathFile

if ! [ -z $PASS ] ; then
    curl -T $pngPathFile -u $USER:$PASS ftp://producingoss.ghandalf.org/img/
    curl -T $PORCENTAXE_FILE -u $USER:$PASS ftp://producingoss.ghandalf.org/
fi
