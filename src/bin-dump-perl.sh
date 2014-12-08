
perl $WORKING_DIR/main.pl

##file main.pl <<EOF

use strict;
use warnings;
use utf8;

sub conv {
    my ($ch) = @_;
    my $c = ord($ch);
    sprintf("%08B ", $c);
}

while (my $line = <STDIN>) {

    $line =~ s/(.)/conv($1)/eg;
    print $line;

}

EOF

