
php $WORKING_DIR/main.php

##file main.php <<EOF
<?php

while (!feof(STDIN)) {
  $line = fgets(STDIN);
  echo strtolower($line);
}

EOF

