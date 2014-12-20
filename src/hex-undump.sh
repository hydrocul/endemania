
perl $WORKING_DIR/main.pl

##file main.pl <<EOF

use strict;
use warnings;
use utf8;

sub conv {
    my ($ch) = @_;
    pack("H2", $ch);
}

while (my $line = <STDIN>) {

    $line =~ s/([0-9a-fA-F]{2}) */conv($1)/eg;
    print $line;

}

EOF

