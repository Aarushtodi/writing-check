#!/bin/bash
# Installs the writing checker into ~/writing-tools and the /check skill into ~/.claude/skills/check.
# Works on Mac and on Windows through Git Bash. Free tools only, about 700 MB.
# Run it again any time. It replaces the tools, and keeps your accept.txt word list.
set -e

SRC="$(cd "$(dirname "$0")" && pwd)"
D="$HOME/writing-tools"
SKILL="$HOME/.claude/skills/check"
VALE_V=3.26.0
HARPER_V=3.1.0
LT_V=6.6
OS="${WC_OS:-$(uname -s)}"
ARCH="${WC_ARCH:-$(uname -m)}"

case "$OS" in
  Darwin)
    if [ "$ARCH" = "arm64" ]; then
      VALE_FILE="vale_${VALE_V}_macOS_arm64.tar.gz"; HARPER_FILE="harper-cli-aarch64-apple-darwin.tar.gz"; JRE_ARCH=aarch64
    else
      VALE_FILE="vale_${VALE_V}_macOS_64-bit.tar.gz"; HARPER_FILE="harper-cli-x86_64-apple-darwin.tar.gz"; JRE_ARCH=x64
    fi
    JRE_OS=mac; JRE_EXT=tar.gz ;;
  MINGW*|MSYS*|CYGWIN*|Windows)
    VALE_FILE="vale_${VALE_V}_Windows_64-bit.zip"; HARPER_FILE="harper-cli-x86_64-pc-windows-msvc.zip"
    JRE_OS=windows; JRE_ARCH=x64; JRE_EXT=zip ;;
  *)
    echo "This installer covers Mac and Windows (Git Bash). Found: $OS"; exit 1 ;;
esac

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

unpack() { # unpack <archive> <folder>
  mkdir -p "$2"
  case "$1" in
    *.tar.gz) tar -xzf "$1" -C "$2" ;;
    *.zip)
      if command -v unzip >/dev/null 2>&1; then
        unzip -q -o "$1" -d "$2"
      else
        powershell.exe -NoProfile -Command "Expand-Archive -Force -Path '$(cygpath -w "$1")' -DestinationPath '$(cygpath -w "$2")'"
      fi ;;
  esac
}

mkdir -p "$D/bin" "$SKILL"

echo "1 of 5: Vale"
curl -fsSL -o "$TMP/$VALE_FILE" "https://github.com/errata-ai/vale/releases/download/v${VALE_V}/$VALE_FILE"
unpack "$TMP/$VALE_FILE" "$TMP/vale"
cp "$TMP"/vale/vale* "$D/bin/"

echo "2 of 5: Harper"
curl -fsSL -o "$TMP/$HARPER_FILE" "https://github.com/Automattic/harper/releases/download/v${HARPER_V}/$HARPER_FILE"
unpack "$TMP/$HARPER_FILE" "$TMP/harper"
find "$TMP/harper" -type f -name 'harper-cli*' -exec cp {} "$D/bin/" \;

echo "3 of 5: LanguageTool (big download)"
curl -fsSL -o "$TMP/lt.zip" "https://languagetool.org/download/LanguageTool-${LT_V}.zip"
rm -rf "$D/LanguageTool-${LT_V}"
unpack "$TMP/lt.zip" "$D"

echo "4 of 5: Java for LanguageTool"
curl -fsSL -o "$TMP/jre.$JRE_EXT" "https://api.adoptium.net/v3/binary/latest/21/ga/$JRE_OS/$JRE_ARCH/jre/hotspot/normal/eclipse"
unpack "$TMP/jre.$JRE_EXT" "$TMP/jre"
rm -rf "$D/jre"
mv "$TMP"/jre/* "$D/jre"

echo "5 of 5: rules and the /check skill"
mkdir -p "$D/styles/config/vocabularies/MyRules"
ACCEPT="$D/styles/config/vocabularies/MyRules/accept.txt"
[ -f "$ACCEPT" ] && cp "$ACCEPT" "$TMP/accept.keep"
cp -R "$SRC/styles/." "$D/styles/"
[ -f "$TMP/accept.keep" ] && cp "$TMP/accept.keep" "$ACCEPT"
cp "$SRC/.vale.ini" "$SRC/check.sh" "$D/"
chmod +x "$D/check.sh" "$D"/bin/* 2>/dev/null || true
if [ -f "$SKILL/SKILL.md" ]; then cp "$SKILL/SKILL.md" "$SKILL/SKILL.md.bak"; fi
cp -R "$SRC/skill/check/." "$SKILL/"

if [ -n "$WC_LAYOUT_ONLY" ]; then
  ls "$D/bin" "$D/jre/bin" 2>/dev/null
  exit 0
fi

"$D/bin/vale" --config "$D/.vale.ini" sync

echo
echo "Test run. These should flag its, colege, approch and the dash:"
printf 'Their going to colege and its a good approch \xe2\x80\x94 we should go.\n' | "$D/check.sh" -
echo
echo "Installed. Restart Claude Code, then type /check"
