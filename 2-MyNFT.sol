// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 导入OpenZeppelin的ERC721标准实现和安全工具
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

/**
 * @title MyNFT
 * @dev 一个简单的NFT合约，基于ERC721标准，支持铸造NFT并关联IPFS元数据
 */
contract MyNFT is ERC721, ERC721URIStorage, Ownable {
    // 记录下一个NFT的ID
    uint256 private _nextTokenId;

    /**
     * @dev 构造函数，初始化NFT名称和符号
     * @param name_ NFT名称
     * @param symbol_ NFT符号
     */
    constructor(
        string memory name_,
        string memory symbol_
    ) ERC721(name_, symbol_) Ownable(msg.sender) {
        _nextTokenId = 1; // 从1开始编号，0通常保留
    }

    /**
     * @dev 铸造新的NFT
     * @param recipient 接收NFT的地址
     * @param tokenURI IPFS上的元数据JSON链接
     * @return 新铸造NFT的ID
     */
    function mintNFT(address recipient, string memory tokenURI) 
        public 
        onlyOwner 
        returns (uint256) 
    {
        uint256 tokenId = _nextTokenId++;
        
        // 铸造NFT给接收者
        _safeMint(recipient, tokenId);
        
        // 设置NFT的元数据链接
        _setTokenURI(tokenId, tokenURI);
        
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
