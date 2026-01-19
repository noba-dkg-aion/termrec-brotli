#!/usr/bin/env bash
set -euo pipefail

ZSHRC="$HOME/.zshrc"
MOD_FILE="$HOME/.config/termrec/termrec.zsh"
BIN_DIR="$HOME/.local/bin"

marker_begin="# >>> termrec >>>"
marker_end="# <<< termrec <<<"

if grep -q "termrec" "$ZSHRC"; then
  tmpfile="$(mktemp)"
  awk -v begin="$marker_begin" -v end="$marker_end" '
    $0==begin {skip=1; next}
    $0==end {skip=0; next}
    skip==0 {print}
  ' "$ZSHRC" > "$tmpfile"
  mv "$tmpfile" "$ZSHRC"
  echo "Removed termrec block from ~/.zshrc"
else
  echo "No termrec block found in ~/.zshrc"
fi

rm -f "$MOD_FILE"
rm -f "$BIN_DIR/termrec-record" "$BIN_DIR/termrec-sweep" "$BIN_DIR/termrec-summary"

echo "Uninstall complete. Existing recordings remain in ~/ops/termrec."
