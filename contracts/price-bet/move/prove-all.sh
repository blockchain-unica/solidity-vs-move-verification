#!/usr/bin/env sh

# ERROR_LOG_FILE="prover_error.txt"

for spec in specs/*.spec.move; do 
    echo "checking spec: $spec"
    cp "$spec" sources/
    aptos move prove --dev
    # echo "removing file: ${spec##*/}"
    rm sources/"${spec##*/}"   
done

# if [ -f "$ERROR_LOG_FILE" ]; then
#     rm "$ERROR_LOG_FILE"
# fi
# aptos move prove --dev > "$ERROR_LOG_FILE" 2>&1
