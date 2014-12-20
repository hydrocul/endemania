
perl $WORKING_DIR/main.pl

##file main.pl <<EOF

use strict;
use warnings;
use utf8;
use Encode qw/encode/;

sub conv {
    my ($ch) = @_;
    chr(hex($ch));
}

while (my $line = <STDIN>) {

    $line =~ s/(U\+)?([0-9a-fA-F]{2,6}) */conv($2)/eg;
    print encode("utf-8", $line);

}

EOF

