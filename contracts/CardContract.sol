// SPDX-License-Identifier: MIT

pragma solidity 0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract CardContract is ERC721, Ownable {

    using Counters for Counters.Counter;
    using Base64 for bytes;
    using CardUtils for CardUtils.NormalCard;
    using CardUtils for CardUtils.BattleCard;
    mapping(uint256 => CardUtils.Card) public CARDS;
    
    //TIPI DI CARTE
    mapping(uint256 => uint256) public UNCOMMON;
    mapping(uint256 => uint256) public COMMON;
    mapping(uint256 => uint256) public RARE;
    mapping(uint256 => uint256) public ULTRA_RARE;
    mapping(uint256 => uint256) public MYTHIC;
    mapping(uint256 => CardUtils.NormalCard) public normalCard;
    mapping(uint256 => CardUtils.BattleCard) public battleCard;
    mapping(uint256 => CardUtils.CardType) private cardTypes;

    Counters.Counter private _tokenCounter;
    constructor() ERC721("CTA", "Season 1") {
      mintCard(
            CardUtils.CardType.Battle,
            CardUtils.Card(
            "1111",
            "1111",
            1,
            1,
            CardUtils.CardType.Battle,
            "Good",
            CardUtils.CardRarity.Common
        ),
        CardUtils.CardInfo(
            "Shado",
            "Shado",
            1,
            "J",
            "G"
        ), CardUtils.CardOwner(
            "345",
            0x7D93107852454857C511b0c1E590b59B4cE34758
        ), CardUtils.CardAttr(
            false,
            false
        ), CardUtils.CardExtra(
            "Fire",
            "Arkanthe",
            "A",
            2,
            2,
            4,
            false
        ) );

            mintCard(
            CardUtils.CardType.Battle,
            CardUtils.Card(
            "2222",
            "2222",
            1,
            1,
            CardUtils.CardType.Battle,
            "Good",
            CardUtils.CardRarity.Mythic
        ),
        CardUtils.CardInfo(
            "Shado",
            "Shado",
            2,
            "J",
            "G"
        ), CardUtils.CardOwner(
            "345",
            0x7D93107852454857C511b0c1E590b59B4cE34758
        ), CardUtils.CardAttr(
            false,
            false
        ), CardUtils.CardExtra(
            "Fire",
            "Arkanthe",
            "A",
            2,
            2,
            4,
            false
        ) );

        mintCard(
            CardUtils.CardType.Battle,
            CardUtils.Card(
            "3333",
            "3333",
            1,
            1,
            CardUtils.CardType.Battle,
            "Good",
            CardUtils.CardRarity.Mythic
        ),
        CardUtils.CardInfo(
            "Shado",
            "Shado",
            3,
            "J",
            "G"
        ), CardUtils.CardOwner(
            "345",
            0x7D93107852454857C511b0c1E590b59B4cE34758
        ), CardUtils.CardAttr(
            false,
            false
        ), CardUtils.CardExtra(
            "Fire",
            "Arkanthe",
            "A",
            2,
            2,
            4,
            false
        ) );
      
    }

    fallback() external payable {}
    receive() external payable {}  
    event MergeCard(uint256 indexed tokenId, uint256[] burnedTokenId);
    event MintCard(address indexed sender, uint256 indexed tokenId, CardUtils.CardType typeOfCard, CardUtils.Card base, CardUtils.CardInfo info, CardUtils.CardOwner owner, CardUtils.CardAttr attr, CardUtils.CardExtra extra);
    event UpdateCard(uint256 indexed tokenId, CardUtils.CardType typeOfCard, CardUtils.Card base, CardUtils.CardInfo info,  CardUtils.CardOwner owner, CardUtils.CardAttr attr, CardUtils.CardExtra extra);
    event BurnToken(address indexed sender, uint256  indexed tokenId);
    event transferNft(address indexed from, address indexed to, uint256 indexed tokenId);
    event RegisterMarketPlace(address indexed marketPlaceApprover, bool isApproved);
    function tokenURI(uint256 tokenId) public override view returns(string memory) {
        require(cardTypes[tokenId] != CardUtils.CardType.None, "Card does not exists");
        if (cardTypes[tokenId] == CardUtils.CardType.Battle)
            return battleCard[tokenId].toTokenURI();
        return normalCard[tokenId].toTokenURI();        
    }

    function mergeCard(uint256 tokenId,uint256[] memory burnedTokenId) public returns(uint256){
        //update "medias"
        //the card that transforms, has the image in the medias, based on what it transforms
        //madias ->  struct of struct, because if it is an alternative coombo, you don't know which one you have to transform with

        uint256 len = burnedTokenId.length;

        for(uint i=0; i<len;i++){

            burnToken(burnedTokenId[i]);
        }

        CardUtils.CardType cardTypes = cardTypes[tokenId];

        //DO YOU DO THE MARGE ONLY OF THE BATTLE? WHY IF THIS WOULD NOT BE USED
        if (cardTypes == CardUtils.CardType.Battle) {
            CardUtils.BattleCard memory card = battleCard[tokenId];
        } else {
            CardUtils.NormalCard memory card = normalCard[tokenId];
        }

        //to manage the media field, it is an array of arrays and you should select which ones to insert in the image which is then put in the URI token
        //************************** */
        // what if we did it with a FLAG? frag indicating the number of "medias" to be selected, this flag is set both when minta and when marge

        emit MergeCard(tokenId, burnedTokenId);
        return tokenId;
    }

    function mintCard(
        CardUtils.CardType typeOfCard,
        CardUtils.Card memory base,
        CardUtils.CardInfo memory info,
        CardUtils.CardOwner memory owner,
        CardUtils.CardAttr memory attr,
        CardUtils.CardExtra memory extra
    ) public {
        require(typeOfCard != CardUtils.CardType.None, "Card type is not valid");

        uint256 newTokenId = _tokenCounter.current();

        if (base.rarity == CardUtils.CardRarity.Uncommon)
            UNCOMMON[newTokenId] = newTokenId;
        else if(base.rarity == CardUtils.CardRarity.Common)
            COMMON[newTokenId] = newTokenId;
        else if(base.rarity == CardUtils.CardRarity.Rare)
            RARE[newTokenId] = newTokenId;
        else if(base.rarity == CardUtils.CardRarity.UltraRare)
            ULTRA_RARE[newTokenId] = newTokenId;
        else if(base.rarity == CardUtils.CardRarity.Mythic)
            MYTHIC[newTokenId] = newTokenId;
        
        cardTypes[newTokenId] = typeOfCard;

        if (typeOfCard == CardUtils.CardType.Battle) {
            battleCard[newTokenId] = CardUtils.BattleCard(base, info, owner, attr, extra);
        } else {
            normalCard[newTokenId] = CardUtils.NormalCard(base, info, owner, attr);
        }
        
        _tokenCounter.increment();

        _safeMint(msg.sender, newTokenId);

        CARDS[newTokenId] = base;

        emit MintCard(msg.sender, newTokenId, typeOfCard, base, info, owner, attr, extra);
    }

    function registerMarketPlace(address marketPlace) public {
        setApprovalForAll(marketPlace, true);
         emit RegisterMarketPlace(marketPlace, true);
    }

   //TODO: it would be to reassign name, description, etc., with the variables I already have, and not what they pass to me
   //       so at least I don't risk running into mistakes

    function updateCard(
    uint256 tokenId,
    CardUtils.Card memory base,
    CardUtils.CardInfo memory info,
    CardUtils.CardOwner memory owner,
    CardUtils.CardAttr memory attr,
    CardUtils.CardExtra memory extra
    ) public{
        CardUtils.CardType typeOfCard = cardTypes[tokenId];
        require(typeOfCard != CardUtils.CardType.None, "Card not exists");

        if (typeOfCard == CardUtils.CardType.Battle) {

            CardUtils.BattleCard memory card = battleCard[tokenId];
        
            card.base = base;
            card.info = info;
            card.owner = owner;
            card.attr = attr;
            card.extra = extra;

            card.base.cardType = typeOfCard;
            battleCard[tokenId] = card;
        } else {

            CardUtils.NormalCard memory card = normalCard[tokenId];

            card.base = base;
            card.info = info;
            card.owner = owner;
            card.attr = attr;

            card.base.cardType = typeOfCard;
            normalCard[tokenId] = card;
        }
        emit UpdateCard(tokenId, typeOfCard, base, info,  owner, attr, extra);
    }

    //BURN
    function burnToken(uint256 tokenId) public {
        _burn(tokenId);
        emit BurnToken(msg.sender, tokenId);
    }

    //TRANSFER
    function TransferNft(address from, address to, uint256 tokenId) public{
        safeTransferFrom(from, to, tokenId);
        emit transferNft(from, to, tokenId);
    }

}

