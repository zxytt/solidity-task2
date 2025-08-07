// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyNFT is ERC721, ERC721URIStorage, Ownable {
    uint256 private _tokenIdCounter;

    // 构造函数：设置NFT名称和符号
    constructor(
        string memory name,
        string memory symbol,
        address initialOwner
    ) ERC721(name, symbol) Ownable(initialOwner) {
        _tokenIdCounter = 0;
    }

    // 铸造NFT函数，仅合约所有者可调用
    function mintNFT(address recipient, string memory _tokenURI) public onlyOwner returns (uint256) {
        uint256 tokenId = _tokenIdCounter;
        _safeMint(recipient, tokenId);
        _setTokenURI(tokenId, _tokenURI);
        _tokenIdCounter++;
        return tokenId;
    }

    // 以下函数是为了支持ERC721URIStorage而必须重写的函数
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
    