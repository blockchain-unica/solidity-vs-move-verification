# Move on Aptos Implementation and Verification of Bank

the split_properties/representable directory contains the properties to be proven, splitted by file 
(i.e. one property -> one file).
To check these properties with the move prover it is necessary to copy one of these files (.spec) inside the 
directory sources (which contains bank.move) and from there run the command

> aptos move prove --dev

Which will run the prover against the spec file
The output may be long
Note that on unix OS (tested on Arch) it is possible to redirect the output of the prover to 
a file with the following commands

append to output_file
> aptos move prove --dev >> output_file 2>&1

(over) write output_file
> aptos move prove --dev > output_file 2>&1

## Directort Content
 
### multi_properties
all the properties in one single spec block -> difficult to parse old version

### sources 
code of the contract
the subdirectory prover_outputs contains the textual output of the last run of the move prover for illustrative purposes 

### split_properties
properties to prove splitted into representable 
(those properties that, to the best of my knowledge, are indeed representable by the move prover)
and not_representable (those properties that, to the best of my knowledge, are not representable with the move prover ) for now

### tests 
where tests are

### Move.toml 
settings for Move 

### Prover.toml 
settings for Move Prover

### properties.md 
properties to check
