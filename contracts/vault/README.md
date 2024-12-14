# Vault

## Specification

Vaults are a security mechanism to prevent cryptocurrency from being immediately withdrawn by an adversary who has stolen the owner's private key.

To create the vault, the owner specifies: 
- a recovery key, which can be used to cancel a withdraw request;
- a wait time, which has to elapse between a withdraw request and the actual finalization of the cryptocurrency transfer.

Once the vault contract have been created, it supports the following actions:
- **receive**, which allows anyone to deposit native cryptocurrency in the contract;
- **withdraw**, which allows the owner to issue a withdraw request to the vault, specifying the receiver and the desired amount;
- **finalize**, which allows the owner to finalize the withdraw after the wait time has passed since the request; 
- **cancel**, which allows the owner of the recovery key to cancel the withdraw request during the wait time.

## Properties
