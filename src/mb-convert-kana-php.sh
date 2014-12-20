
php $WORKING_DIR/main.php

##file main.php <<EOF
<?php

while (!feof(STDIN)) {
  $line = fgets(STDIN);
  echo mb_convert_kana($line, "%OPERATION", "UTF-8");
}

EOF

