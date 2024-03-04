// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

 //Uncomment this line to use console.log
 import "hardhat/console.sol";
 import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
 import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
//* the Contract NFT is for a NFT to be built*//
 contract NFT is ERC721, ReentrancyGuard {
    address public admin;
//  create a struct for the NFT
    struct NFTMetadata{
        uint256 tokenId;
        address owner;
        uint price;
    }

    // Ntf Metadtat is instance of the blockchain start
    NFTMetadata[] public nfts;
    mapping(uint256 => bool) public tokenIdExists;

    event NFTMinted(uint256 indexed tokenID, address indexed owner, uint256 price);
    event NFTListed(uint256 indexed tokenID, uint256 price);
    event NFTSold( uint256 indexed tokenId, address indexed seller, address indexed buyer, uint256 price);
// a constructor for a approval, not atonomous 
    constructor() ERC721("NFT", "NFT1"){
        admin = msg.sender;
    }
// Modidfer for 
    modifier onlyAdmin(){
        require(msg.sender == admin, "Not Admin");
        _;
    }

    function mintNft( address _owner, uint256 _price) external onlyAdmin {
        uint256 tokenId = nfts.length +1;
        _mint(_owner, tokenId);
        nfts.push(NFTMetadata(tokenId, _owner, _price));
        tokenIdExists[tokenId] = true;
        emit NFTMinted(tokenId, _owner, _price);
    }

    function listNFTForSale(uint256 _tokenId, uint256 _price) external {
        require(tokenIdExists[_tokenId], "Token doesn't exist");
        require(ownerOf(_tokenId) == msg.sender, "Not token owner");
        nfts[_tokenId - 1].price = _price;
        emit NFTListed(_tokenId, _price);
        }

 

contract Lock {
    uint public unlockTime;
    address payable public owner;

    event Withdrawal(uint amount, uint when);

    constructor(uint _unlockTime) payable {
        require(
            block.timestamp < _unlockTime,
            "Unlock time should be in the future"
        );

        unlockTime = _unlockTime;
        owner = payable(msg.sender);
    }

    function updateAdmin(address newAdmin) external onlyAdmin {
    require(newAdmin != address(0), "New admin address is the zero address");
    admin = newAdmin;
    }

    function withdraw() public {

        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");

        emit Withdrawal(address(this).balance, block.timestamp);

        owner.transfer(address(this).balance);
    }
       function buyNFT(uint256 _tokenId) external payable nonReentrant{
        require(tokenIdExists[_tokenId], "Token doen't Exist");
        NFTMetadata storage nft = nfts[_tokenId -1];
        require(msg.value >= nft.price, "Insufficient funds");

        address payable seller = payable(nft.owner);
        nft.owner = msg.sender;
        nft.price = 0;
        tokenIdExists[_tokenId] = false;

        seller.transfer(msg.value);
        _transfer(seller, msg.sender, _tokenId);

        nft.owner = msg.sender;
        nft.price = 0;

        emit NFTSold(_tokenId, seller, msg.sender, msg.value);
    }
}


}
