#!/bin/bash
# Usage: check.sh file.md   (or: echo "text" | check.sh -)
D="$HOME/writing-tools"
F="$1"
if [ "$F" = "-" ] || [ -z "$F" ]; then
  T=$(mktemp)
  F="$T.md"
  cat > "$F"
fi
echo "=== Vale (style rules + write-good + proselint + Microsoft) ==="
"$D/bin/vale" --config "$D/.vale.ini" "$F"
echo
echo "=== Harper (grammar, spelling, repeats) ==="
"$D/bin/harper-cli" lint --format compact "$F" 2>&1 | grep -v "no user dictionary" | head -60
LT=$(ls "$D"/LanguageTool-*/languagetool-commandline.jar 2>/dev/null | head -1)
JAVA=$(ls "$D"/jre/Contents/Home/bin/java "$D"/jre/bin/java "$D"/jre/bin/java.exe 2>/dev/null | head -1)
if [ -n "$LT" ] && [ -n "$JAVA" ]; then
  echo
  echo "=== LanguageTool ==="
  "$JAVA" -jar "$LT" -l en-US "$F" 2>&1 | grep -v -E "^Expected|^Working on|^Time:"
fi
