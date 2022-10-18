// SPDX-License-Identifier:-MIT
pragma solidity >=0.8.0 <0.8.17;

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract ThunderEV is IERC20 {

    string public constant name = "Thunder-EV";
    string public constant symbol = "THEV";
    uint256 public constant decimals = 10**18;


    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    // Total Supply 2 Billion
    uint256 totalSupply_ = 2000000000000000000000000000;


   constructor() {
    balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public override view returns (uint256) {
    return totalSupply_;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        uint256 decimalnumTokens = numTokens * decimals;
        require(decimalnumTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender]-decimalnumTokens;
        balances[receiver] = balances[receiver]+decimalnumTokens;
        emit Transfer(msg.sender, receiver, decimalnumTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        uint256 decimalnumTokens = numTokens * decimals;
        allowed[msg.sender][delegate] = decimalnumTokens;
        emit Approval(msg.sender, delegate, decimalnumTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        uint256 decimalnumTokens = numTokens * decimals;
        require(decimalnumTokens <= balances[owner]);
        require(decimalnumTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner]-decimalnumTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-decimalnumTokens;
        balances[buyer] = balances[buyer]+decimalnumTokens;
        emit Transfer(owner, buyer, decimalnumTokens);
        return true;
    }
}