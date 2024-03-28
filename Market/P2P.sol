// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {GameActive} from "../Governance/GameActive.sol";

contract P2P is GameActive {
    event P2PBuy(uint256 indexed, uint256, address);

    bytes32 private constant EPP =
        0xb927474fe203313837008877197ceb2acf689cdb978aba011dd0d1c7104f1c1e;

    function p2PBuy(
        address frm,
        address gam,
        uint256 amt,
        uint256 bid
    ) external gameActive(gam) {
        // 是否被投进或有充值

        assembly {
            /* 
            存在问题：触发事件只可以 P2PBuy 或 Transfer
            不能同时触发
            */

            // emit P2PBuy(bid, amt, frm);
            mstore(0x00, amt)
            mstore(0x20, frm)
            log2(0x00, 0x40, EPP, bid)

            // 代币地址
            let con := sload(TTF)

            // 转进合约
            mstore(0x80, TFM) // require(transferFrom(caller(), address(this), amt))
            mstore(0x84, caller())
            mstore(0xa4, address())
            mstore(0xc4, amt)
            if iszero(call(gas(), con, 0x00, 0x80, 0x64, 0x00, 0x00)) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER5)
                revert(0x80, 0x64)
            }

            // 5% = amt * 5 / 100
            let bal := div(mul(0x05, amt), 0x64)
            // transfer(frm, amt*95%)
            mstore(0x80, TTF)
            mstore(0x84, frm)
            mstore(0xa4, sub(amt, bal))
            pop(call(gas(), con, 0x00, 0x80, 0x44, 0x00, 0x00))

            // bal /= 2
            bal := div(bal, 0x02)
            // transfer(gam, amt*2.5%)
            mstore(0x80, TTF)
            mstore(0x84, gam)
            mstore(0xa4, bal)
            pop(call(gas(), con, 0x00, 0x80, 0x44, 0x00, 0x00))

            // transfer(owo, amt*2.5%)
            mstore(0x80, TTF)
            mstore(0x84, sload(OWO))
            mstore(0xa4, bal)
            pop(call(gas(), con, 0x00, 0x80, 0x44, 0x00, 0x00))
        }
    }
}
