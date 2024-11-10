# Bank

## Specification
The Bank contract stores assets (native crypto-currency) deposited by users, and pays them out when required.
To keep track of the amount of assets available for each user, the contract uses a key-value map that associates each user with its credit.

The contract has the following methods:
- `deposit`, which allows anyone to deposit assets. When a deposit is made, the corresponding amount is added to the credit of the transaction sender. 
- `withdraw`, which allows the sender to receive any desired amount of assets deposited in their account. The contract checks that the user has sufficient credit and then transfers the specified amount to the sender. 

## Properties
- **deposit-contract-balance**: after a successful `deposit()`, the contract balance is increased by `msg.value`.
- **deposit-not-revert**: a `deposit` call does not revert if  `msg.value` is less or equal to the balance of `msg.sender`.
- **deposit-revert-if-low-eth**: a `deposit` call reverts if `msg.value` is greater than the balance of `msg.sender`.
- **deposit-user-balance**: after a successful `deposit()`, the credit of `msg.sender` is increased by `msg.value`.
- **user-balance-dec-onlyif-withdraw**: the only way to decrease the credit of a user `a` is by calling `withdraw` with `msg.sender = a`.
- **user-balance-inc-onlyif-deposit**: the only way to increase the balance entry of a user `a` is by calling `deposit` with `msg.sender = a`.
- **withdraw-contract-balance**: after a successful `withdraw(amount)`, the contract balance is decreased by `amount`.
- **withdraw-not-revert**: a `withdraw(amount)` call does not revert if  `amount` is bigger than zero and less or equal to the credit of `msg.sender`.
- **withdraw-revert**: a `withdraw(amount)` call reverts if `amount` is zero or greater than the credit of `msg.sender`.
- **withdraw-sender-rcv**: after a successful `withdraw(amount)`, the balance of the transaction sender is increased by `amount` ETH.
- **withdraw-user-balance**: after a successful `withdraw(amount)`, the balance entry of `msg.sender` is decreased by `amount`.

## Contract versions
- **v1**: conformant to specification
- **v2**: no `amount <= balances[msg.sender]` check and `balances[msg.sender]` is decremented by `amount - 1` in `withdraw()`
