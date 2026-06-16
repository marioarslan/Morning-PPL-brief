#!/usr/bin/env bash
# morning-brief.sh — generates Mario's daily brief automatically.
# Runs Claude Code headlessly, writes the brief to today-brief.md, and (on macOS)
# fires a notification so Mario knows it's ready. Schedule this with cron/launchd
# (macOS/Linux) or Task Scheduler (Windows) — see README.md.

# --- resolve this script's own folder so cron can run it from anywhere ---
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

OUT="$DIR/today-brief.md"
DATE="$(date +%Y-%m-%d)"

# Run the coach non-interactively. --permission-mode acceptEdits lets it read state.json
# without prompting. Output is plain text appended under a dated header.
{
  echo "# Daily brief — $DATE"
  echo
  claude -p "/brief" --permission-mode acceptEdits
} > "$OUT" 2>>"$DIR/coach.log"

# Optional desktop notification (macOS). Harmless if it isn't available.
if command -v osascript >/dev/null 2>&1; then
  osascript -e 'display notification "Your workout brief is ready — open today-brief.md" with title "PPL Coach"' >/dev/null 2>&1
fi

echo "Brief written to $OUT"
