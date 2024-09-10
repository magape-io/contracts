// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Hashes} from "../Util/Hashes.sol";
import {ECDSA} from "../Util/ECDSA.sol";

contract Trove is Hashes, ECDSA {
    event Stake(address indexed, address indexed, uint256 indexed, uint256);
    bytes32 private constant STK =
        0x63602d0ecc7b3a0ef7ff1a116e23056662d64280355ba8031b6d0d767c4b4458;

    function stake(
        uint256 amt,
        uint256 bid,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        isVRS(amt, 0x00, bid, v, r, s);

        assembly {
            // stake[adr].amt += amt;
            let tmp := shl(0x07, caller())
            sstore(tmp, add(sload(tmp), amt))

            // emit Stake(msg.sender, address(this), bid, amt);
            mstore(0x00, amt)
            log4(0x00, 0x20, STK, caller(), address(), bid)
        }
    }

    function stake(uint256 amt, uint256 bid) external {
        assembly {
            // stake[adr].amt += amt;
            let tmp := shl(0x07, caller())
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

            // emit Stake(msg.sender, address(this), bid, amt);
            mstore(0x00, amt)
            log4(0x00, 0x20, STK, caller(), address(), bid)
        }
    }

    function stake(uint256 amt) external {
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

            let ptr := shl(0x06, caller())
            let bal := sload(ptr)
            if gt(amt, bal) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER5)
                revert(0x80, 0x64)
            }
            sstore(ptr, sub(bal, amt)) // stake[adr].amt -= amt;

            // emit Stake(msg.sender, address(this), bid, amt);
            mstore(0x00, amt)
            log4(0x00, 0x20, STK, address(), caller(), 0x00)
        }
    }
}
