# termrec-brotli

Terminal text replay recording for zsh with automatic Brotli compression, daily summaries, and a minimal CLI-only install.

## Quickstart

```bash
./install.sh
exec zsh
```

By default, every new interactive zsh session is recorded and compressed automatically.

## Replay

- **Asciinema (preferred)**:
  - Decompress: `brotli -d /path/to/session.cast.br`
  - Replay: `asciinema play /path/to/session.cast`
- **script fallback**:
  - Decompress: `brotli -d /path/to/session.log.br` and `brotli -d /path/to/session.timing.br`
  - Replay: `scriptreplay /path/to/session.timing /path/to/session.log`

## Daily summary

```bash
termrec-summary            # today
termrec-summary 2026-01-19 # specific date
```

Outputs are written to:
- `~/ops/termrec/summary-YYYY-MM-DD.json`
- `~/ops/termrec/summary-YYYY-MM-DD.txt`

## How it works

- `zsh/termrec.zsh` is sourced from `~/.zshrc`.
- If enabled, it auto-starts a recorder that launches a new shell.
- On exit, recordings are compressed with Brotli and raw files removed.
- A sweep runs on startup and exit to compress any leftovers.

## Configuration

Set in `~/.zshrc` (see the block installed by `install.sh`):

- `TERMREC_ENABLED=1` (set to `0` to disable)
- `TERMREC_AUTOREC=1` (set to `0` for manual start only)
- `TERMREC_PAUSE=1` (temporary pause / private mode)
- `TERMREC_DIR=~/ops/termrec` (storage root)
- `TERMREC_KEEP_RAW=1` (keep uncompressed files)
- `TERMREC_MIN_AGE_SECS=60` (sweep age threshold)

Manual start mode:

```bash
TERMREC_AUTOREC=0
termrec-record
```

## Privacy & safety

- Local-first. No telemetry beyond what asciinema/script produce locally.
- No keylogging. This records **terminal output** for replay, not raw keystrokes.
- Use `TERMREC_PAUSE=1` for sensitive sessions.

## Uninstall

```bash
./uninstall.sh
```

Recordings remain in `~/ops/termrec/`.
