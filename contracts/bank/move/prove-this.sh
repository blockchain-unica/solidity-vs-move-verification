#!/usr/bin/env sh

# ERROR_LOG_FILE="prover_error.txt"

spec=$1
echo "checking spec: $spec"

if [ -f $spec ]; then
    echo "file $spec exists"
    cp "$spec" sources/
    aptos move prove --dev
    # echo "removing file: ${spec##*/}"
    rm sources/"${spec##*/}"
else
   echo "Spec $FILE does not exist."
fi

# if [ -f "$ERROR_LOG_FILE" ]; then
#     rm "$ERROR_LOG_FILE"
# fi
# aptos move prove --dev > "$ERROR_LOG_FILE" 2>&1
