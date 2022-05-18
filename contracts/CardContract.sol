// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

interface MetadataHandlerManager {
    function getTokenURI(string memory character, uint256 numberCard, string memory weapon, uint8 speed,  uint8 attack, uint8 defence) external view returns (string memory);
}

contract CardContract is ERC721, Ownable{

    struct Attr {
        string character;
        uint256 numberCard;
        string weapon;
        uint8 speed;
        uint8 attack;
        uint8 defence; 
    }

    constructor() ERC721("NFT-Selise", "xBDT") {}

    fallback() external payable {}

    receive() external payable {}

    using Counters for Counters.Counter;

    //string public constant name = "Turtless";
    //string public constant symbol = "TMNT";

    Counters.Counter private _tokenCounter;

    mapping(uint256 => Attr) public attributes;

    function update(uint256 id, string memory character, string memory weapon, uint8 speed, uint8 attack, uint8 defence) public {       

        attributes[id].character = character;
        attributes[id].weapon = weapon;
        attributes[id].speed = speed; 
        attributes[id].attack = attack;
        attributes[id].defence = defence;
        
    }

    MetadataHandlerManager metadaHandler;

    function setAddresses(address meta) external onlyOwner {
        //migrator      = mig;
        metadaHandler = MetadataHandlerManager(meta);
    }

    function tokenURI(uint256 id) public override view returns(string memory) {
        Attr memory attr = attributes[id];
        return metadaHandler.getTokenURI(attr.character, attr.numberCard, attr.weapon, attr.speed, attr.attack, attr.defence);
    }

    //TIPI DI CARTE
    //(mappa rarit├á/numero della carta??)
    mapping(uint256 => uint256) public UNCOMMON;
    mapping(uint256 => uint256) public COMMON;
    mapping(uint256 => uint256) public RARE;
    mapping(uint256 => uint256) public ULTRA_RARE;
    mapping(uint256 => uint256) public MYTHIC;

    function mergeCard() public onlyOwner returns(uint256){

        uint256 tokenIdMerge;


        return tokenIdMerge;
    }

    function mint(
        string memory _character, 
        string memory _weapon,
        uint8 _numberCard, 
        uint8 _speed, 
        uint8 _attack, 
        uint8 _defence) 
    public {
        
        uint256 newTokenId = _tokenCounter.current();

        _tokenCounter.increment();

        //ERC1155
        //_mint(msg.sender, newTokenId, mintAmount, mintData);

        _safeMint(msg.sender, newTokenId);

        attributes[newTokenId] = Attr(_character, _numberCard, _weapon, _speed, _attack, _defence);
        
    }

    function uint2str(uint _i) internal pure returns (string memory _uintSsString) {

        if(_i == 0){
            return "0";
        }
        uint j = _i;
        uint len;
        while(j != 0){
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while(_i != 0){
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;

        }
        return string(bstr);

    }

   
    //BURN
    //TRANSFER
    //da vedere come si fa per il 721

    //function safeTransferFrom(address from, address to, uint256 tokenId) external payable;
}