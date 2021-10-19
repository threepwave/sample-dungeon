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

    event Debug(string output);
    
    function tokenURI(uint256 tokenId) override(ERC721) public view returns (string memory) {
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