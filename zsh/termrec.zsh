# termrec zsh integration
# Enable/disable:
#   export TERMREC_ENABLED=1
#   export TERMREC_AUTOREC=1
#   export TERMREC_PAUSE=1

[[ -n "$ZSH_VERSION" ]] || return 0
[[ $- == *i* ]] || return 0

: "${TERMREC_ENABLED:=1}"
: "${TERMREC_AUTOREC:=1}"

if [[ "$TERMREC_ENABLED" != "1" ]]; then
  return 0
fi

termrec_sweep() {
  command termrec-sweep >/dev/null 2>&1 || true
}

# Sweep leftovers on startup (avoid recursion in recorded subshell)
if [[ -z "${TERMREC_ACTIVE:-}" ]]; then
  termrec_sweep
fi

# Auto-start recorder unless paused or already inside recorder
if [[ "${TERMREC_AUTOREC}" == "1" && -z "${TERMREC_ACTIVE:-}" && -z "${TERMREC_PAUSE:-}" ]]; then
  if command -v termrec-record >/dev/null 2>&1; then
    exec termrec-record --auto
  fi
fi

# On exit, sweep any leftover uncompressed recordings
TRAPEXIT() {
  if [[ -z "${TERMREC_ACTIVE:-}" ]]; then
    termrec_sweep
  fi
}
