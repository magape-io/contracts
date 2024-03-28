// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Ownable} from "../Util/Ownable.sol";

contract Manual is Ownable {
    function mem(
        address adr,
        bytes32 byt,
        bytes32 val
    ) external onlyOwner {
        assembly {
            // Upgrade(adr).mem(adr, val);
            mstore(0x80, 0xb88bab2900000000000000000000000000000000000000000000000000000000)
            mstore(0x84, byt)
            mstore(0xa4, val)
            if iszero(call(gas(), adr, 0x00, 0x80, 0xa4, 0x00, 0x00)) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER1)
                revert(0x80, 0x64)
            }
        }
    }

    function mint(
        address adr,
        address toa,
        uint256 amt
    ) external onlyOwner {
        assembly {
            // Asset(adr).mint(toa, amt);
            mstore(0x80, 0x40c10f1900000000000000000000000000000000000000000000000000000000)
            mstore(0x84, toa)
            mstore(0xa4, amt)
            if iszero(call(gas(), adr, 0x00, 0x80, 0xa4, 0x00, 0x00)) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER1)
                revert(0x80, 0x64)
            }
        }
    }
}
