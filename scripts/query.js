/* Script to query the contract and parse the output */

async function main() {
    /* Connect to rinkeby and grab dungeon data */
    // Contract ABI - Copy/pasta'd from the bottom of the 'code' tab https://rinkeby.etherscan.io/address/0xB14Cf44b866c2dd36aFfD9577962CA8755e973F8#code
    const abi = [{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"approved","type":"address"},{"indexed":true,"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"operator","type":"address"},{"indexed":false,"internalType":"bool","name":"approved","type":"bool"}],"name":"ApprovalForAll","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"output","type":"string"}],"name":"Debug","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":true,"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"Transfer","type":"event"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"approve","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"claim","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"getApproved","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"getEntities","outputs":[{"internalType":"uint8[]","name":"","type":"uint8[]"},{"internalType":"uint8[]","name":"","type":"uint8[]"},{"internalType":"uint8[]","name":"","type":"uint8[]"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"getLayout","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"getSeed","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"getSize","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"operator","type":"address"}],"name":"isApprovedForAll","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"ownerOf","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"safeTransferFrom","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"},{"internalType":"bytes","name":"_data","type":"bytes"}],"name":"safeTransferFrom","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"operator","type":"address"},{"internalType":"bool","name":"approved","type":"bool"}],"name":"setApprovalForAll","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes4","name":"interfaceId","type":"bytes4"}],"name":"supportsInterface","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"index","type":"uint256"}],"name":"tokenByIndex","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"uint256","name":"index","type":"uint256"}],"name":"tokenOfOwnerByIndex","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"tokenURI","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"transferFrom","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"}]
    
    // Connect to the network
    let provider = new ethers.providers.EtherscanProvider("rinkeby", process.env.etherscan_key)
    
    // The contract address (to match the above abi))
    let contractAddress = '0xB14Cf44b866c2dd36aFfD9577962CA8755e973F8'
    
    // We connect to the Contract using a Provider, so we will only have read-only access to the Contract
    let contract = new ethers.Contract(contractAddress, abi, provider)

    const tokenId = 1; // The ID of the NFT we want to grab

    const size = await contract.functions.getSize(tokenId) // Call the 'getSize' function on the contract
    const layout = await contract.functions.getLayout(tokenId) // Call the 'getSize' function on the contract
    const entities = await contract.functions.getEntities(tokenId) // Call the 'getSize' function on the contract

    console.log('--- RAW OUTPUT ---')
    console.log(`Size: ${size}`)
    console.log(`Layout: ${layout}`)
    console.log(`Entities: ${entities}`)

    console.log('--- PROCESSED ---')
    /* Parse Layout into binary */
    layoutInt = BigInt(layout)           // Process uint256 -> javascript readable int
    const bits = layoutInt.toString(2);  // Convert BigInt to binary

    /* Store dungeon in 2D array */
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

    /* Parse entities into array */
    let tmp = entities.toString().split(',')
    let numEntities = tmp.length / 3   // Entities always come in 3: x, y, entityType
    let entityList = []

    for(let i = 0; i < numEntities; i++) {
        let entity = {
            x: parseInt(tmp[i]),
            y: parseInt(tmp[i+2]),
            entityType: parseInt(tmp[i+4])
        }

        entityList.push(entity)

        // Update dungeon with our entity
        if(entity.entityType == 1) {
            // Place a door
            dungeon[entity.y][entity.x] = 'D'
        } else if(entity.entityType == 0) {
            // Place a point of interest
            dungeon[entity.y][entity.x] = 'p'
        }
    }

    console.log(toString(dungeon))
    console.log(entityList)
}

function toString(dungeon) {
    // Returns a string representing the dungeon
    let rowString = ""

    for(let y = 0; y < dungeon.length; y++) {
        for(let x = 0; x < dungeon.length; x++) {
            const tile = dungeon[y][x]
            rowString += `${tile} `
        }
        rowString += '\n'
    }
    return(rowString)
}
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
  