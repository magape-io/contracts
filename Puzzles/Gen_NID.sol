// SPDX-License-Identifier: None
pragma abicoder v1;
pragma solidity 0.8.0;

contract Gen_NID {
    constructor() payable {}

    function genNID(
        address adr,
        uint256 bit,
        uint256 num
    ) external pure returns (uint256) {
        assembly {
            mstore(0x00, add(shr(bit, adr), num))
            return(0x00, 0x20)
        }
    }
}