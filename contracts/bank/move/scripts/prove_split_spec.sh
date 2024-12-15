#!/usr/bin/env sh


# ERROR_LOG_FILE="prover_error.txt"

for spec in ../split_properties/representable/*; do 
    echo "current spec: $spec"
    cp "$spec" ../sources
    aptos move prove --dev
done

# if [ -f "$ERROR_LOG_FILE" ]; then
#     rm "$ERROR_LOG_FILE"
# fi
# aptos move prove --dev > "$ERROR_LOG_FILE" 2>&1
