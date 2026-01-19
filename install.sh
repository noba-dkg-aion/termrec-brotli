#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSHRC="$HOME/.zshrc"
MOD_DIR="$HOME/.config/termrec"
MOD_FILE="$MOD_DIR/termrec.zsh"
BIN_DIR="$HOME/.local/bin"

marker_begin="# >>> termrec >>>"
marker_end="# <<< termrec <<<"

mkdir -p "$MOD_DIR" "$BIN_DIR" "$HOME/ops/termrec"

# Ensure deps
if ! command -v asciinema >/dev/null 2>&1 || ! command -v brotli >/dev/null 2>&1; then
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update -y
    sudo apt-get install -y asciinema brotli
  else
    echo "termrec: missing dependencies (asciinema, brotli)." >&2
  fi
fi

cp "$ROOT_DIR/zsh/termrec.zsh" "$MOD_FILE"

ln -sf "$ROOT_DIR/bin/termrec-record" "$BIN_DIR/termrec-record"
ln -sf "$ROOT_DIR/bin/termrec-sweep" "$BIN_DIR/termrec-sweep"
ln -sf "$ROOT_DIR/bin/termrec-summary" "$BIN_DIR/termrec-summary"

if ! grep -q "termrec" "$ZSHRC"; then
  {
    echo ""
    echo "$marker_begin"
    echo "export TERMREC_ENABLED=1"
    echo "export TERMREC_AUTOREC=1"
    echo "# export TERMREC_PAUSE=1"
    echo "# export TERMREC_DIR=\"$HOME/ops/termrec\""
    echo "if [ -f \"$MOD_FILE\" ]; then"
    echo "  . \"$MOD_FILE\""
    echo "fi"
    echo "$marker_end"
  } >> "$ZSHRC"
  echo "Added termrec block to ~/.zshrc"
else
  echo "~/.zshrc already contains termrec block"
fi

echo "Install complete. Start a new zsh session."
