
php $WORKING_DIR/main.php

##file main.php <<EOF
<?php

while (!feof(STDIN)) {
  $line = fgets(STDIN);
  echo mb_convert_encoding($line, "%ENCODING_TO", "%ENCODING_FROM");
}

EOF

