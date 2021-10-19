# sample-dungeon
Sample dungeons based on Dungeon Maps project.

# Working with the contract (on Rinkeby testnet)

Contract Address: https://rinkeby.etherscan.io/address/0xB14Cf44b866c2dd36aFfD9577962CA8755e973F8#readContract

**You can query the contract and pull down sample data by running `npm run query` (which executes `./scripts/query.js`)**

## Input
TokenId can be between 1 and 4.

getLayout(tokenId) - Returns a uint256 w/ each digit representing a tile in a square array (left to right)

## Expected Output
Each tokenId's expected output (once you parse the array) is listed below
```
    1: 0x000000000000000ffffffffe0ff03fc0ffbfc0ff03fc0ff03fffffffffffffff (14x14)
        1 1 1 1 1 1 1 1 1 1 1 1 1 1 
        1 1 1 1 1 1 1 1 1 1 1 1 1 1 
        1 1 1 1 1 1 1 1 1 1 1 1 1 1 
        1 1 1 1 1 1 1 1 1 1 1 1 1 1 
        1 1 1 1 1 1 0 0 0 0 0 0 1 1 
        1 1 1 1 1 1 0 0 0 0 0 0 1 1 
        1 1 1 1 1 1 0 0 0 0 0 0 1 1 
        1 1 1 1 1 1 0 0 0 0 0 0 1 1 
        1 1 1 1 1 1 0 1 1 1 1 1 1 1 
        1 1 0 0 0 0 0 0 1 1 1 1 1 1 
        1 1 0 0 0 0 0 0 1 1 1 1 1 1 
        1 1 0 0 0 0 0 1 1 1 1 1 1 1 
        1 1 1 1 1 1 1 1 1 1 1 1 1 1 
        1 1 1 1 1 1 1 1 1 1 1 1 1 1

    2: 0x0000000000000000000001ffffffe3ff1ff8c3c61f70ff2ff97fcffe7ff3ffff (13x13)
        1 1 1 1 1 1 1 1 1 1 1 1 1 
        1 1 1 1 1 0 0 1 1 1 1 1 1 
        1 1 1 1 1 0 0 1 1 1 1 1 1 
        1 1 1 1 1 0 0 1 1 1 1 1 1 
        1 1 1 0 1 0 0 1 1 1 1 1 1 
        1 1 1 0 1 0 0 1 1 1 1 1 1 
        1 1 0 0 0 0 1 1 1 0 1 1 1 
        1 1 0 0 0 0 1 1 0 0 0 1 1 
        1 1 0 0 0 0 1 1 0 0 0 1 1 
        1 1 1 1 1 1 1 1 0 0 0 1 1 
        1 1 1 1 1 1 1 1 0 0 0 1 1 
        1 1 1 1 1 1 1 1 1 1 1 1 1 
        1 1 1 1 1 1 1 1 1 1 1 1 1

    3: 0x000000000000000000000000000000000000000fffffc7f03c0f03f7ffffffff (10x10)
        1 1 1 1 1 1 1 1 1 1 
        1 1 1 1 1 1 1 1 1 1 
        1 1 1 1 1 1 1 1 1 1 
        1 1 1 1 1 0 1 1 1 1 
        1 1 0 0 0 0 0 0 1 1 
        1 1 0 0 0 0 0 0 1 1 
        1 1 0 0 0 0 0 0 1 1 
        1 1 1 1 1 0 0 0 1 1 
        1 1 1 1 1 1 1 1 1 1 
        1 1 1 1 1 1 1 1 1 1

    4: 0x00000001fffffffe007c00f801fb03f607e80fd03fe07fc0ffffffffffffffff (15x15)
        1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
        1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
        1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
        1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
        1 1 1 1 0 0 0 0 0 0 1 1 1 1 1 
        1 1 1 1 0 0 0 0 0 0 1 1 1 1 1 
        1 1 1 1 0 0 0 0 0 0 1 0 1 1 1 
        1 1 1 0 0 0 0 0 0 0 1 0 1 1 1 
        1 1 1 0 0 0 0 0 0 1 1 0 1 1 1 
        1 1 1 0 0 0 0 0 0 1 1 0 1 1 1 
        1 1 1 0 0 0 0 0 0 0 0 0 0 1 1 
        1 1 1 0 0 0 0 0 0 0 0 0 0 1 1 
        1 1 1 0 0 0 0 0 0 0 0 0 0 1 1 
        1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
        1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
```

## How to parse / use

Note: You can find full parsing sample code (Javascript) in `/scripts/query.js`

getLayout() returns a uint256 which is a 256-bit hexadecimal that is unsigned (always positive).

Each bit (from left to right) represents a dungeon tile.

To parse, you would do something like this (Javascript), depending on your language:
``` 
    layoutInt = BigInt(layout)           // Process uint256 -> javascript readable int
    const bits = layoutInt.toString(2);  // Convert BigInt to binary

    let dungeon = [];   // Array to store our dungeon coordinates

    let counter = 0;
    for(let y = 0; y < size; y++) {
        let row = []
        for(let x = 0; x < size; x++) {
            const bit = bits[counter];
            row.push(bit)
            counter++
        }
        dungeon.push(row)
    }
```

This would give you a 2D array with each row representing the `y` value and each columen representing the `x` value.

Walls would be represented by 1's and walkable tiles by 0. (Note: at some point, I'll probably flip these to save memory)


# Building/Deploying the contract

## Installation
1. Install dependencies: `npm install`

## Usage
Query local contract's `getSeed()` function once (and console.log the output) - `npm run build`.

Watch for changes to the contract and re-compile/deploy if we make changes - `npm run dev` (Note: changes to build.js will not trigger a re-compile/deploy)


## How does it work?
We've defined a very simple ERC-721 contract in `/contracts/dungeons.sol` (note: contracts always have to be in this folder w/ hardhat) and added a global variable called `seed`. We also added a function called `getSeed()` to get the value of said variable.

We tell hardhat to compile and deploy said contract on our local machine via `build.js`. We then run a query against it to read the function `getSeed()`.