// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Hashes} from "../Util/Hashes.sol";

contract Market is Hashes {
    // game, receiver, sender, bid, amt
    event Buy(
        address indexed,
        address indexed,
        address indexed,
        uint256,
        uint256
    );

    // bulk purchase
    function buy(
        address gam,
        uint256 ttl,
        address[] calldata rcv,
        uint256[] calldata bid,
        uint256[] calldata amt
    ) external {
        assembly {
            // (bool isActive, uint256 amtPool) = Node(adr).games(mer);
            mstore(
                0x80,
                0x79131a1900000000000000000000000000000000000000000000000000000000
            )
            mstore(0x84, sload(ER5))
            pop(staticcall(gas(), sload(TP5), 0x80, 0x84, 0x00, 0x40))
            // require(isActive || amtPool >= MAC);
            if and(iszero(mload(0x00)), lt(mload(0x20), sload(ER5))) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER1)
                revert(0x80, 0x64)
            }

            // require(MAC(TTF).transferForm(msg.sender, address(this), ttl))
            mstore(0x80, TFM)
            mstore(0x84, caller())
            mstore(0xa4, address())
            mstore(0xc4, ttl)
            if iszero(call(gas(), sload(TTF), 0x00, 0x80, 0x64, 0x00, 0x00)) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER2)
                revert(0x80, 0x64)
            }

            // reset ttl to transfer to admin
            ttl := 0x00
        }
        unchecked {
            for (uint256 i; i < rcv.length; ++i) {
                (address rc1, uint256 bi1, uint256 am1) = (
                    rcv[i],
                    bid[i],
                    amt[i]
                );
                assembly {
                    // ttl += ttl*0.05
                    ttl := add(ttl, div(am1, 0x14)) // admin 5%

                    // require(transfer(rc1, am1));
                    mstore(0x80, TTF)
                    mstore(0x84, rc1)
                    mstore(0xa4, div(mul(am1, 0x5f), 0x64)) // receiver 95% (wrong)
                    if iszero(
                        call(gas(), sload(TTF), 0x00, 0x80, 0x44, 0x00, 0x00)
                    ) {
                        mstore(0x80, ERR)
                        mstore(0xa0, STR)
                        mstore(0xc0, ER5)
                        revert(0x80, 0x64)
                    }

                    // emit Buy(gam, rc1, msg.sender, bi1, am1)
                    mstore(0x00, bi1)
                    mstore(0x20, am1)
                    log4(
                        0x00,
                        0x40,
                        0xbab4aa6b2d5c0935e0e2937d1f73655848f670d43bf6f0c7e9e11e635bb5d86f,
                        gam,
                        caller(),
                        rc1
                    )
                }
            }
        }
        assembly {
            // require(transfer(OWO, ttl));
            mstore(0x80, TTF)
            mstore(0x84, sload(OWO))
            mstore(0xa4, ttl)
            if iszero(call(gas(), sload(TTF), 0x00, 0x80, 0x44, 0x00, 0x00)) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER5)
                revert(0x80, 0x64)
            }
        }
    }
}
