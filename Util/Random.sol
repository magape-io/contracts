// SPDX-License-Identifier: None
pragma solidity 0.8.0;

library Random {
    function ran(uint256 max) public view returns (uint256 num) {
        assembly {
            mstore(0x00, timestamp())
            mstore(0x20, caller())
            num := add(mod(keccak256(0x00, 0x40), max), 0x01)
        }
    }
}
