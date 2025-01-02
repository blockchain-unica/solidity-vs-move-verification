# Bank

## Specification
The Bank contract stores assets (native crypto-currency) deposited by users, and pays them out when required.
To keep track of the amount of assets available for each user, the contract uses a key-value map that associates each user with its credit.

The contract has the following methods:
- `deposit`, which allows anyone to deposit assets. When a deposit is made, the corresponding amount is added to the credit of the transaction sender. 
- `withdraw`, which allows the sender to receive any desired amount of assets deposited in their account. The contract checks that the user has sufficient credit and then transfers the specified amount to the sender. 

## Properties

- **deposit-revert**: a transaction `deposit(amount)` aborts if the amount is higher than the T balance of the transaction sender.  

- **deposit-not-revert**: (up-to overflows) a transaction `deposit(amount)` does not abort if amount is less or equal to the T balance of the transaction sender.

- **deposit-assets-transfer**: (if sender is not the contract) after a successful `deposit(amount)`, exactly amount units of T pass from the control of the sender to that of the contract.

- **deposit-assets-transfer-others**: after a successful `deposit(amount)`, the assets controlled by any user but the sender are preserved.

- **deposit-assets-credit**: after a successful `deposit(amount)`, the users' credit is increased by exactly amount units of T.

- **deposit-assets-credit-others**: after a successful `deposit(amount)`, the credits of any user but the sender are preserved.

- **deposit-additivity**: two (successful) `deposit` of n1 and n2 units of T (performed by the same sender) are equivalent to a single `deposit` of n1+n2 units of T.

- **assets-dec-onlyif-deposit**: if the assets of a user A are decreased after a transaction (of the Bank contract), then that transaction must be a `deposit` where A is the sender.

- **assets-inc-onlyif-withdraw**: if the assets of a user A are increased after a transaction (of the Bank contract), then that transaction must be a `withdraw` where A is the sender.

- **credit-inc-onlyif-deposit**: if the credit of a user A is increased after a transaction (of the Bank contract), then that transaction must be a `deposit` where A is the sender.

- **credit-dec-onlyif-withdraw**: if the credit of a user A is decreased after a transaction (of the Bank contract), then that transaction must be a `withdraw` where A is the sender.

- **withdraw-revert**: a transaction `withdraw(amount)` aborts if amount is more than the credit of the transaction sender.

- **withdraw-not-revert**: a transaction `withdraw(amount)` does not abort if amount is less or equal to the credit of the transaction sender.

- **withdraw-assets-transfer**: after a successful `withdraw(amount)`, exactly amount units of T pass from the control of the contract to that of the sender.

- **withdraw-assets-transfer-others**: after a successful `withdraw(amount)`, the assets controlled by any user but the sender are preserved.

- **withdraw-assets-credit**: after a successful `withdraw(amount)`, the users' credit is decreased by exactly amount units of T.

- **withdraw-assets-credit-others**: after a successful `withdraw(amount)`, the credits of any user but the sender are preserved.