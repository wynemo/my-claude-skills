#!/bin/bash
# port_finder.sh - Find network connections for a process
# Usage: port_finder.sh <process_name_or_pid>

TARGET="$1"

if [ -z "$TARGET" ]; then
    echo "Usage: $0 <process_name_or_pid>"
    exit 1
fi

# Check if target is a PID (numeric) or process name
if [[ "$TARGET" =~ ^[0-9]+$ ]]; then
    PIDS="$TARGET"
else
    PIDS=$(pgrep -f "$TARGET" 2>/dev/null || true)
fi

if [ -z "$PIDS" ]; then
    echo "No process found: $TARGET"
    exit 1
fi

for PID in $PIDS; do
    echo "=== PID $PID ==="
    ps -p "$PID" -o pid,user,comm,args 2>/dev/null | tail -n +2
    echo ""

    # Check owner, use sudo for root processes
    OWNER=$(ps -p "$PID" -o user= 2>/dev/null | tr -d ' ')
    if [ "$OWNER" = "root" ]; then
        sudo lsof -p "$PID" 2>/dev/null | grep -E "IPv4|IPv6|UDP"
    else
        lsof -p "$PID" 2>/dev/null | grep -E "IPv4|IPv6|UDP"
    fi
    echo ""
done
