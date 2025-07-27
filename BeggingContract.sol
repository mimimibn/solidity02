// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract BeggingContract {
    /**
    contract   0x31D792834776E7Cf6285202207307D2e4d6FeDc2
    */
    mapping (address => uint256) balances;

    event Transfer(address from,address to, uint256 account);
    address public owner;

    constructor() {
        owner = msg.sender;
    }
    //捐赠金额
    function donate () payable  external{
        balances[msg.sender] += msg.value;//这里设置每个账户总的捐赠金额
        emit Transfer(msg.sender, address(this), msg.value);
    }
    //一个 withdraw 函数，允许合约所有者提取所有资金
    function withdraw () onlyOwner public {
        payable (owner).transfer(address(this).balance);
    }
    //一个 getDonation 函数，允许查询某个地址的捐赠金额。
    function getDonation (address addr)public view returns (uint256) {
        require(addr != address(0), "address is zero");
        return balances[addr];
    }
    modifier onlyOwner(){
        require(owner == msg.sender, "not owner");
        _;
    }
}