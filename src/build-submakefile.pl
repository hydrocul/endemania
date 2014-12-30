use strict;
use warnings;
use utf8;

my @simples = qw/hex-undump
                 hex-dump
                 dec-dump
                 bin-undump
                 bin-dump
                 url-encode-php
                 base64-encode-php
                 unicode-escape
                 unicode-unescape
                 unicode-dump
                 unicode-undump
                 nfc-perl
                 nfd-perl
                 nfkc-perl
                 nfkd-perl
                 charname-python
                 lower-php
                 upper-php
                 lower-php-mb
                 upper-php-mb/;

my @upper_lower_python = qw/lower title upper casefold capitalize/;

my @mb_convert_kana_php = qw/r n a s K KV H HV asKV c C/;

my @encoding_perl = qw/sjis cp932 eucjp iso-2022-jp iso-8859-1 utf7 utf8 utf16 utf16be utf16le utf32 utf32be utf32le/;
my @encoding_php = qw/sjis sjis-win sjis-mac cp932 sjis-2004 eucjp eucjp-win eucjp-2004 iso-2022-jp iso-8859-1 iso-8859-2 iso-8859-3 iso-8859-4 iso-8859-5 iso-8859-6 iso-8859-7 iso-8859-8 iso-8859-9 iso-8859-10 iso-8859-13 iso-8859-14 iso-8859-15 utf7 utf8 utf16 utf16be utf16le utf32 utf32be utf32le/;
my @encoding_ruby = qw/sjis sjis-win sjis-mac eucjp iso-2022-jp iso-2022-jp-2 iso-8859-1 iso-8859-2 iso-8859-3 iso-8859-4 iso-8859-5 iso-8859-6 iso-8859-7 iso-8859-8 iso-8859-9 iso-8859-10 iso-8859-11 iso-8859-13 iso-8859-14 iso-8859-15 iso-8859-16 utf7 utf8 utf8-mac utf16 utf16be utf16le utf32 utf32be utf32le/;

my @encoding_nkf = qw/sjis eucjp iso-2022-jp utf8/;

sub encoding_cross_flag {
    my ($from, $to) = @_;
    if ($from eq $to) {
        '';
    } elsif ($from =~ /\Autf[^8]+\z/) {
        if ($to eq 'utf8') {
            1;
        } else {
            '';
        }
    } elsif ($to =~ /\Autf[^8]+\z/) {
        if ($from eq 'utf8') {
            1;
        } else {
            '';
        }
    } else {
        1;
    }
}

sub encoding_name_perl {
    my ($name) = @_;
    $name;
}

sub encoding_name_php {
    my ($name) = @_;
    if ($name eq 'utf16') {
      'utf-16';
    } elsif ($name eq 'utf16le') {
      'utf-16le';
    } elsif ($name eq 'utf16be') {
      'utf-16be';
    } elsif ($name eq 'utf32') {
      'utf-32';
    } elsif ($name eq 'utf32le') {
      'utf-32le';
    } elsif ($name eq 'utf32be') {
      'utf-32be';
    } else {
      $name;
    }
}

sub encoding_name_ruby {
    my ($name) = @_;
    if ($name eq 'sjis') {
        'Shift_JIS';
    } elsif ($name eq 'sjis-win') {
        'Windows-31J';
    } elsif ($name eq 'sjis-mac') {
        'MacJapanese';
    } elsif ($name eq 'eucjp') {
        'EUC-JP';
    } elsif ($name eq 'iso-2022-jp') {
        'ISO-2022-JP';
    } elsif ($name eq 'iso-2022-jp-2') {
        'ISO-2022-JP-2';
    } elsif ($name eq 'iso-8859-1') {
        'ISO-8859-1';
    } elsif ($name eq 'iso-8859-2') {
        'ISO-8859-2';
    } elsif ($name eq 'iso-8859-3') {
        'ISO-8859-3';
    } elsif ($name eq 'iso-8859-4') {
        'ISO-8859-4';
    } elsif ($name eq 'iso-8859-5') {
        'ISO-8859-5';
    } elsif ($name eq 'iso-8859-6') {
        'ISO-8859-6';
    } elsif ($name eq 'iso-8859-7') {
        'ISO-8859-7';
    } elsif ($name eq 'iso-8859-8') {
        'ISO-8859-8';
    } elsif ($name eq 'iso-8859-9') {
        'ISO-8859-9';
    } elsif ($name eq 'iso-8859-10') {
        'ISO-8859-10';
    } elsif ($name eq 'iso-8859-11') {
        'ISO-8859-11';
    } elsif ($name eq 'iso-8859-13') {
        'ISO-8859-13';
    } elsif ($name eq 'iso-8859-14') {
        'ISO-8859-14';
    } elsif ($name eq 'iso-8859-15') {
        'ISO-8859-15';
    } elsif ($name eq 'iso-8859-16') {
        'ISO-8859-16';
    } elsif ($name eq 'utf7') {
        'UTF-7';
    } elsif ($name eq 'utf8') {
        'UTF-8';
    } elsif ($name eq 'utf8-mac') {
        'UTF8-MAC';
    } elsif ($name eq 'utf16') {
        'UTF-16';
    } elsif ($name eq 'utf16be') {
        'UTF-16BE';
    } elsif ($name eq 'utf16le') {
        'UTF-16LE';
    } elsif ($name eq 'utf32') {
        'UTF-32';
    } elsif ($name eq 'utf32be') {
        'UTF-32BE';
    } elsif ($name eq 'utf32le') {
        'UTF-32LE';
    } else {
        $name;
    }
}

