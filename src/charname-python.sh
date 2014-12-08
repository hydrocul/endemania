
python3 $WORKING_DIR/main.py

##file main.py <<EOF

import sys
import unicodedata

result = ""
for line in sys.stdin:
    lf = False
    if line[-1] == "\n":
        line = line[:-1]
        lf = True
    for ch in line:
        try:
            result = result + "{U+" + ("%04X" % ord(ch)) + "/" + unicodedata.name(ch) + "}"
        except:
            result = result + "{U+" + ("%04X" % ord(ch)) + "}"
    if lf:
        result = result + "\n"
    sys.stdout.write(result)


EOF

