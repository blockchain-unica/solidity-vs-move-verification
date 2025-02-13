# Vault

Vaults are a security mechanism to prevent cryptocurrency from being immediately withdrawn by an adversary who has stolen the owner's private key.

To create the vault, the owner specifies:
- itself as the vault's **owner**; 
- a **recovery key**, which can be used to cancel a withdraw request;
- a **wait time**, which has to elapse between a withdraw request and the actual finalization of the cryptocurrency transfer.

The contract has the following entry points:
- **receive(amount)**, which allows anyone to deposit tokens into the contract;
- **withdraw(receiver, amount)**, which allows the owner to issue a withdraw request, specifying the receiver and the desired amount;
- **finalize()**, which allows the owner to finalize the pending withdraw after the wait time has passed since the request;
- **cancel()**, which allows the owner of the recovery key to cancel the withdraw request during the wait time.

To this purpose, the vault contract implements a state transition system with states IDLE and REQ, and transitions: 
- IDLE -> IDLE upon a receive action
- IDLE -> REQ upon a withdraw action
- REQ -> REQ upon a receive action
- REQ -> IDLE upon a finalize or a cancel action

## Implementations

- **Solidity**: [contract](certora/Vault.sol) | [properties](certora/)
- **Move**: [contract](move/sources/vault.move) | [properties](move/specs)

## Properties

- **cancel-not-revert**: a transaction `cancel()` does not abort if the signer uses the recovery key, and the state is REQ

- **cancel-revert**: a transaction `cancel()` aborts if the signer uses a key different from the recovery key, or the state is not REQ

- <a name="finalize-not-revert">**finalize-not-revert**</a>: a `finalize()` transaction does not abort if it is sent by the owner, in state REQ, and at least wait_time time units have elapsed after request_timestamp

- <a name="finalize-revert">**finalize-revert**</a>: a transaction `finalize()` aborts if the sender is not the owner, or if the state is not REQ, or wait_time has not passed after request_timestamp

- **receive-not-revert**: anyone can always send tokens to the contract

- **withdraw-not-revert**: a transaction `withdraw(amount)` does not abort if amount is less than or equal to the contract balance, the sender is the owner, and the state is IDLE

- **withdraw-revert**: a transaction `withdraw(amount)` aborts if amount is more than the contract balance, or if the sender is not the owner, or if the state is not IDLE

- <a name="keys-distinct">**keys-distinct**</a>: the owner key and the recovery key are distinct

- <a name="owner-immutable">**owner-immutable**</a>: the vault owner never changes

- <a name="state-idle-req-global">**state-idle-req-global**</a>: in any blockchain state, the vault state is IDLE or REQ

- **state-idle-req-local**: during the execution of a transaction, the vault state is always IDLE or REQ

- **state-req-amount-consistent**: if the state is REQ, then the amount to be withdrawn is less or equal than the contract balance

- <a name="keys-invariant-global">**keys-invariant-global**</a>: in any blockchain state, the owner key and the recovery key cannot be changed after the contract is deployed

- <a name="keys-invariant-local">**keys-invariant-local**</a>: during the execution of a transaction, the owner key and the recovery key cannot be changed after the contract is deployed

- **call-trace**: if a sequence of function calls is valid, then the sequence of called functions is a prefix of the language denoted by the regex `(receive* + (withdraw receive* (cancel + finalize)))*`

- <a name="finalize-after-withdraw-not-revert">**finalize-after-withdraw-not-revert**</a>: a `finalize()` transaction does not abort if it is sent by the owner, and after wait_time time units have elapsed after a successful `withdraw()` that has not been cancelled nor finalized

- **finalize-before-deadline-revert**: a `finalize()` transaction called immediately after a successful `withdraw()` aborts if sent before wait_time units have elapsed since the `withdraw()`

- **finalize-or-cancel-twice-revert**: a `finalize()` or `cancel()` transaction aborts if performed immediately after another `finalize()` or `cancel()`

- **state-update**: the contract implements a state machine with transitions: s -> s upon a receive (for any s), IDLE -> REQ upon a withdraw, REQ -> IDLE upon a finalize or a cancel.

- <a name="withdraw-finalize-not-revert">**withdraw-finalize-not-revert**</a>: a `finalize()` transaction called immediately after a successful `withdraw()` does not abort if sent after wait_time units have elapsed

- **withdraw-withdraw-revert**: a transaction `withdraw()` aborts if performed immediately after another `withdraw()`