library JsonUtils {
    using StringUtils for string;

    function concat(string memory str1, string memory str2, string memory str3) public pure returns (string memory) {
        return str1.concat(",").concat(str2).concat(",").concat(str3);
    }

    function concat(string memory str1, string memory str2) public pure returns (string memory) {
        return str1.concat(",").concat(str2);
    }

    function concat(string[] memory components) public pure returns (string memory) {
        string memory _final = "";
        uint256 len = components.length;
        for (uint256 i = 0; i < len; i++) {
            _final = _final.concat(components[i]).concat((i + 1 < len ? "," : ""));
        }
        return _final;
    }

    function makeKeyPair(string memory key, string memory value) public pure returns (string memory) {
        return string("\"").concat(key).concat("\":\"").concat(value).concat("\"");
    }

    function makeObject(string[] memory keyPairs) public pure returns (string memory) {
        return string("{").concat(concat(keyPairs)).concat("}");
    }

    function makeArray(string memory key, string[] memory values) public pure returns (string memory) {
        return string("\"").concat(key).concat("\":[").concat(concat(values)).concat("]");
    }
}

library CardUtils {
    using Base64 for bytes;
    using Strings for uint;
    using Strings for uint8;
    using Strings for uint32;
    using Strings for uint256;
    using StringUtils for bool;
    using StringUtils for address;
    using StringUtils for CardRarity;

    enum CardRarity { None, Uncommon, Common, Rare, UltraRare, Mythic }
    enum CardType { None, Normal, Battle }

    struct Card {
        string uuid;
        string id;
        uint32 baseId;
        uint32 number;
        CardUtils.CardType cardType;
        string category;
        CardUtils.CardRarity rarity;
    }
    struct CardInfo {
        string name;
        string description; 
        uint32 version;
        string illustrator; 
        string medias; 
    }
    struct CardAttr {
        bool alternative;
        bool foil; 
    }
    struct CardOwner {
        string uuid;
        address owner;
    }
    struct CardExtra {
        string element;
        string origin;
        string faction;
        uint32 basePower;
        uint8 potential;
        uint8 rank;
        bool alternativeCombo;
    }
    struct NormalCard {
        Card base;
        CardInfo info;
        CardOwner owner;
        CardAttr attr;
    }
    struct BattleCard {
        Card base;
        CardInfo info;
        CardOwner owner;
        CardAttr attr;
        CardExtra extra;
    }

    function toTokenURI(NormalCard memory self)
        public pure returns (string memory)
    {
        string[] memory attributes = new string[](4);
        attributes[0] = baseJson(self.base);
        attributes[1] = infoJson(self.info);
        attributes[2] = attrJson(self.attr);
        attributes[3] = ownerJson(self.owner);

        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                abi.encodePacked("{",
                    JsonUtils.concat(
                        headerJson(self.info),
                        JsonUtils.makeArray("attributes", attributes)
                    ),
                "}").encode()
            )           
        );
    }

    function toTokenURI(BattleCard memory self)
        public pure returns (string memory)
    {
        string[] memory attributes = new string[](5);
        attributes[0] = baseJson(self.base);
        attributes[1] = infoJson(self.info);
        attributes[2] = attrJson(self.attr);
        attributes[3] = ownerJson(self.owner);
        attributes[4] = extraJson(self.extra);

        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                abi.encodePacked("{",
                    JsonUtils.concat(
                        headerJson(self.info),
                        JsonUtils.makeArray("attributes", attributes)
                    ),
                "}").encode()
            )
        );
    }

    function attributeTraitType(string memory traitType, string memory traitValue)
        public pure returns (string memory)
    {
        string[] memory keyPairs = new string[](2);
        keyPairs[0] = JsonUtils.makeKeyPair("trait_type", traitType);
        keyPairs[1] = JsonUtils.makeKeyPair("value", traitValue);
        return JsonUtils.makeObject(keyPairs);
    }

    function headerJson(CardInfo memory self)
        public pure returns (string memory)
    {
        string[] memory components = new string[](4);
        components[0] = JsonUtils.makeKeyPair("name", self.name);
        components[1] = JsonUtils.makeKeyPair("description", self.description);
        components[2] = JsonUtils.makeKeyPair("image", self.medias);
        components[3] = JsonUtils.makeKeyPair("animation_url", self.medias);
        return JsonUtils.concat(components);
    }

    function infoJson(CardInfo memory self)
        public pure returns (string memory)
    {
        string[] memory components = new string[](2);
        components[0] = attributeTraitType("illustrator", self.illustrator);
        components[1] = attributeTraitType("version", self.version.toString());
        return JsonUtils.concat(components);
    }

    function attrJson(CardAttr memory self)
        public pure returns (string memory)
    {
        string[] memory components = new string[](2);
        components[0] = attributeTraitType("alternative", self.alternative.toString());
        components[1] = attributeTraitType("foil", self.foil.toString());
        return JsonUtils.concat(components);
    }

    function extraJson(CardExtra memory self)
        public pure returns (string memory)
    {
        string[] memory components = new string[](7);
        components[0] = attributeTraitType("card Element", self.element);
        components[1] = attributeTraitType("card Origin", self.origin);
        components[2] = attributeTraitType("card Faction", self.faction);
        components[3] = attributeTraitType("base Power", self.basePower.toString());
        components[4] = attributeTraitType("potential", self.potential.toString());
        components[5] = attributeTraitType("rank", self.rank.toString());
        components[6] = attributeTraitType("alternative Combo", self.alternativeCombo.toString());
        return JsonUtils.concat(components);
    }

    function ownerJson(CardOwner memory self)
        public pure returns (string memory)
    {
        string[] memory components = new string[](2);
        components[0] = attributeTraitType("ownerUuid", self.uuid);
        components[1] = attributeTraitType("ownerAddress", self.owner.toString());
        return JsonUtils.concat(components);
    }

    function baseJson(Card memory self)
        public pure returns (string memory)
    {
        string[] memory components = new string[](4);
        components[0] = attributeTraitType("number", self.number.toString());
        components[1] = attributeTraitType("card Type", uint(self.cardType).toString());
        components[2] = attributeTraitType("card Category", self.category);
        components[3] = attributeTraitType("card Rarity", self.rarity.toString());
        return JsonUtils.concat(components);
    }
}

library StringUtils {

    function toString(bool self) public pure returns (string memory) {
        return (self) ? "true" : "false";
    }

    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

    function toString(address self) public pure returns (string memory) {
        return Strings.toHexString(uint160(self), 20);
    }

    function toString(CardUtils.CardRarity self) public pure returns (string memory) {
        if (self == CardUtils.CardRarity.Uncommon) {
            return "Uncommon";
        } else if (self == CardUtils.CardRarity.Common) {
            return "Common";
        } else if (self == CardUtils.CardRarity.Rare) {
            return "Rare";
        } else if (self == CardUtils.CardRarity.UltraRare) {
            return "UltraRare";
        } else if (self == CardUtils.CardRarity.Mythic) {
            return "Mythic";
        } else {
            return "None";
        }
    }

    function concat(string memory self, string memory concatenation) public pure returns (string memory) {
        return string(abi.encodePacked(self, concatenation));
    }
}
