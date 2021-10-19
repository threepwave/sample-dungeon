/* Boilerplate for an ERC-721 Contract */

/* DEBUG - Remove for prod */
import "hardhat/console.sol";

/// @title The Dungeons ERC-721 token

/*****************************************************
0000000                                        0000000
0001100   Dungeons (for Adventurers)           0001100
0001100     simple procedural map generator    0001100
0003300                                        0003300
*****************************************************/

pragma solidity ^0.8.0;

/* ERC-721 Boilerplate */
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/* Dungeons contract code starts here */
contract Dungeons is ERC721Enumerable, ReentrancyGuard, Ownable {

    uint256[] private seeds = [
        1329840184908088912341,
        9812094389018490141,
        88493919011102393,
        98310284901289048901820948190
    ];    // We'll bitshift this seed to get pseudorandom numbers

    uint8[] private size = [
        14,
        13,
        10,
        15
    ];

    uint256[] private layout = [
        100433627763354881540869006809100674666560101711422219616255,
        748288835873980503392335818341100997436436569653247,
        1267650335484886137747831521279,
        53919893321758953321466092165956368018174615290879040481415776960511  
    ];

    struct Entities {
        EntityData[] entities;
    }

    struct EntityData {
        uint8 x;
        uint8 y;
        uint8 entityType; // 0-255
    }

    event Debug(string output);
    
    /**
    * @dev Returns the entire structure of a dungeon (size, layout, points)
    */
    function tokenURI(uint256 tokenId) override(ERC721) public view returns (string memory) {
        /* Returns 
        {
            size: 8,
            layout: 0x1934104014214,
            entities: [{
                x: 4,
                y: 13,
                type: 0
            },{
                x: 2,
                y: 3,
                type: 1
            }]
        } */
        
        return('test'); // TODO: Replace w/ proper tokenURI
    }

    /**
    * @dev Allow a user to claim this token
    */
    function claim(uint256 tokenId) public nonReentrant {
        require(tokenId > 0 && tokenId < 5, "Token ID must be between 1->4");
        _safeMint(_msgSender(), tokenId);
    }
    
    /** 
    * @dev Returns a dungeon (currently a single uint256)
    */
    function getSeed(uint256 tokenId) public view returns (uint256) {
        require(tokenId > 0 && tokenId < 5, "Token ID must be between 1->4");
        return seeds[tokenId-1];
    }

    /** 
    * @dev Returns the size of a dungeon e.g. '8' for and 8x8 dungeon (currently a single uint8)
    */
    function getSize(uint256 tokenId) public view returns (uint8) {
        require(tokenId > 0 && tokenId < 5, "Token ID must be between 1->4");
        return size[tokenId-1];
    }

    /** 
    * @dev Returns the size of a dungeon e.g. '8' for and 8x8 dungeon (currently a single uint8)
    */
    function getLayout(uint256 tokenId) public view returns (bytes32) {
        require(tokenId > 0 && tokenId < 5, "Token ID must be between 1->4");
        return bytes32(layout[tokenId-1]);
    }

    /** 
    * @dev Returns each entity in a dungeon. There can be at most 32 entities and each has an (x, y) coordinate and a type (0-254)
    */
    function getEntities(uint256 tokenId) public pure returns (uint8[] memory, uint8[] memory, uint8[] memory) {
    // function getEntities(uint256 tokenId) public view returns (string memory) {
        require(tokenId > 0 && tokenId < 5, "Token ID must be between 1->4");
        Entities[] memory entities = new Entities[](4);
        entities = setupEntities();

        /* Traverse the array and grab the one they requested */
        uint256 length = 2;
        uint8[] memory x = new uint8[](length);
        uint8[] memory y = new uint8[](length);
        uint8[] memory types = new uint8[](length);

        for(uint8 i = 0; i < length; i++) {
            EntityData[] memory currentEntity = entities[tokenId-1].entities;
            x[i] = currentEntity[i].x;
            y[i] = currentEntity[i].y;
            types[i] = currentEntity[i].entityType;
        }
        return (x, y, types);
    }

    function setupEntities() internal pure returns (Entities[] memory) {
 /* Hardcode individual EntityData per map (solidity won't do this at global scope level so needs to be here)*/
        // Create the initial array of entities (1 array per map)
        EntityData[] memory entityData1 = new EntityData[](2);
        EntityData[] memory entityData2 = new EntityData[](2);
        EntityData[] memory entityData3 = new EntityData[](2);
        EntityData[] memory entityData4 = new EntityData[](2);

        // Populate our array for each map
        entityData1[0] = EntityData(7, 5, 1);
        entityData1[1] = EntityData(6, 8, 0);
        entityData2[0] = EntityData(3, 5, 0);
        entityData2[1] = EntityData(6, 1, 1);
        entityData3[0] = EntityData(5, 1, 1);
        entityData3[1] = EntityData(3, 2, 0); 
        entityData4[0] = EntityData(5, 1, 1);
        entityData4[1] = EntityData(3, 2, 0); 

        // Create an array to house map0's entity struct
        Entities[] memory entities = new Entities[](4);
        entities[0] = Entities(entityData1);
        entities[1] = Entities(entityData2);
        entities[2] = Entities(entityData3);
        entities[3] = Entities(entityData4);

        return(entities);
    }

    

    constructor() ERC721("Dungeons", "DUNGEONS") Ownable() { 
    }

    function toString(uint256 value) internal pure returns (string memory) {
    // Inspired by OraclizeAPI's implementation - MIT license
    // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}


/// [MIT License]
/// @title Base64
/// @notice Provides a function for encoding some bytes in base64
/// @author Brecht Devos <brecht@loopring.org>
library Base64 {
    bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);

        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}