// SPDX-License-Identifier:None
pragma solidity 0.8.28;

interface IERC20 {
    function transferFrom(
        address,
        address,
        uint256
    ) external;
    function transfer(address, uint256) external;
    function mint(address, uint256) external;
}

contract Test_Contract_Pay {
    address constant ADMIN = 0xA34357486224151dDfDB291E13194995c22Df505;
    IERC20 ierc20;

    constructor(address adr) payable {
        ierc20 = IERC20(adr);
    }

    // approval of 1e18 is needed for this contract
    // should receive 3 events
    // 1. mint to user
    // 2. user transfer to this contract 
    // 3. this contract transfer to admin
    function standardPay() external {
        ierc20.mint(msg.sender, 1 ether);
        ierc20.transferFrom(msg.sender, address(this), 1 ether);
        ierc20.transfer(ADMIN, 1 ether);
    }

    // approval of 1e18 is needed for admin
    // should receive 2 events
    // 1. mint to user
    // 2. user transfer to admin
    function directPay() external {
        ierc20.mint(msg.sender, 1 ether);
        ierc20.transferFrom(msg.sender, ADMIN, 1 ether);
    }

    // no approval is needed
    // should receive 2 events
    // 1. mint to contract
    // 2. contract transfer to admin
    function localPay() external {
        ierc20.mint(address(this), 1 ether);
        ierc20.transfer(ADMIN, 1 ether);
    }

    // no approval is needed
    // should receive 1 event
    // 1. mint to admin
    function mintPay() external {
        ierc20.mint(ADMIN, 1 ether);
    }
}
