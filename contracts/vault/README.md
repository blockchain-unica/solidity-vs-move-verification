# Vault

## Specification

Vaults are a security mechanism to prevent cryptocurrency from being immediately withdrawn by an adversary who has stolen the owner's private key.

To create the vault, the owner specifies:
- itself as the vault's **owner**; 
- a **recovery key**, which can be used to cancel a withdraw request;
- a **wait time**, which has to elapse between a withdraw request and the actual finalization of the cryptocurrency transfer.

The contract has the following entry points:
- **receive(amount)**, which allows anyone to deposit tokens (native cryptocurrency) into the contract;
- **withdraw(receiver, amount)**, which allows the owner to issue a withdraw request, specifying the receiver and the desired amount;
- **finalize()**, which allows the owner to finalize the pending withdraw after the wait time has passed since the request;
- **cancel()**, which allows the owner of the recovery key to cancel the withdraw request during the wait time.

To this purpose, the vault contract implements a state transition system with states IDLE and REQ, and transitions: 
- IDLE -> IDLE upon a receive action
- IDLE -> REQ upon a withdraw action
- REQ -> REQ upon a receive action
- REQ -> IDLE upon a finalize or a cancel action


## Properties
