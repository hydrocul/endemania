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

build_simple nfc-perl.sh nfc-perl
build_simple nfd-perl.sh nfd-perl
build_simple nfkc-perl.sh nfkc-perl
build_simple nfkd-perl.sh nfkd-perl

build_simple charname-python.sh charname-python

build_simple lower-php.sh lower-php
build_simple upper-php.sh upper-php
build_simple lower-php-mb.sh lower-php-mb
build_simple upper-php-mb.sh upper-php-mb

for OPERATION in r n a s K KV H HV asKV c C; do
    if [ ! -e ./var/src/mb-convert-kana-$OPERATION-php -o ./src/mb-convert-kana-php.sh -nt ./var/src/mb-convert-kana-$OPERATION-php ]; then
        echo "Build: ./var/src/$OPERATION-python"
        cat ./src/mb-convert-kana-php.sh |
        sed s/\\\$OPERATION/$OPERATION/g \
        > ./var/src/mb-convert-kana-$OPERATION-php
    fi
done

for OPERATION in lower title upper casefold capitalize; do
    if [ ! -e ./var/src/$OPERATION-python -o ./src/upper-lower-python.sh -nt ./var/src/$OPERATION-python ]; then
        echo "Build: ./var/src/$OPERATION-python"
        cat ./src/upper-lower-python.sh |
        sed s/\\\$OPERATION/$OPERATION/g \
        > ./var/src/$OPERATION-python
    fi
done

PERL_ENCODING_LIST="sjis cp932 eucjp iso-2022-jp iso-8859-1 utf7 utf8 utf16 utf16be utf16le utf32 utf32be utf32le"
PHP_ENCODING_LIST="sjis sjis-win sjis-mac cp932 sjis-2004 eucjp eucjp-win eucjp-2004 iso-2022-jp iso-8859-1 utf7 utf8 utf16 utf16be utf16le utf32 utf32be utf32le"
NKF_ENCODING_LIST="sjis eucjp iso-2022-jp utf8"

cat > ./var/convert-encoding-name-perl.pl <<'EOF'

my $a = $ARGV[0];
print $a;

EOF

cat > ./var/convert-encoding-name-php.pl <<'EOF'

my $a = $ARGV[0];
if ($a eq 'utf16') {
  print 'utf-16';
} elsif ($a eq 'utf16le') {
  print 'utf-16le';
} elsif ($a eq 'utf16be') {
  print 'utf-16be';
} elsif ($a eq 'utf32') {
  print 'utf-32';
} elsif ($a eq 'utf32le') {
  print 'utf-32le';
} elsif ($a eq 'utf32be') {
  print 'utf-32be';
} else {
  print $a;
}

EOF

cat > ./var/convert-encoding-name-nkf1.pl <<'EOF'

my $a = $ARGV[0];
if ($a eq 'utf8') {
  print 'W';
} elsif ($a eq 'sjis') {
  print 'S';
} elsif ($a eq 'eucjp') {
  print 'E';
} elsif ($a eq 'iso-2022-jp') {
  print 'J';
} else {
  print $a;
}

EOF

cat > ./var/convert-encoding-name-nkf2.pl <<'EOF'

my $a = $ARGV[0];
if ($a eq 'utf8') {
  print 'w';
} elsif ($a eq 'sjis') {
  print 's';
} elsif ($a eq 'eucjp') {
  print 'e';
} elsif ($a eq 'iso-2022-jp') {
  print 'j';
} else {
  print $a;
}

EOF

for ENCODING_FROM in $PERL_ENCODING_LIST; do
    ENCODING_NAME_FROM=`perl ./var/convert-encoding-name-perl.pl $ENCODING_FROM`
    for ENCODING_TO in $PERL_ENCODING_LIST; do
        if [ $ENCODING_FROM != $ENCODING_TO ]; then
            if [ ! -e ./var/src/$ENCODING_FROM-to-$ENCODING_TO-perl -o ./src/convert-encoding-perl.sh -nt ./var/src/$ENCODING_FROM-to-$ENCODING_TO-perl ]; then
                echo "Build: ./var/src/$ENCODING_FROM-to-$ENCODING_TO-perl"
                ENCODING_NAME_TO=`perl ./var/convert-encoding-name-perl.pl $ENCODING_TO`
                cat ./src/convert-encoding-perl.sh |
                sed s/\\\$ENCODING_FROM/$ENCODING_NAME_FROM/g |
                sed s/\\\$ENCODING_TO/$ENCODING_NAME_TO/g \
                > ./var/src/$ENCODING_FROM-to-$ENCODING_TO-perl
            fi
        fi
    done
done

for ENCODING_FROM in $PHP_ENCODING_LIST; do
    ENCODING_NAME_FROM=`perl ./var/convert-encoding-name-php.pl $ENCODING_FROM`
    for ENCODING_TO in $PHP_ENCODING_LIST; do
        if [ $ENCODING_FROM != $ENCODING_TO ]; then
            if [ ! -e ./var/src/$ENCODING_FROM-to-$ENCODING_TO-php -o ./src/convert-encoding-php.sh -nt ./var/src/$ENCODING_FROM-to-$ENCODING_TO-php ]; then
                echo "Build: ./var/src/$ENCODING_FROM-to-$ENCODING_TO-php"
                ENCODING_NAME_TO=`perl ./var/convert-encoding-name-php.pl $ENCODING_TO`
                cat ./src/convert-encoding-php.sh |
                sed s/\\\$ENCODING_FROM/$ENCODING_NAME_FROM/g |
                sed s/\\\$ENCODING_TO/$ENCODING_NAME_TO/g \
                > ./var/src/$ENCODING_FROM-to-$ENCODING_TO-php
            fi
        fi
    done
done

for ENCODING_FROM in $NKF_ENCODING_LIST; do
    ENCODING_NAME_FROM=`perl ./var/convert-encoding-name-nkf1.pl $ENCODING_FROM`
    for ENCODING_TO in $NKF_ENCODING_LIST; do
        if [ $ENCODING_FROM != $ENCODING_TO ]; then
            if [ ! -e ./var/src/$ENCODING_FROM-to-$ENCODING_TO-nkf -o ./src/convert-encoding-nkf.sh -nt ./var/src/$ENCODING_FROM-to-$ENCODING_TO-nkf ]; then
                echo "Build: ./var/src/$ENCODING_FROM-to-$ENCODING_TO-perl"
                ENCODING_NAME_TO=`perl ./var/convert-encoding-name-nkf2.pl $ENCODING_TO`
                cat ./src/convert-encoding-nkf.sh |
                sed s/\\\$ENCODING_FROM/$ENCODING_NAME_FROM/g |
                sed s/\\\$ENCODING_TO/$ENCODING_NAME_TO/g \
                > ./var/src/$ENCODING_FROM-to-$ENCODING_TO-nkf
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


