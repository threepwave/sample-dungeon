/* Build script - Runs a set of hardhat commands against your local vm (TOOD: figure out how to query actual blockchai) */
const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {
    const Dungeons = await ethers.getContractFactory("Dungeons");
    const dungeon = await Dungeons.deploy();
    await dungeon.deployed();
    
    const tokenId = 1
    console.log(`Seed: ${await dungeon.getSeed(tokenId)}`)
    console.log(`Size: ${await dungeon.getSize(tokenId)}`)
    console.log(`Layout: ${await dungeon.getLayout(tokenId)}`)
    console.log(`Entities: ${await dungeon.getEntities(tokenId)}`)

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
