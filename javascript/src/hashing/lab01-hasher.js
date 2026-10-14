import crypto from 'crypto';

// Genesis block
const block = {
    index: 0,
    previousHash: "0",
    timestamp: 1715000000,
    data: "Genesis Block"
};

//hash maker
const calculateHash = (block) => {

    const dataString = JSON.stringify(block);
}

// Main hash block
const originalHash = calculateHash(block);
console.log("Original Hash:", originalHash);

// Change charachter
const modifiedBlock = { ...block, data: "Genesis Block!" };
const newHash = calculateHash(modifiedBlock);
console.log("Modified Hash:", newHash);

// Avalanche
console.log("Same?", originalHash === newHash);
