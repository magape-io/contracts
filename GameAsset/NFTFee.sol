// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Hashes} from "../Util/Hashes.sol";

contract NFTFee is Hashes {
    function _pay(uint256 amt) internal {
        assembly {
            let tkn := sload(TTF)
            
            // require(ERC20(TFM).transferFrom(msg.sender, OWO, amt));
            mstore(0x80, TFM)
            mstore(0x84, caller())
            mstore(0xa4, address())
            mstore(0xc4, amt)
            if iszero(call(gas(), tkn, 0x00, 0x80, 0x64, 0x00, 0x00)) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER5)
                revert(0x80, 0x64)
            }

            // ERC20(TTF).burn(amt)
            mstore(0x80, 0x42966c6800000000000000000000000000000000000000000000000000000000)
            mstore(0x84, amt)
            pop(call(gas(), tkn, 0x00, 0x80, 0x24, 0x00, 0x00))
        }
    }
}
