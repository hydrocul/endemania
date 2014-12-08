#!/bin/sh

cd `dirname $0`

if [ ! -e var ]; then
    mkdir -pv var
fi

if [ ! -e ttools ]; then
    (
        git clone https://github.com/hydrocul/ttools.git ttools
        cd ttools
        ./make.sh
        cp bin/ttr ../var/ttr
    )
fi

if [ ! -e var/src ]; then
    mkdir -pv var/src
fi

build_simple()
{
    if [ ! -e ./var/src/$2 -o ./src/$1 -nt ./var/src/$2 ]; then
        echo "Build: ./var/src/$2"
        cat ./src/$1 > ./var/src/$2
    fi
}

build_simple hex-undump-perl.sh hex-undump
build_simple hex-dump-perl.sh hex-dump
build_simple dec-dump-perl.sh dec-dump
build_simple bin-undump-perl.sh bin-undump
build_simple bin-dump-perl.sh bin-dump

build_simple url-encode-php.sh url-encode-php
build_simple base64-encode-php.sh base64-encode-php

build_simple unicode-escape-perl.sh unicode-escape
build_simple unicode-unescape-perl.sh unicode-unescape
build_simple unicode-dump-perl.sh unicode-dump
build_simple unicode-undump-perl.sh unicode-undump

build_simple nfkc-perl.sh nfkc-perl
build_simple nfkd-perl.sh nfkd-perl
build_simple nfc-perl.sh nfc-perl
build_simple nfd-perl.sh nfd-perl

build_simple charname-python.sh charname-python

PERL_ENCODING_LIST="sjis cp932 eucjp iso-2022-jp iso-8859-1 utf7 utf8 utf16 utf16be utf16le"
PHP_ENCODING_LIST="sjis sjis-win sjis-mac cp932 sjis-2004 eucjp eucjp-win eucjp-2004 iso-2022-jp iso-8859-1 utf7 utf8 utf16be utf16le utf32be utf32le"

for ENCODING_FROM in $PERL_ENCODING_LIST; do
    for ENCODING_TO in $PERL_ENCODING_LIST; do
        if [ $ENCODING_FROM != $ENCODING_TO ]; then
            if [ ! -e ./var/src/$ENCODING_FROM-to-$ENCODING_TO-by-perl -o ./src/convert-encoding-perl.sh -nt ./var/src/$ENCODING_FROM-to-$ENCODING_TO-by-perl ]; then
                echo "Build: ./var/src/$ENCODING_FROM-to-$ENCODING_TO-by-perl"
                cat ./src/convert-encoding-perl.sh |
                sed s/\\\$ENCODING_FROM/$ENCODING_FROM/g |
                sed s/\\\$ENCODING_TO/$ENCODING_TO/g \
                > ./var/src/$ENCODING_FROM-to-$ENCODING_TO-by-perl
            fi
        fi
    done
done

for ENCODING_FROM in $PHP_ENCODING_LIST; do
    for ENCODING_TO in $PHP_ENCODING_LIST; do
        if [ $ENCODING_FROM != $ENCODING_TO ]; then
            if [ ! -e ./var/src/$ENCODING_FROM-to-$ENCODING_TO-by-php -o ./src/convert-encoding-php.sh -nt ./var/src/$ENCODING_FROM-to-$ENCODING_TO-by-php ]; then
                echo "Build: ./var/src/$ENCODING_FROM-to-$ENCODING_TO-by-php"
                cat ./src/convert-encoding-php.sh |
                sed s/\\\$ENCODING_FROM/$ENCODING_FROM/g |
                sed s/\\\$ENCODING_TO/$ENCODING_TO/g \
                > ./var/src/$ENCODING_FROM-to-$ENCODING_TO-by-php
            fi
        fi
    done
done

if [ ! -e bin ]; then
    mkdir -pv bin
fi

ls ./var/src | while read fname; do
    if [ ! -e ./bin/ende-$fname -o ./var/src/$fname -nt ./bin/ende-$fname ]; then
        echo "Build: ./bin/ende-$fname"
        ./var/ttr --build ./var/src/$fname > ./bin/ende-$fname
        chmod 755 ./bin/ende-$fname
    fi
done


