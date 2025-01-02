# Using the benchmark

To run unit tests (in the `tests` folder):
```bash
aptos move test --dev
```

To prove a single specification with the Move Prover:
```bash
./prove-this.sh properties/myspec.spec.move
```

To prove all the specs in the `properties` directory:
```bash
./prove-all.sh
```

Note that it is possible to redirect the output of the prover to a file with the following commands:

append to output_file
> aptos move prove --dev >> output_file 2>&1

(over) write output_file
> aptos move prove --dev > output_file 2>&1
