#!/bin/zsh
OUT="/tmp/writing_fix_report.txt"
osascript -e 'display notification "Editing your text, about 30 seconds..." with title "Writing Fix"' >/dev/null 2>&1
python3 "$HOME/writing-tools/fix.py" > "$OUT" 2>&1
osascript -e 'display notification "Fixed text copied to your clipboard. Report is open." with title "Writing Fix"' >/dev/null 2>&1
open -e "$OUT"
