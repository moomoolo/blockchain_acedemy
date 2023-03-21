// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./SafeMath.sol";

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
        uint256 accRewardPerShare;
    }

    address public owner;
    IERC20 rewardToken;

    PoolInfo[] public poolInfo;

    mapping(uint256 => mapping(address => UserInfo)) public userInfo;

    uint256 public totalAllocPoint;

    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event Add(address indexed lpToken, uint256 pid);

    constructor(IERC20 _rewardToken) {
        rewardToken = _rewardToken;
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only Owner");
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

    function deposite(uint256 pid, uint256 amount) public {
        PoolInfo storage pool = poolInfo[pid];
        UserInfo storage user = userInfo[pid][msg.sender];

        


    }

}