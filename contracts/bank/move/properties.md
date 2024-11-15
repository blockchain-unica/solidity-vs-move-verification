# Comparison with Certora ethereum properties

WARNING! Work in Progress, things will change (for the better hopefullly :))

1. deposit-contract-balance: after a successful deposit(), the ETH balance of the contract is increased by msg.value.
* contract in move does not have an implicit balance, differently from ethereum 
--> not verifiable 

2. deposit-not-revert: a deposit call does not revert if msg.value is less or equal to the ETH balance of msg.sender.
* possible abort in move on sui due to overflow 
* not possible to verify properties: something does not happens in move prover

3. deposit-revert-if-low-eth: a deposit call reverts if msg.value is greater than the ETH balance of msg.sender
* my implementation / prover issues: prover says that the condition as written 
does not happens (but abort is possible, see test test_bank_deposit_too_much in tests directory)

4. deposit-user-balance: after a successful deposit(), the balance entry of msg.sender is increased by msg.value.
* seems ok in both cases (there exists and there not exists an account in balance)

5. user-balance-dec-onlyif-withdraw: the only way to decrease the balance entry of a user a is by calling withdraw with msg.sender = a.
* working on how to express this property, possibly not representable?

6. user-balance-inc-onlyif-deposit: the only way to increase the balance entry of a user a is by calling deposit with msg.sender = a.
* define properties on function like in Certora does not seem possible 
 for now in Aptos Prover (i.e. those with "method f") 

7. withdraw-contract-balance: after a successful withdraw(amount), the ETH balance the contract is decreased by amount.
* Move on aptos contracts does not have a balance like in ethereum 

8. withdraw-not-revert: a withdraw (amount) call does not revert if amount is bigger than zero and less or equal to the balance entry of msg.sender.
* In move on Aptos transaction may fail in case of overflow, so for example
msg.value < balance entry (client) && client balance == MAX_64 fails

9. withdraw-revert: a withdraw(amount) call reverts if amount is zero or greater than the balance entry of msg.sender.
* my implementation / prover issues: prover says that the condition as written 
can't happen

10. withdraw-sender-rcv: after a successful withdraw(amount), the ETH balance of the transaction sender is increased by amount ETH.
* my implementation / prover issues: prover says that the condition as written 
can't happen

11. withdraw-sender-rcv-EOA: after a successful withdraw(amount) originated by an EOA, the ETH balance of the transaction sender is increased by amount ETH.
* there is no difference between accounts like in ethereum, not representable?

12. withdraw-user-balance: after a successful withdraw(amount), the balance entry of msg.sender is decreased by amount.
* my implementation / prover issues: prover says that the condition as written 
can't happen
