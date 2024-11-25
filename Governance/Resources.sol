// SPDX-License-Identifier: None
pragma solidity 0.8.28;

import {Hashes} from "../Util/Hashes.sol";
import {ECDSA} from "../Util/ECDSA.sol";

contract Resources is Hashes, ECDSA {
    constructor() payable {}

    function _transferFrom(uint256 amt) private {
        assembly {
            // require(MAC(TTF).transferForm(msg.sender, address(this), amt))
            mstore(0x80, TFM)
            mstore(0x84, caller())
            mstore(0xa4, address())
            mstore(0xc4, amt)
            if iszero(call(gas(), sload(TTF), 0x00, 0x80, 0x64, 0x00, 0x00)) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER2)
                revert(0x80, 0x64)
            }
        }
    }

    function resourceIn(address adr, uint256, uint256 amt) external {
        assembly {
            // game[adr].amt += amt;
            let tmp := shl(0x06, adr)
            sstore(tmp, add(sload(tmp), amt))

            // require(MAC(TTF).transferForm(msg.sender, address(this), amt))
            mstore(0x80, TFM)
            mstore(0x84, caller())
            mstore(0xa4, address())
            mstore(0xc4, amt)
            if iszero(call(gas(), sload(TTF), 0x00, 0x80, 0x64, 0x00, 0x00)) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER2)
                revert(0x80, 0x64)
            }
        }
    }

    function resourceOut(
        address adr,
        uint256 amt,
        uint256 bid,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        isVRS(amt, 0x00, bid, v, r, s);

        assembly {
            // MAC(TTF).transfer(toa, amt)
            mstore(0x80, TTF)
            mstore(0x84, caller())
            mstore(0xa4, amt)
            if iszero(call(gas(), sload(TTF), 0x00, 0x80, 0x44, 0x00, 0x00)) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER5)
                revert(0x80, 0x64)
            }

            r := shl(0x06, adr)
            s := sload(r)
            if gt(amt, s) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER5)
                revert(0x80, 0x64)
            }
            sstore(r, sub(s, amt)) // game[adr].amt -= amt;
        }
    }
}
