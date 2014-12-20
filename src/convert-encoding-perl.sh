
perl $WORKING_DIR/main.pl

##file main.pl <<EOF

use strict;
use warnings;
use utf8;
use Encode qw/encode decode/;

while (my $line = <STDIN>) {
  print encode("%ENCODING_TO", decode("%ENCODING_FROM", $line));
}

EOF

