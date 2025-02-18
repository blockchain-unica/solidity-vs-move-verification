# Bank

The Bank contract stores assets (native crypto-currency) deposited by users, and pays them out when required.
The contract state consists of:
- **credits**, a key-value map that associates each user with the amount of assets available for that user;
- **owner**, the address that deploys the contract;
- **opLimit**, a limit set during contract deployment that restricts the maximum amount that can be deposited or withdrawn in a single transaction. This limit applies to all users except the owner.

The contract has the following methods:
- `deposit`, which allows anyone to deposit assets. When a deposit is made, the corresponding amount is added to the credit of the transaction sender. 
- `withdraw`, which allows the sender to receive any desired amount of assets deposited in their account. The contract checks that the user has sufficient credit and then transfers the specified amount to the sender. 

## Implementations

- **Solidity**: [contract](certora/Bank.sol) | [properties](certora/)
- **Move**: [contract](move/sources/bank.move) | [properties](move/specs)
  
## Properties

- <a name="deposit-revert">**deposit-revert**</a>: a transaction `deposit(amount)` aborts if the amount is higher than the T balance of the transaction sender.

- <a name="deposit-not-revert">**deposit-not-revert**</a>: (up-to overflows) a transaction `deposit(amount)` does not abort if amount is less or equal to the T balance of the transaction sender.

- <a name="deposit-assets-transfer">**deposit-assets-transfer**</a>: (if sender is not the contract) after a successful `deposit(amount)`, exactly amount units of T pass from the control of the sender to that of the contract.

- **deposit-assets-transfer-others**: after a successful `deposit(amount)`, the assets controlled by any user but the sender are preserved.

- <a name="deposit-assets-credit">**deposit-assets-credit**</a>: after a successful `deposit(amount)`, the users' credit is increased by exactly amount units of T.

- **deposit-assets-credit-others**: after a successful `deposit(amount)`, the credits of any user but the sender are preserved.

- <a name="deposit-additivity">**deposit-additivity**</a>: two (successful) `deposit` of n1 and n2 units of T (performed by the same sender) are equivalent to a single `deposit` of n1+n2 units of T.

- <a name="assets-dec-onlyif-deposit">**assets-dec-onlyif-deposit**</a>: if the assets of a user A are decreased after a transaction (of the Bank contract), then that transaction must be a `deposit` where A is the sender.

- **assets-inc-onlyif-withdraw**: if the assets of a user A are increased after a transaction (of the Bank contract), then that transaction must be a `withdraw` where A is the sender.

- **credit-inc-onlyif-deposit**: if the credit of a user A is increased after a transaction (of the Bank contract), then that transaction must be a `deposit` where A is the sender.

- **credit-dec-onlyif-withdraw**: if the credit of a user A is decreased after a transaction (of the Bank contract), then that transaction must be a `withdraw` where A is the sender.

- **withdraw-revert**: a transaction `withdraw(amount)` aborts if amount is more than the credit of the transaction sender.

- **withdraw-not-revert**: a transaction `withdraw(amount)` does not abort if amount is less or equal to the credit of the transaction sender.

- <a name="withdraw-assets-transfer">**withdraw-assets-transfer**</a>: after a successful `withdraw(amount)`, exactly amount units of T pass from the control of the contract to that of the sender.

- <a name="withdraw-assets-transfer-eoa">**withdraw-assets-transfer-eoa**</a>: after a successful `withdraw(amount)` performed by an EOA, exactly amount units of T pass from the control of the contract to that of the sender.

- **withdraw-assets-transfer-others**: after a successful `withdraw(amount)`, the assets controlled by any user but the sender are preserved.

- **withdraw-assets-credit**: after a successful `withdraw(amount)`, the users' credit is decreased by exactly amount units of T.

- **withdraw-assets-credit-others**: after a successful `withdraw(amount)`, the credits of any user but the sender are preserved.

- **withdraw-additivity**: two (successful) `withdraw` of n1 and n2 units of T (performed by the same sender) are equivalent to a single `withdraw` of n1+n2 units of T.

- <a name="credits-leq-balance">**credits-leq-balance**</a>: the assets controlled by the contract are (at least) equal to the sum of all the credits 

- <a name="no-frozen-credits">**no-frozen-credits**</a>: if the credits are strictly positive, it is possible to reduce them

- <a name="no-frozen-assets">**no-frozen-assets**</a>: if the contract controls some assets, then someone can transfer them from the contract to some user

- <a name="exists-at-least-one-credit-change">**exists-at-least-one-credit-change**</a>: after a successful transaction, the credits of at least one account have changed

- <a name="exists-unique-asset-change">**exists-unique-asset-change**</a>: after a successful transaction, the assets of exactly one account (except the contract’s) have changed

- **exists-unique-credit-change**: after a successful transaction, the credits of exactly one account have changed
