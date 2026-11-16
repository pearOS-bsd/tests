#!/bin/sh
# Smoke test on the FreeBSD test VM (ssh -p 2222, key ~/fbsd-vm/id_ed25519): wsd + the system bar must be running (d/bsd, startbar.sh).
#   sh tests/smoke/smoke.sh [OUTDIR]        -> OUTDIR/<app>.png and a PASS / FAIL line per app
OUT="${1:-.}"; K="-i $HOME/fbsd-vm/id_ed25519 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -q -o ConnectTimeout=10"; mkdir -p "$OUT"; FAIL=0
for app in TextEdit Stickies; do
	ssh -p 2222 $K root@localhost "export WS_SOCKET=/tmp/wsd.sock HOME=/root XDG_SESSION_TYPE=wsd; pkill -9 -x $app; sleep 1; cd /root; (open -a $app >/tmp/smoke-$app.out 2>&1 &); sleep 25; n=\$(wswins 2>/dev/null | grep -c 'level 0'); echo windows:\$n; cd /tmp; wsshot /tmp/smoke-$app.ppm; pgrep -x $app >/dev/null && echo alive" > "$OUT/$app.txt" 2>&1
	scp -P 2222 $K root@localhost:/tmp/smoke-$app.ppm "$OUT/$app.ppm" >/dev/null 2>&1
	if grep -q alive "$OUT/$app.txt"; then echo "PASS $app"; else echo "FAIL $app"; FAIL=1; fi
done
exit $FAIL
