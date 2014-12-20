
perl $WORKING_DIR/main.pl

##file main.pl <<EOF

use strict;
use warnings;
use utf8;
use Encode qw/decode/;

sub conv {
    my ($ch) = @_;
    my $c = ord($ch);
    sprintf("U+%04X ", $c);
}

while (my $line = <STDIN>) {

    $line = decode("utf-8", $line);
    $line =~ s/(.)/conv($1)/eg;
    print $line;

}

EOF

