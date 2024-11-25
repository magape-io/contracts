// SPDX-License-Identifier: None
pragma solidity 0.8.28;

import {Hashes} from "../Util/Hashes.sol";

contract Distribute is Hashes {
    event Distri(address indexed, address indexed, uint256);
    
    constructor() payable {}

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
            let nul := call(gas(), tkn, 0x00, 0x80, 0x44, 0x00, 0x00)

            let rcp := sload(tkn)

            // ERC20(tkn).transfer(pay, amt - fee);
            // Every new game will have a token that is mapped to
            // a receiving address. This address can be set from
            // Upgrade.sol mem(token_address, receiver_address)
            mstore(0x84, rcp)
            mstore(0xa4, sub(amt, fee))
            nul := call(gas(), tkn, 0x00, 0x80, 0x44, 0x00, 0x00)

            // emit Distri(msg.sender, rcp, amt);
            mstore(0x00, amt)
            log3(
                0x00,
                0x20,
                0x48599caf6bd08d44be14a04a307db8fab0c637666a2bd52a8e6b2688ffa849ec,
                caller(),
                rcp
            )
        }
    }
}
