// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {GameActive} from "../Governance/GameActive.sol";

contract Merch is GameActive {
    event ListMerch(address indexed, uint256 indexed, uint256, uint256);
    event BuyMerch(address indexed, uint256 indexed, uint256);
    bytes32 private constant GAM =
        0x79131a1900000000000000000000000000000000000000000000000000000000;
    bytes32 private constant ELM =
        0x0c61c391161ef95499f5d35d6b7970dade5b309d8aad199063b0f41e74936630;
    bytes32 private constant EBM =
        0xda7fbb3426ef965104b6ba9c742f680c0e59505e523db837cd2b06a463245924;

    function listMerch  (
        uint256 mer,
        uint256 amt,
        uint256 qty
    ) external gameActive(msg.sender) returns (uint256 cnt) {
        assembly {
            // if (mer == 0) cnt = ++COUNT;
            switch mer
            case 0x00 {
                cnt := add(sload(INF), 0x01)
                sstore(INF, cnt)
            }
            // else cnt = mer;
            default {
                cnt := mer
            }
            // struct merch{address owner; uint256 amount; uint256 quantity;}
            // mapping(uint256=>merch) merc;
            mstore(0x00, cnt)
            let ptr := keccak256(0x00, 0x20)
            // if (merc[cnt].owner == msg.sender || merc[cnt].owner == address(0))
            // { merc[cnt].amount = amt; merc[cnt].amount = msg.sender; }
            let own := sload(ptr)
            if or(eq(own, caller()), and(iszero(own), iszero(mer))) {
                sstore(ptr, caller())
                sstore(add(ptr, 0x01), amt)
                sstore(add(ptr, 0x02), qty)
                // emit ListMerch(msg.sender, cnt, amt, qty);
                mstore(0x00, amt)
                mstore(0x20, qty)
                log3(0x00, 0x40, ELM, caller(), cnt)
            }
        }
    }

    function buyMerch(uint256 mer, uint256 qty) external {
        assembly {
            // emit BuyMerch(msg.sender, mer, qty);
            mstore(0x00, qty)
            log3(0x00, 0x20, EBM, caller(), mer)
            // mapping(uint256=>merch) merc;
            mstore(0x00, mer)
            mer := keccak256(0x00, 0x20)
            let own := sload(mer)
            let amt := sload(add(mer, 0x01))
            let qts := sload(add(mer, 0x02))
            // require(merc[mer].quantity >= qty);
            if gt(qty, qts) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER1)
                revert(0x80, 0x64)
            }
            // [先觉] approval
            mstore(0x80, TFM) // require(transferForm(msg.sender, own, amt * qty))
            mstore(0x84, caller())
            mstore(0xa4, own)
            mstore(0xc4, mul(amt, qty))
            if iszero(call(gas(), sload(TTF), 0x00, 0x80, 0x64, 0x00, 0x00)) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER2)
                revert(0x80, 0x64)
            }
            // erc[mer].quantity -= qty
            sstore(add(mer, 0x02), sub(qts, qty))
        }
    }

    function getPrice(uint256 mer)
        external
        view
        returns (uint256 amt, uint256 qty)
    {
        assembly {
            mstore(0x00, mer)
            let ptr := keccak256(0x00, 0x20)
            amt := sload(add(ptr, 0x01))
            qty := sload(add(ptr, 0x02))
        }
    }
}
