pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Klu {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function decimals() public view returns (uint8);
    function totalSupply() external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function balanceOf(address account) public view returns (uint256);
}

contract KluBurner {
    function burn(address who, address account, uint256 amount) external returns (uint256 used);
}

contract Whale {
    function mintSingle(address _to, string memory back, string memory eye, string memory body, string memory belly) public;

    function ownerOf(uint256 tokenId) public view returns (address);
    function totalSupply() public view returns (uint256);
    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
    function balanceOf(address owner) public view returns (uint256 balance);
    function tokenURI(uint256 tokenId) public view returns (string memory);

    function setHead(uint tokenId, string memory name) public;
    function setMouth(uint tokenId, string memory name) public;
    function setTail(uint tokenId, string memory name) public;
    function setItem(uint tokenId, string memory name) public;
}

contract DNA {
    function setDna(uint tokenId, string memory back, string memory eye, string memory body, string memory belly) public;
    function getDna() public view returns (string[] memory);
}

contract SeaKlu {
    using SafeMath for uint;

    uint private _burnRate;
    uint private _value;
    uint private _randomSeed;

    address private _owner;
    address private _whaleAddr;
    address private _burnAddr;

    string[] private headList;
    string[] private mouthList;
    string[] private tailList;
    string[] private itemList;

    mapping(string => uint) private headCreator;
    mapping(string => uint) private mouthCreator;
    mapping(string => uint) private tailCreator;
    mapping(string => uint) private itemCreator;

    mapping(uint => bool) private _isCave;

    mapping(uint => string[]) private _myHeadList;
    mapping(uint => string[]) private _myMouthList;
    mapping(uint => string[]) private _myTailList;
    mapping(uint => string[]) private _myItemList;

    Klu private _klu;
    KluBurner private _burner;
    Whale private _whale;
    DNA private _dna;

    event hunting(string category, string name);

    constructor(address kluAddr, address burnerAddr, address whaleAddr, address dnaAddr) public {
        _owner = msg.sender;
        _whaleAddr = whaleAddr;
        _burnAddr = burnerAddr;

        _klu = Klu(kluAddr);
        _burner = KluBurner(burnerAddr);
        _whale = Whale(whaleAddr);
        _dna = DNA(dnaAddr);

        _value = 10 ** uint(_klu.decimals()) * 1;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner);
        _;
    }

    function valueChange(uint value) public onlyOwner {
        _value = 10 ** uint(_klu.decimals()) * value;
    }
    
    function burnChange(uint value) public onlyOwner {
        _burnRate = value;
    }

    function burnerChange(address burnerAddr) public onlyOwner {
        _burnAddr = burnerAddr;
        _burner = KluBurner(burnerAddr);
    }

    function tokenChange(address tokenAddr) public onlyOwner {
        _klu = Klu(tokenAddr);
        valueChange(5);
    }

    function _transferKlu(uint value) internal {
        uint used = 0;
        if(_burnRate > 0) {
            used = value / 10 * _burnRate;
            _klu.transferFrom(msg.sender, address(this), used);
            _klu.approve(_burnAddr, used);
            _burner.burn(_whaleAddr, address(this), used);
        }

        _klu.transferFrom(msg.sender, _owner, value.sub(used));
    }

    function Mint(string memory back, string memory eye, string memory body, string memory belly) public {
        require(_whale.totalSupply() < 1000);
        _transferKlu(_value);

        _dna.setDna(0, back, eye, body, belly);
        _whale.mintSingle(msg.sender, back, eye, body, belly);
    }

    function ColorChange(uint tokenId, string memory back, string memory eye, string memory body, string memory belly) public {
        require(_whale.ownerOf(tokenId) == msg.sender);
        _transferKlu(_value);
        _dna.setDna(tokenId, back, eye, body, belly);
    }

    function HuntingItem(uint tokenId) public {
        require(_whale.ownerOf(tokenId) == msg.sender);

        uint creatorFee = _value / 10 * 2;
        _transferKlu(_value.sub(creatorFee));

        _klu.transferFrom(msg.sender, _whale.ownerOf(_huntingItem(tokenId)), creatorFee);
    }

    function GiveItem(uint tokenId) public onlyOwner {
        _huntingItem(tokenId);
    }

    function _huntingItem(uint tokenId) internal returns (uint) {
        _randomSeed = uint(keccak256(abi.encodePacked(_klu.totalSupply(), _randomSeed)));
        uint itemType = _randomSeed % 4;
        bool myCave = _isCave[tokenId];
        uint creatorId;

        if(itemType == 0) {
            string memory myHead = headList[_randomSeed / headList.length % headList.length];
            _whale.setHead(tokenId, myHead);

            creatorId = headCreator[myHead];

            if(myCave) {
                _myHeadList[tokenId].push(myHead);
            }

            emit hunting("head", myHead);

        } else if(itemType == 1) {
            string memory myMouth = mouthList[_randomSeed / mouthList.length % mouthList.length];
            _whale.setMouth(tokenId, myMouth);

            creatorId = mouthCreator[myMouth];

            if(myCave) {
                _myMouthList[tokenId].push(myMouth);
            }

            emit hunting("mouth", myMouth);

        } else if(itemType == 2) {
            string memory myTail = tailList[_randomSeed / tailList.length % tailList.length];
            _whale.setTail(tokenId, myTail);

            creatorId = tailCreator[myTail];

            if(myCave) {
                _myTailList[tokenId].push(myTail);
            }

            emit hunting("tail", myTail);

        } else {
            string memory myItem = itemList[_randomSeed / itemList.length % itemList.length];
            _whale.setItem(tokenId, myItem);

            creatorId = itemCreator[myItem];

            if(myCave) {
                _myItemList[tokenId].push(myItem);
            }

            emit hunting("item", myItem);
        }

        return creatorId;
    }

    function GetCave(uint tokenId) public {
        require(_whale.ownerOf(tokenId) == msg.sender);
        require(!_isCave[tokenId]);
        _transferKlu(_value * 10);
        _isCave[tokenId] = true;
    }

    function GiveCave(uint tokenId) public onlyOwner {
        _isCave[tokenId] = true;
    }

    function MyItem(uint tokenId) public view returns(string[] memory, string[] memory, string[] memory, string[] memory) {
        return (_myHeadList[tokenId], _myMouthList[tokenId], _myTailList[tokenId], _myItemList[tokenId]);
    }

    function ItemList() public view returns(string[] memory, string[] memory, string[] memory, string[] memory) {
        return (headList, mouthList, tailList, itemList);
    }

    function Dashboard() public view returns (uint, uint, uint, string[] memory, string[] memory, bool[] memory) {
        string[] memory urlArr = new string[](_whale.balanceOf(msg.sender));
        bool[] memory caveArr = new bool[](urlArr.length);
        for(uint i=0; i<urlArr.length; i++) {
            uint tokenId = _whale.tokenOfOwnerByIndex(msg.sender, i);
            urlArr[i] = _whale.tokenURI(tokenId);
            caveArr[i] = _isCave[tokenId];
        }
        
        return (
            _klu.balanceOf(msg.sender),
            _klu.allowance(msg.sender, address(this)),
            _whale.totalSupply(),
            _dna.getDna(),
            urlArr,
            caveArr
        );
    }

    function SetMyHead(uint tokenId, string memory name) public {
        require(_whale.ownerOf(tokenId) == msg.sender);
        require(_isCave[tokenId]);

        string[] memory myHeadList = _myHeadList[tokenId];
        for(uint i=0; i<myHeadList.length; i++) {
            if(keccak256(abi.encodePacked(myHeadList[i])) == keccak256(abi.encodePacked(name))) {
                _whale.setHead(tokenId, name);
                break;
            }
        }
    }

    function SetMyMouth(uint tokenId, string memory name) public {
        require(_whale.ownerOf(tokenId) == msg.sender);
        require(_isCave[tokenId]);

        string[] memory myMouthList = _myMouthList[tokenId];
        for(uint i=0; i<myMouthList.length; i++) {
            if(keccak256(abi.encodePacked(myMouthList[i])) == keccak256(abi.encodePacked(name))) {
                _whale.setMouth(tokenId, name);
                break;
            }
        }
    }

    function SetMyTail(uint tokenId, string memory name) public {
        require(_whale.ownerOf(tokenId) == msg.sender);
        require(_isCave[tokenId]);

        string[] memory myTailList = _myTailList[tokenId];
        for(uint i=0; i<myTailList.length; i++) {
            if(keccak256(abi.encodePacked(myTailList[i])) == keccak256(abi.encodePacked(name))) {
                _whale.setTail(tokenId, name);
                break;
            }
        }
    }

    function SetMyItem(uint tokenId, string memory name) public {
        require(_whale.ownerOf(tokenId) == msg.sender);
        require(_isCave[tokenId]);

        string[] memory myItemList = _myItemList[tokenId];
        for(uint i=0; i<myItemList.length; i++) {
            if(keccak256(abi.encodePacked(myItemList[i])) == keccak256(abi.encodePacked(name))) {
                _whale.setItem(tokenId, name);
                break;
            }
        }
    }

    function setHuntingHead(string memory name, uint creator) public onlyOwner {
        headList.push(name);
        headCreator[name] = creator;
        _myHeadList[creator].push(name);
    }

    function setHuntingMouth(string memory name, uint creator) public onlyOwner {
        mouthList.push(name);
        mouthCreator[name] = creator;
        _myMouthList[creator].push(name);
    }

    function setHuntingTail(string memory name, uint creator) public onlyOwner {
        tailList.push(name);
        tailCreator[name] = creator;
        _myTailList[creator].push(name);
    }

    function setHuntingItem(string memory name, uint creator) public onlyOwner {
        itemList.push(name);
        itemCreator[name] = creator;
        _myItemList[creator].push(name);
    }

    function headReset() public onlyOwner {
        delete headList;
    }

    function mouthReset() public onlyOwner {
        delete mouthList;
    }

    function tailReset() public onlyOwner {
        delete tailList;
    }

    function itemReset() public onlyOwner {
        delete itemList;
    }
}