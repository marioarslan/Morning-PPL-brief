# PPL Coach for Claude Code

This turns Claude Code into Mario's personal strength coach. It hands you a daily
Push/Pull/Legs brief, knows when to call a rest day, tracks your streak and bodyweight,
and can run **automatically every morning** so the brief is waiting for you.

## What's in here
```
ppl-coach-cc/
├── CLAUDE.md              ← the coach's brain (profile + PPL logic + brief format)
├── state.json            ← your live state: rotation, streak, history, weight
├── morning-brief.sh      ← script that auto-generates the brief (for scheduling)
├── README.md             ← this file
└── .claude/commands/
    ├── brief.md          ← /brief  → today's session or rest call
    ├── done.md           ← /done   → log a finished session (advances rotation)
    └── rest.md           ← /rest   → log a rest day
```

## One-time setup
1. Install Claude Code if you haven't: `npm install -g @anthropic-ai/claude-code`
   (needs Node.js 18+). Run `claude` once and sign in.
2. Put this whole `ppl-coach-cc` folder wherever you like.
3. Make the script executable: `chmod +x morning-brief.sh`

## Daily use (manual)
Open a terminal in this folder and run `claude`, then:
- `/brief` — get today's brief (training session or rest day).
- `/done push` — after you train, log it (use push/pull/legs). Advances the rotation,
  bumps your streak, saves to history. Add notes: `/done push bench 60kg felt easy`.
- `/rest` — log a rest day (resets the streak, keeps your next session queued).
- Tell it a new weight anytime, e.g. `/done legs bw 72.5` or just mention it.

You never decide what to train — the coach reads `state.json` and tells you.

## Automatic morning brief (the hands-free part)
`morning-brief.sh` runs Claude Code headlessly (`claude -p`), writes the brief to
`today-brief.md`, and pops a notification on macOS. Schedule it:

**macOS / Linux (cron)** — run `crontab -e` and add (7:00 AM daily; fix the path):
```
0 7 * * * /full/path/to/ppl-coach-cc/morning-brief.sh
```

**Windows (Task Scheduler)** — create a Basic Task, trigger Daily at 7:00 AM, action
"Start a program", and point it at `morning-brief.sh` via Git Bash/WSL, or adapt the
script to a `.bat` calling `claude -p "/brief"`.

Each morning you'll find `today-brief.md` updated with your session. After you train,
run `/done` once so the rotation and streak stay accurate.

## Honest notes
- The auto-run still can't push to your phone by itself — it writes a file and a desktop
  notification on your computer. To get it on your phone, sync this folder (iCloud/Drive)
  or have the script email/message you the file. Ask Claude to add that if you want it.
- The brief only stays accurate if you log with `/done` or `/rest` — that's the one bit
  of input the coach needs from you.
- Headless runs use `--permission-mode acceptEdits` so the coach can read/update
  `state.json` without prompting. It only touches files in this folder.
