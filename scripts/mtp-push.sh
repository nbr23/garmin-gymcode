#!/bin/bash
# Push .prg file to Garmin watch via MTP (macOS/Linux)
# Requires: libmtp (brew install libmtp on macOS, apt install on Ubuntu/Debian)

set -e

# If no argument provided, try to auto-detect .prg file in ./bin
if [ -z "$1" ]; then
    PRG_FILES=(bin/*.prg)

    # Check if any .prg files exist
    if [ ! -e "${PRG_FILES[0]}" ]; then
        echo "Error: No .prg files found in ./bin directory."
        echo "Usage: $0 [path/to/file.prg]"
        exit 1
    fi

    # Check if there's exactly one .prg file
    if [ ${#PRG_FILES[@]} -eq 1 ]; then
        PRG_FILE="${PRG_FILES[0]}"
    else
        echo "Error: Multiple .prg files found in ./bin directory:"
        printf '  %s\n' "${PRG_FILES[@]}"
        echo "Please specify which file to push: $0 <file.prg>"
        exit 1
    fi
else
    PRG_FILE="$1"
fi

if [ ! -f "$PRG_FILE" ]; then
    echo "Error: $PRG_FILE not found."
    exit 1
fi

if ! command -v mtp-connect &> /dev/null; then
    echo "Error: libmtp not installed."
    echo "Install with:"
    echo "  macOS: brew install libmtp"
    echo "  Ubuntu/Debian: sudo apt install libmtp-1 libmtp-dev libmtp-bin"
    exit 1
fi

echo "Sending $PRG_FILE to Garmin watch..."

# Use mtp-connect with --sendfile which accepts a path
# Capture output to check for "No devices"
OUTPUT=$(mtp-connect --sendfile "$PRG_FILE" "/GARMIN/Apps" 2>&1)

if echo "$OUTPUT" | grep -q "No devices"; then
    echo "Error: No Garmin watch detected via MTP."
    echo "Please connect your watch in MTP mode and try again."
    exit 1
fi

echo "Done! Disconnect watch and check your Garmin apps."
