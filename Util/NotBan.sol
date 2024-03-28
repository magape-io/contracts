// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Hashes} from "../Util/Hashes.sol";

contract NotBan is Hashes {
    modifier notBan0() {
        assembly {
            // require(!suspended[address(this)] && !suspended[msg.sender]);
            if or(gt(sload(address()), 0x00), gt(sload(caller()), 0x00)) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER3)
                revert(0x80, 0x64)
            }
        }
        _;
    }

    modifier notBan1(address adr) {
        assembly {
            // require(!suspended[address(this)] && !suspended[msg.sender]
            // && !suspended[adr]);
            if or(
                or(gt(sload(address()), 0x00), gt(sload(caller()), 0x00)),
                gt(sload(adr), 0x00)
            ) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER3)
                revert(0x80, 0x64)
            }
        }
        _;
    }

    function notBan2(address adr, address ad2) internal view {
        assembly {
            // require(!suspended[address(this)] && !suspended[msg.sender]
            // && !suspended[adr] && !suspended[ad2]);
            if or(
                or(
                    or(gt(sload(address()), 0x00), gt(sload(caller()), 0x00)),
                    gt(sload(adr), 0x00)
                ),
                gt(sload(ad2), 0x00)
            ) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER3)
                revert(0x80, 0x64)
            }
        }
    }
}
