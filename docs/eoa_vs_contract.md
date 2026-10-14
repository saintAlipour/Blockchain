\# EOA vs Contract Account



\## EOA



EOA stands for Externally Owned Account. Simply put, it's an account

controlled by a private key — meaning a person (or a program holding

that key) can sign transactions with it.



Things to know:



\- Creating one is free — you just generate a key pair.

\- It's controlled by a private key.

\- It can send transactions and pay for gas on its own.

\- There's no code attached to it.

\- Example: your MetaMask wallet address.



\## Contract Account



A Contract Account is an account that has code deployed on it. It's not

controlled by a private key. Its behavior is defined entirely by the

code living inside it.



\- It's created by deploying a smart contract (costs gas).

\- It has no private key, so it can't do anything on its own.

\- It only acts when an EOA (or another contract) sends it a transaction.

\- It holds code (functions) and storage (data).

\- Example: an ERC-20 token contract or a DeFi protocol.



\## Key differences



| Feature            | EOA              | Contract Account       |

|--------------------|------------------|------------------------|

| Controlled by      | Private key      | Code                   |

| Can send a tx?     | Yes              | No — must be triggered |

| Has code?          | No               | Yes                    |

| Cost to create     | Free             | Costs gas (to deploy)  |

| Example            | MetaMask wallet  | ERC-20 token contract  |



\## Why this matters for AZARS



On the AZARS ledger, regular users sign their trades with EOAs. The

business logic — settlement rules, audit trails, and so on — lives in

Contract Accounts that run on-chain.



This split is what makes the ledger both secure (only the key owner can

act) and programmable (contracts can enforce rules).

