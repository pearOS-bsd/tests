# tests

Tests that cross repositories: run real Mac programs on pearOS and compare the result.

- `smoke/` — `smoke.sh`: start the stack on the test VM, open TextEdit and Stickies through `open`, take screenshots (`wsshot`) and check that a window exists (`wswins`).
- `open-programs/` — small programs built against our AppKit (`hello.m`, `app2.m`, `app3.m` controls, `win.m`, `textsys.m`) and `demo.c`.
- `darwinator-apps/` — runs third-party Mac apps through darwinator (Keka, AppCleaner, The Unarchiver, ffmpeg); `qmp-click.py`, `guest-run-keka.sh`.
- `docs/` — the results per app (AppCleaner, IINA, iOS binaries, Keka).

The programs are built with `open/deploy.sh` (repository `open`).
