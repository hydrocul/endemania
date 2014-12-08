
perl $WORKING_DIR/main.pl

##file main.pl <<EOF

use strict;
use warnings;
use utf8;
use Encode qw/encode decode/;

sub conv1 {
    my ($y) = @_;
    '\\' x (length($y) * 2) . 'u';
}

sub conv2 {
    my ($ch) = @_;
    my $c = ord($ch);
    if ($c >= 0x20 && $c <= 0x7E) {
        return $ch;
    }
    if ($c >= 0x10000) {
        my $c1 = ($c - 0x10000) / 0x400 + 0xD800;
        my $c2 = ($c - 0x10000) % 0x400 + 0xDC00;
        sprintf("\\u%04x\\u%04x", $c1, $c2);
    } else {
        sprintf("\\u%04x", $c);
    }
}

while (my $line = <STDIN>) {

    $line = decode("utf-8", $line);
    $line =~ s/(\\+)u/conv1($1)/eg;
    $line =~ s/(.)/conv2($1)/eg;
    print encode("utf-8", $line);

}

EOF

