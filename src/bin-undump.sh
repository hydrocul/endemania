
perl $WORKING_DIR/main.pl

##file main.pl <<EOF

use strict;
use warnings;
use utf8;

sub conv {
    my ($ch) = @_;
    pack("B8", $ch);
}

while (my $line = <STDIN>) {

    $line =~ s/([01]{8}) */conv($1)/eg;
    print $line;

}

EOF

