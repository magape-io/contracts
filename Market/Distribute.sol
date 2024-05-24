// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Hashes} from "../Util/Hashes.sol";

contract Distribute is Hashes {
    function distribute(uint256 amt, address tkn) external {
        assembly {
            // require(ERC20(TFM).transferFrom(msg.sender, address(this), amt));
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

            let fee := div(amt, sload(TFM))

            // ERC20(tkn).transfer(_owner, fee);
            mstore(0x80, TTF)
            mstore(0x84, sload(OWO))
            mstore(0xa4, fee)
            // pop(call(gas(), tkn, 0x00, 0x80, 0x44, 0x00, 0x00))
            if iszero(call(gas(), tkn, 0x00, 0x80, 0x44, 0x00, 0x00)) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER5)
                revert(0x80, 0x64)
            }

            // ERC20(tkn).transfer(pay, amt - fee);
            // Every new game will have a token that is mapped to
            // a receiving address. This address can be set from
            // Upgrade.sol mem(token_address, receiver_address)
            mstore(0x84, sload(tkn))
            mstore(0xa4, sub(amt, fee))
            // pop(call(gas(), tkn, 0x00, 0x80, 0x44, 0x00, 0x00))
            if iszero(call(gas(), tkn, 0x00, 0x80, 0x44, 0x00, 0x00)) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER5)
                revert(0x80, 0x64)
            }
        }
    }
}