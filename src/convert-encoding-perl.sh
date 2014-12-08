
perl $WORKING_DIR/main.pl

##file main.pl <<EOF

use strict;
use warnings;
use utf8;
use Encode qw/encode decode/;

sub getEncodingName {
  my ($name) = @_;
  $name;
}

my $encoding_from = getEncodingName("$ENCODING_FROM");
my $encoding_to   = getEncodingName("$ENCODING_TO");

while (my $line = <STDIN>) {
  print encode($encoding_to, decode($encoding_from, $line));
}

EOF

