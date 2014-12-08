
perl $WORKING_DIR/main.pl

##file main.pl <<EOF

use strict;
use warnings;
use utf8;
use Encode qw/encode decode/;

sub conv1 {
    my ($y, $hex) = @_;
    my $len = length($y);
    if ($len % 2 == 0) {
        return '\\' x ($len / 2) . 'u' . $hex;
    } else {
        return '\\' x (($len - 1) / 2) . chr(hex($hex));
    }
}

sub conv2 {
    my ($ch1, $ch2) = @_;
    my $c = (ord($ch1) - 0xD800) * 0x400 + (ord($ch2) - 0xDC00) + 0x10000;
    chr($c);
}

while (my $line = <STDIN>) {

    $line = decode("utf-8", $line);
    $line =~ s/(\\+)u+([0-9a-fA-F]{4})/conv1($1, $2)/eg;
    $line =~ s/([\x{D800}-\x{DBFF}])([\x{DC00}-\x{DFFF}])/conv2($1, $2)/eg;
    print encode("utf-8", $line);

}

EOF

