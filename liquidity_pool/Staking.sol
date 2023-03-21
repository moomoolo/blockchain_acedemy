// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./SafeMath.sol";
import "./RewardToken.sol";

contract Staking {
    using SafeMath for uint256;

    struct UserInfo {
        uint256 amount;
        uint256 rewardDebt;
    }

    struct PoolInfo {
        IERC20 lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        // decimals 1e12
        uint256 accRewardPerShare;
    }

    address public owner;
    RewardToken rewardToken;
    uint256 rewardPerBlock = 1e18;

    PoolInfo[] public poolInfo;

    mapping(uint256 => mapping(address => UserInfo)) public userInfo;

    uint256 public totalAllocPoint;

    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event Add(address indexed lpToken, uint256 pid);

    constructor(RewardToken _rewardToken) {
        rewardToken = _rewardToken;
        owner = address(msg.sender);
    }

    modifier onlyOwner {
        require(address(msg.sender) == owner, "Only Owner");
        _;
    }

    function add(
        IERC20 _lpToken,
        uint256 _allocPoint
    ) public onlyOwner {
        totalAllocPoint += _allocPoint;
        poolInfo.push(
            PoolInfo({
                lpToken: _lpToken,
                allocPoint: _allocPoint,
                lastRewardBlock: block.number,
                accRewardPerShare: 0
            })
        );
    }


    function getMultiplier(uint256 from, uint256 to) public pure returns(uint256) {
        return to - from;
    }

    function updatePool(uint256 pid) public {
        PoolInfo storage pool = poolInfo[pid];
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));
        if (lpSupply == 0) {
            pool.lastRewardBlock = block.number;
            return;
        }
        uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
        uint256 rewardAmount = multiplier.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
        rewardToken.mint(address(this), rewardAmount);
        pool.accRewardPerShare = pool.accRewardPerShare.add(rewardAmount.mul(1e12).div(lpSupply));
        pool.lastRewardBlock = block.number;
    }

    function deposite(uint256 pid, uint256 amount) public {
        PoolInfo storage pool = poolInfo[pid];
        UserInfo storage user = userInfo[pid][msg.sender];
        updatePool(pid);
        if (user.amount > 0) {
            uint256 pending = user.amount.mul(pool.accRewardPerShare).div(1e12).sub(user.rewardDebt);
            safeRewardTransfer(msg.sender, pending);
        }
        pool.lpToken.transferFrom(msg.sender, address(this), amount);
        user.amount = user.amount.add(amount);
        user.rewardDebt = user.amount.mul(pool.accRewardPerShare).div(1e12);
        emit Deposit(msg.sender, pid, amount);
    }

    function withdraw(uint256 pid, uint256 amount) public {
        PoolInfo storage pool = poolInfo[pid];
        UserInfo storage user = userInfo[pid][msg.sender];
        require(user.amount >= amount, "No enougn deposite");
        updatePool(pid);
        uint256 pending = user.amount.mul(pool.accRewardPerShare).div(1e12).sub(user.rewardDebt);
        safeRewardTransfer(msg.sender, pending);
        user.amount = user.amount.sub(amount);
        user.rewardDebt = user.amount.mul(pool.accRewardPerShare).div(1e12);
        pool.lpToken.transfer(msg.sender, amount);
        emit Withdraw(msg.sender, pid, amount);
    }

    function safeRewardTransfer(address to, uint256 amount) public {
        uint256 balance = rewardToken.balanceOf(address(this));
        if (amount > balance) {
            rewardToken.transfer(to, balance);
        } else {
            rewardToken.transfer(to, amount);
        }
    }

}