// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC721Task is ERC721, ERC721URIStorage, Ownable {
    
    uint256 private _nextTokenId;

    constructor() ERC721("ERC721Task", "E721T") Ownable(msg.sender){}

    function mintNFT(address recipient, string memory uri) 
        onlyOwner
        public  
        returns(uint256)
    {
        uint256 tokenId  = _nextTokenId ++;
        _safeMint(recipient, tokenId);
        _setTokenURI(tokenId, uri);
        return tokenId;
    }
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    
}

// ∫œ‘ºµÿ÷∑: 0xF39127F96fc1B707cb69673394CDc3d7Ffe67105
// tokenURI: https://peach-obedient-termite-330.mypinata.cloud/ipfs/bafkreiaxqvqhaq5dqxkrpm4poyt2rl2uslycvsn2lpw7jqtpropon2w34m