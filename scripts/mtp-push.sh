#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 app.prg [app.prg ...]" >&2
    exit 1
fi

for prg in "$@"; do
    if [[ ! -f "$prg" ]]; then
        echo "Error: $prg not found; run 'make build' first." >&2
        exit 1
    fi
done

if ! command -v mtp-connect >/dev/null 2>&1; then
    echo "Error: libmtp not installed. Install with: brew install libmtp (macOS) or apt install mtp-tools (Debian/Ubuntu)" >&2
    exit 1
fi

# macOS ptpcamerad grabs the MTP device as soon as it appears; keep killing it for the duration of the transfer.
suppress_ptpcamerad() {
    while :; do
        killall -9 ptpcamerad 2>/dev/null || true
        sleep 0.2
    done
}

if [[ "$(uname -s)" == Darwin ]]; then
    suppress_ptpcamerad &
    suppressor=$!
    trap 'kill "$suppressor" 2>/dev/null || true' EXIT
    sleep 1
fi

for prg in "$@"; do
    echo "Sending $(basename "$prg") to the watch..."
    status=0
    output=$(mtp-connect --sendfile "$prg" "/GARMIN/Apps" 2>&1) || status=$?
    printf '%s\n' "$output"
    if [[ $status -ne 0 ]] || ! grep -q '^New file ID:' <<<"$output"; then
        echo "Error: failed to send $(basename "$prg"). Replug the watch and retry." >&2
        exit 1
    fi
done
echo "Done. Disconnect the watch to install."
