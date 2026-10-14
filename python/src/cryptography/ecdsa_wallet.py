"""
ECDSA Wallet Module
Generates a key pair, signs a message, and verifies the signature.
The private key is saved to and loaded from a .env file.
"""

import os
from eth_keys import keys

ENV_FILE = ".env"


def generate_key_pair(save_to_env=True):
    """Generate a random ECDSA private/public key pair and the matching address."""
    # 32 random bytes = a valid private key
    private_key = keys.PrivateKey(os.urandom(32))
    public_key = private_key.public_key
    address = public_key.to_checksum_address()

    if save_to_env:
        # Never hardcode the private key in source code — keep it in .env
        with open(ENV_FILE, "w") as f:
            f.write(f"PRIVATE_KEY={private_key.to_hex()}\n")
        print(f"[+] Private key saved to {ENV_FILE}")

    return private_key, public_key, address


def load_private_key(env_file=ENV_FILE):
    """Load the private key from the .env file."""
    if not os.path.exists(env_file):
        raise FileNotFoundError(f"{env_file} not found. Run generate_key_pair() first.")

    with open(env_file, "r") as f:
        for line in f:
            if line.startswith("PRIVATE_KEY="):
                private_key_hex = line.split("=", 1)[1].strip()
                if private_key_hex.startswith("0x"):
                    private_key_hex = private_key_hex[2:]
                return keys.PrivateKey(bytes.fromhex(private_key_hex))

    raise ValueError("PRIVATE_KEY not found in .env file")


def sign_message(private_key, message):
    """Sign a text message with the private key and return the signature."""
    message_bytes = message.encode("utf-8")
    return private_key.sign_msg(message_bytes)


def verify_signature(public_key, message, signature):
    """Check whether a signature matches the given message and public key."""
    message_bytes = message.encode("utf-8")
    return public_key.verify_msg(message_bytes, signature)


def main():
    # 1. Create a new key pair (also saved to .env)
    private_key, public_key, address = generate_key_pair()
    print(f"Address: {address}")

    # 2. Sign a sample message
    message = "Trade: BUY 1.5 BTC @ 92000"
    signature = sign_message(private_key, message)
    print(f"Signed message: {message}")
    print(f"Signature -> r: {signature.r}, s: {signature.s}, v: {signature.v}")

    # 3. Verify with the original message (should be True)
    print("Valid signature check:", verify_signature(public_key, message, signature))

    # 4. Verify with a tampered message (should be False)
    tampered = "Trade: BUY 1.5 BTC @ 92001"
    print("Tampered message check:", verify_signature(public_key, tampered, signature))

    # 5. Confirm the key can be reloaded from .env
    reloaded_key = load_private_key()
    print("Reloaded key matches original:", reloaded_key.to_hex() == private_key.to_hex())


if __name__ == "__main__":
    main()