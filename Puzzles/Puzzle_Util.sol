// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

contract Puzzle_Util {
    function encrypt(address ad1, address ad2)
        external
        pure
        returns (bytes32 val)
    {
        assembly {
            val := add(ad1, ad2)
        }
    }

    function genChainID(
        address adr,
        uint256 nu1,
        uint256 nu2
    ) external pure returns (bytes32 val) {
        assembly {
            val := add(shr(nu1, adr), nu2)
        }
    }
}