sub encoding_name_nkf1 {
    my ($name) = @_;
    if ($name eq 'utf8') {
      'W';
    } elsif ($name eq 'sjis') {
      'S';
    } elsif ($name eq 'eucjp') {
      'E';
    } elsif ($name eq 'iso-2022-jp') {
      'J';
    } else {
      $name;
    }
}

sub encoding_name_nkf2 {
    my ($name) = @_;
    if ($name eq 'utf8') {
      'w';
    } elsif ($name eq 'sjis') {
      's';
    } elsif ($name eq 'eucjp') {
      'e';
    } elsif ($name eq 'iso-2022-jp') {
      'j';
    } else {
      $name;
    }
}

my @targets = @simples;
push(@targets, map { "$_-python" } @upper_lower_python);
push(@targets, map { "mb-convert-kana-$_-php" } @mb_convert_kana_php);
foreach my $from (@encoding_perl) {
    foreach my $to (@encoding_perl) {
        if (encoding_cross_flag($from, $to)) {
            push(@targets, "$from-to-$to-perl");
        }
    }
}
foreach my $from (@encoding_php) {
    foreach my $to (@encoding_php) {
        if (encoding_cross_flag($from, $to)) {
            push(@targets, "$from-to-$to-php");
        }
    }
}
foreach my $from (@encoding_ruby) {
    foreach my $to (@encoding_ruby) {
        if (encoding_cross_flag($from, $to)) {
            push(@targets, "$from-to-$to-ruby");
        }
    }
}
foreach my $from (@encoding_nkf) {
    foreach my $to (@encoding_nkf) {
        if (encoding_cross_flag($from, $to)) {
            push(@targets, "$from-to-$to-nkf");
        }
    }
}

print "bin/_:";
foreach my $name (@targets) {
    print " bin/ende-$name";
}
print "\n";
print "\n";

foreach my $name (@targets) {
    print "bin/ende-$name: var/src/$name\n";
    print "\t./var/ttr --build var/src/$name > bin/ende-$name\n";
    print "\tchmod 755 bin/ende-$name\n";
    print "\n";
}

foreach my $name (@simples) {
    print "var/src/$name: src/$name.sh\n";
    print "\tcp src/$name.sh var/src/$name\n";
    print "\n";
}

foreach my $name (@upper_lower_python) {
    print "var/src/$name-python: src/upper-lower-python.sh\n";
    print "\tcat src/upper-lower-python.sh | sed s/%OPERATION/$name/g > var/src/$name-python\n";
    print "\n";
}

foreach my $name (@mb_convert_kana_php) {
    print "var/src/mb-convert-kana-$name-php: src/mb-convert-kana-php.sh\n";
    print "\tcat src/mb-convert-kana-php.sh | sed s/%OPERATION/$name/g > var/src/mb-convert-kana-$name-php\n";
    print "\n";
}

foreach my $from (@encoding_perl) {
    my $from_name = encoding_name_perl($from);
    foreach my $to (@encoding_perl) {
        if (encoding_cross_flag($from, $to)) {
            my $to_name = encoding_name_perl($to);
            print "var/src/$from-to-$to-perl: src/convert-encoding-perl.sh\n";
            print "\tcat src/convert-encoding-perl.sh | sed s/%ENCODING_FROM/$from_name/g | sed s/%ENCODING_TO/$to_name/g > var/src/$from-to-$to-perl\n";
            print "\n";
        }
    }
}

foreach my $from (@encoding_php) {
    my $from_name = encoding_name_php($from);
    foreach my $to (@encoding_php) {
        if (encoding_cross_flag($from, $to)) {
            my $to_name = encoding_name_php($to);
            print "var/src/$from-to-$to-php: src/convert-encoding-php.sh\n";
            print "\tcat src/convert-encoding-php.sh | sed s/%ENCODING_FROM/$from_name/g | sed s/%ENCODING_TO/$to_name/g > var/src/$from-to-$to-php\n";
            print "\n";
        }
    }
}

foreach my $from (@encoding_ruby) {
    my $from_name = encoding_name_ruby($from);
    foreach my $to (@encoding_ruby) {
        if (encoding_cross_flag($from, $to)) {
            my $to_name = encoding_name_ruby($to);
            print "var/src/$from-to-$to-ruby: src/convert-encoding-ruby.sh\n";
            print "\tcat src/convert-encoding-ruby.sh | sed s/%ENCODING_FROM/$from_name/g | sed s/%ENCODING_TO/$to_name/g > var/src/$from-to-$to-ruby\n";
            print "\n";
        }
    }
}

foreach my $from (@encoding_nkf) {
    my $from_name = encoding_name_nkf1($from);
    foreach my $to (@encoding_nkf) {
        if (encoding_cross_flag($from, $to)) {
            my $to_name = encoding_name_nkf2($to);
            print "var/src/$from-to-$to-nkf: src/convert-encoding-nkf.sh\n";
            print "\tcat src/convert-encoding-nkf.sh | sed s/%ENCODING_FROM/$from_name/g | sed s/%ENCODING_TO/$to_name/g > var/src/$from-to-$to-nkf\n";
            print "\n";
        }
    }
}


