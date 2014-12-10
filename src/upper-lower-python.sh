
python3 $WORKING_DIR/main.py

##file main.py <<EOF

import sys

for line in sys.stdin:
    line = line.$OPERATION()
    sys.stdout.write(line)

EOF

