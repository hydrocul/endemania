
perl $WORKING_DIR/main.pl

##file main.pl <<EOF

use strict;
use warnings;
use utf8;
use Encode qw/encode decode/;
use Unicode::Normalize qw/NFKC NFKD NFC NFD/;

while (my $line = <STDIN>) {

    $line = decode("utf-8", $line);
    $line = NFKC($line);
    print encode("utf-8", $line);

}

EOF

