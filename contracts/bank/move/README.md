# Move on Aptos Implementation and Verification of Bank

How to run

Inside this directory run:

> $ aptos move prove --dev

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
