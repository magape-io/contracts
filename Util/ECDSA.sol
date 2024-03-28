// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {NotBan} from "../Util/NotBan.sol";

contract ECDSA is NotBan {
    function isVRS(
        uint256 amt,
        uint256 num,
        uint256 bid,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal notBan0 {
        bytes32 hsh;

        assembly {
            mstore(0x80, origin())
            mstore(0xa0, bid)
            mstore(0xc0, amt)
            mstore(0xe0, num)
            hsh := keccak256(0x80, 0x80)
        }

        address val = ecrecover(hsh, v, r, s);

        assembly {
            let ptr := shl(0x0a, bid) // bid must be unique

            // require(val == signer && mapping[bid] == 0);
            if or(iszero(eq(val, sload(APP))), gt(sload(ptr), 0x00)) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER4)
                revert(0x80, 0x64)
            }

            sstore(ptr, 0x01)
        }
    }
}
