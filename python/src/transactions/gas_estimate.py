import os
from dotenv import load_dotenv
from web3 import Web3


load_dotenv(dotenv_path="../.env")
RPC_URL = os.getenv("RPC_URL")
FROM_ADDRESS = os.getenv("FROM_ADDRESS")
TO_ADDRESS = os.getenv("TO_ADDRESS")

# Connect to RPC (same endpoint used in the decoder)
# RPC_URL = "https://ethereum-sepolia-rpc.publicnode.com"
w3 = Web3(Web3.HTTPProvider(RPC_URL))

# Check network connection
if not w3.is_connected():
    print("Not connected!")
    exit()

print("Connected to Sepolia.\n")

# Enter sender and recipient addresses here
# FROM_ADDRESS = "0x..."  # Your Account 1 address
# TO_ADDRESS = "0x..."    # Your Account 2 address

try:
    # Estimate gas for a simple ETH transfer
    gas_estimate = w3.eth.estimate_gas({
        'from': FROM_ADDRESS,
        'to': TO_ADDRESS,
        'value': w3.to_wei(0.001, 'ether')
    })

    print("Gas Estimate:")
   
    print(f"Gas Estimate: {gas_estimate}")
    print(f"Expected (standard): 21000")

    # Calculate the deviation percentage
    error_percent = abs(gas_estimate - 21000) / 21000 * 100
    print(f"Deviation: {error_percent:.2f}%")
    

    if error_percent < 10:
        print("Estimate is within the allowed range (less than 10% deviation).")
    else:
        print("Deviation is more than 10%.")

except Exception as e:
    print(f"Error estimating gas: {e}")