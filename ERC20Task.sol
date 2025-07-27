// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ERC20Task {

   /**
        contract 0x9aB87CC962b67C2c1E10a61b411Ad8D6Bb17DA82 
    */
    /*
    任务：参考 openzeppelin-contracts/contracts/token/ERC20/IERC20.sol实现一个简单的 ERC20 代币合约。要求：
    合约包含以下标准 ERC20 功能：
    balanceOf：查询账户余额。
    transfer：转账。
    approve 和 transferFrom：授权和代扣转账。
    使用 event 记录转账和授权操作。
    提供 mint 函数，允许合约所有者增发代币。
    提示：
    使用 mapping 存储账户余额和授权信息。
    使用 event 定义 Transfer 和 Approval 事件。
    部署到sepolia 测试网，导入到自己的钱包*/
    //key为拥有者地址，value为数量
    mapping(address => uint) public balances;
    //key为授权者，第二个key为被授权者，value为数量
    //例如，张三授权李四200元
    //张三=>(李四=》200)
    mapping(address => mapping(address => uint256)) public allowances;
    //发布者
    address public owner;
    uint256 public totalSupply;

    //交易事件
    event Transfer (address from,address to, uint256 value);
    //授权事件
    event Approval(address owner,address spender,uint256 value);
    /**
    初始化
    设置总数量
    将总数量全部授权给发行者
    */
    constructor(uint256 _totalSupply) {
        owner = msg.sender;
        //设置发行数量
        totalSupply = _totalSupply;
        balances[msg.sender] = totalSupply;
        //设置初始化交易，从0地址发送全部数量到发行者
        emit Transfer(address(0x0), msg.sender, totalSupply);
    }
    //Returns the value of tokens owned by `account`.
    //这里是获取当前账户的余额
    function balanceOf(address addr) external view returns (uint256){
        return balances[addr];
    }
    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
     //普通转账接口，指的是调用者向to地址转账，
     //需要检查余额是否大于value值
    function transfer(address to, uint256 value) external returns (bool){
        require(to != address(0), "address is zero");
        //查询查询调用者额度
        uint256 balance = balances[msg.sender];
        //余额不足，转账失败
        if (balance < value) {
            return false;
        }
        balances[msg.sender] -= value;
        balances[to] += value;
        // 发送交易事件
        emit Transfer(msg.sender, to, value);
        return true;
    }
    //设置授权，张三调用这个接口，张三授权李四200元
    function approve(address spender, uint256 value) external returns (bool){
        require(spender != address(0), "address is zero");
        //这里，不管有钱没钱，都允许授权，但是在transferFrom时，需要再次检查实际金额
        allowances[msg.sender][spender] = value;
        emit Approval(msg.sender,spender,value);
        return true;
    }
    //这是被授权者调用，李四调用，
    //from为张三（因为是张三授权李四），to（指的是谁收钱）
    //这里先检查张三金额是否大于value，再检查授权额度是否足够
    function transferFrom(address from, address to, uint256 value) external returns (bool){
        require(from != address(0), "address is zero");
        require(to != address(0), "address is zero");
        //查询扣除者额度是否足够
        uint256 balance = balances[from];
        //余额不足，转账失败
        if (balance < value) {
            return false;
        }
        uint256 approveBalance = allowances[from][msg.sender];
        if (approveBalance < value){
            return false;
        }
        balances[from] -= value;
        balances[to] += value;
        allowances[from][msg.sender] -= value;
        // 发送交易事件
        emit Transfer(from, to, value);
        return true;
    }
    function mint(address account, uint256 value) external {
        require(owner == msg.sender, "not owner,not mint");
        _mint(account, value);
    }
    function _mint(address account, uint256 value) internal{
        require(account != address(0), "address is zero");
        totalSupply += value;
        balances[account] += value;
        emit Transfer(address(0),account,value);
    }
}