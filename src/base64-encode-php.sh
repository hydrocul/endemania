
php $WORKING_DIR/main.php

##file main.php <<EOF
<?php

while (!feof(STDIN)) {
  $line = fgets(STDIN);
  $lf = false;
  if (preg_match("/^(.*)\n\z/", $line, $matches)) {
    $lf = true;
    $line = $matches[1];
  }
  echo base64_encode($line);
  if ($lf) {
    echo "\n";
  }
}

EOF

