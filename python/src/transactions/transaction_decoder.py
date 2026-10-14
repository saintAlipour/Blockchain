import os
from dotenv import load_dotenv

from web3 import Web3

load_dotenv(dotenv_path="../.env")
RPC_URL = os.getenv("RPC_URL")
TX_HASH = os.getenv("TX_HASH")

#Sepolia testnet RPC endpoint
#RPC_URL = "https://ethereum-sepolia-rpc.publicnode.com"
w3 = Web3(Web3.HTTPProvider(RPC_URL))

#Check network connection
if not w3.is_connected():
    print("Not connected!")
    exit()

print("sepolia connected!.\n")

# Paste the target transaction hash here
TX_HASH = "0xe1515586603d82a69f5df86a1ba7109b5cc1deb1164c959b37f5b32f18e18dce"

try:
    # Fetch transaction data from network
    tx = w3.eth.get_transaction(TX_HASH)


    print("Transaction Detail:")


    print(f"Nonce: {tx['nonce']}")  # senders transaction sequence number

    # Legacy transaction include gasPrice
    if 'gasPrice' in tx:
        print(f"Gas Price: {tx['gasPrice']}")

    # تراکنش‌های EIP-1559 (Type 2) این دو فیلد را دارند
    if 'maxFeePerGas' in tx:
        print(f"Max Fee Per Gas: {tx['maxFeePerGas']}")
        print(f"Max Priority Fee: {tx['maxPriorityFeePerGas']}")

    print(f"Gas Limit: {tx['gas']}")                 # Max gas allowed
    print(f"Value (wei): {tx['value']}")             # Amount sent , in wei
    print(f"From: {tx['from']}")                     # Sender address

    # to is none for contract-creation transaction
    print(f"To: {tx['to'] if tx['to'] else '(ایجاد قرارداد)'}")

    print(f"Data: {tx['input'].hex() if tx['input'] else '0x'}")  # Raw input data


except Exception as e:
    print(f"error estimating gas: {e}")