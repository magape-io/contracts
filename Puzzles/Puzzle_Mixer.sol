// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

contract Puzzle_Mixer {
    constructor() payable {}
    
    function mix(address a, address b) external pure returns (bytes32) {
        assembly {
            mstore(0x00, add(a, b))
            return(0x00, 0x20)
        }
    }

    function nid(
        address a,
        uint256 b,
        uint256 c
    ) external pure returns (bytes32) {
        assembly {
            mstore(0x00, add(shr(b, a), c))
            return(0x00, 0x20)
        }
    }
}
