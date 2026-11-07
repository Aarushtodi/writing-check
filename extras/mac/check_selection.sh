#!/bin/zsh
# Reads text on stdin (from the Quick Action), runs check.sh, opens the report in TextEdit.
IN=$(mktemp /tmp/chk_in.XXXXXX); mv "$IN" "$IN.md"; IN="$IN.md"
OUT="/tmp/writing_check_report.txt"
head -c 200000 > "$IN"
python3 "$HOME/writing-tools/report.py" "$IN" > "$OUT" 2>&1
open -e "$OUT"
