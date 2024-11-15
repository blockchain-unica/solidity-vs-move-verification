#!/usr/bin/env sh

ERROR_LOG_FILE="prover_error.txt"

if [ -f "$ERROR_LOG_FILE" ]; then
    rm "$ERROR_LOG_FILE"
fi
aptos move prove --dev > "$ERROR_LOG_FILE" 2>&1
