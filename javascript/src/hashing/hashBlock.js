
import crypto from "crypto";

const GenesisBlock ={
    index: 0,
    previousHash: "0",
    timestamp: 1715000000,
    data: "Genesis Block"

};

const tamperedBlock ={
    index: 0,
    previousHash: "0",
    timestamp: 1715000000,
    data: "Genesis Block!"

};

const calculateHash =(block) =>{
//return block.index + block.previousHash + block.timestamp + block.data;

 const blockString= JSON.stringify(block);
 return crypto
 .createHash('sha256')
 .update(blockString)
 .digest('hex')
};

console.log("GenesisBlock: 0x" + calculateHash(GenesisBlock));
console.log("tamperedBlock: 0x" + calculateHash(tamperedBlock));
