
php $WORKING_DIR/main.php

##file main.php <<EOF
<?php

function getEncodingName($arg) {
  if ($arg == "utf16le") {
    return "utf-16le";
  } else if ($arg == "utf16be") {
    return "utf-16be";
  } else {
    return $arg;
  }
}

$encoding_from = getEncodingName("$ENCODING_FROM");
$encoding_to   = getEncodingName("$ENCODING_TO");
while (!feof(STDIN)) {
  $line = fgets(STDIN);
  echo mb_convert_encoding($line, $encoding_to, $encoding_from);
}

EOF

