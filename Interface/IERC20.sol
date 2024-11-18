// SPDX-License-Identifier: None
pragma solidity 0.8.28;

interface IERC20 {
    event Transfer(address indexed, address indexed, uint256);
    event Approval(address indexed, address indexed, uint256);

    function totalSupply() external view returns (uint256);

    function balanceOf(address) external view returns (uint256);

    function transfer(address, uint256) external returns (bool);

    function allowance(address, address) external view returns (uint256);

    function approve(address, uint256) external returns (bool);

    function transferFrom(
        address,
        address,
        uint256
    ) external returns (bool);
}
