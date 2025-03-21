// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import {Hashes} from "../Util/Hashes.sol";

contract NFTFee is Hashes {
    constructor() payable {}
    
    function _pay(uint256 amt) internal {
        assembly {
            // require(ERC20(TFM).transferFrom(msg.sender, address(this), amt));
            mstore(0x80, TFM)
            mstore(0x84, caller())
            mstore(0xa4, address())
            mstore(0xc4, amt)
            if iszero(call(gas(), sload(TTF), 0x00, 0x80, 0x64, 0x00, 0x00)) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER5)
                revert(0x80, 0x64)
            }
        }
    }
}
