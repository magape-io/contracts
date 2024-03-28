// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Hashes} from "../Util/Hashes.sol";
import {ECDSA} from "../Util/ECDSA.sol";

contract Resources is Hashes, ECDSA {
    event P2PBuy(uint256, uint256);

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

    function topUp(address adr, uint256 amt) external {
        assembly {
            // game[adr].amt += amt;
            let tmp := shl(0x06, adr)
            sstore(tmp, add(sload(tmp), amt))
        }
        _transferFrom(amt);
    }

    function resourceIn(address adr, uint256 amt) external {
        assembly {
            // require(games[adr].stt);
            if iszero(sload(shl(0x05, adr))) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER1)
                revert(0x80, 0x64)
            }

            // emit Transfer(adr, ad2, amt)
            mstore(0x00, amt)
            log3(0x00, 0x20, ETF, caller(), adr)
        }
        _transferFrom(amt);
    }

    function resourceIn(uint256 bid, uint256 amt) external {
        assembly {
            // emit P2PBuy(bid, amt)
            mstore(0x00, bid)
            mstore(0x20, amt)
            log2(0x00, 0x40, 0x5b6b68c7bdbd1a2670386a943b40bb818dd5806b1cbfdbe38b4b399a8a7e6eab, caller())
        }
        _transferFrom(amt);
    }

    function resourceOut(
        address adr,
        uint256 amt,
        uint256 bid,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        isVRS(amt, 0, bid, v, r, s);

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

            // if(!game[adr].stt)
            if iszero(sload(shl(0x05, adr))) {
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
}
