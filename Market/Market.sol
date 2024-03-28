// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {DynamicPrice} from "../Util/DynamicPrice.sol";
import {Merch} from "../Market/Merch.sol";
import {P2P} from "../Market/P2P.sol";

contract Market is Merch, DynamicPrice, P2P {
    event List(address indexed, uint256 indexed, address indexed, uint256);
    event Buy(address indexed, address indexed, uint256 indexed);
    bytes32 private constant ELI =
        0x9b2c2060125acbb354a4a920d52588cb0024b0eead356cfc9f62c3b041fe3c63;
    bytes32 private constant EBU =
        0xd0c183be209f70036b50de16805d88249019e1288d7b77ef877710999c0d08e6;

    function list(
        address adr,
        uint256 tid,
        address tkn,
        uint256 amt
    ) external {
        // tkn - 0: 下架，1：货币，>1: 代币
        assembly {
            mstore(0x00, amt) // emit List
            log4(0x00, 0x20, ELI, adr, tid, tkn)

            mstore(0x80, OWO) // ownerOf(id)
            mstore(0x84, tid)
            pop(staticcall(gas(), adr, 0x80, 0x24, 0x00, 0x20))

            if iszero(eq(mload(0x0), caller())) {
                // require(ownerOf(tokenId) == msg.sender, 0xf)
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER2)
                revert(0x80, 0x64)
            }

            if gt(tkn, 0x0) {
                // if(tokenAddr > 0)
                mstore(0x80, AFA) // isApprovedForAll(address, address)
                mstore(0x84, caller())
                mstore(0xa4, address())
                pop(staticcall(gas(), adr, 0x80, 0x44, 0x00, 0x20))

                if iszero(mload(0x00)) {
                    // require(isApprovedForAll(msg.sender, address(this)))
                    mstore(0x80, ERR)
                    mstore(0xa0, STR)
                    mstore(0xc0, ER2)
                    revert(0x80, 0x64)
                }
            }

            mstore(0x00, adr) // listData[adr][tid] = (tkn, amt)
            mstore(0x20, tid)
            let tmp := keccak256(0x00, 0x40)
            sstore(tmp, tkn)
            sstore(add(tmp, 0x01), amt)
        }
    }

    // 单买
    function buy(address adr, uint256 tid) public payable {
        bytes32 tmp;

        assembly {
            log4(0x00, 0x00, EBU, caller(), adr, tid)

            mstore(0x80, OWO) // Item(adr).ownerOf(tid)
            mstore(0x84, tid)
            pop(staticcall(gas(), adr, 0x80, 0x24, 0x00, 0x20))
            let oid := mload(0x0)

            mstore(0x00, adr) // listData[adr][tid]
            mstore(0x20, tid)
            tmp := keccak256(0x00, 0x40) // require(listData[adr][tid].address != address(0))
            if iszero(sload(tmp)) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER1)
                revert(0x80, 0x64)
            }

            mstore(0x80, TFM) // Item(adr).transferFrom(oid, msg.sender, tid)
            mstore(0x84, oid)
            mstore(0xa4, caller())
            mstore(0xc4, tid)
            if iszero(call(gas(), adr, 0x00, 0x80, 0x64, 0x00, 0x00)) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER2)
                revert(0x80, 0x64)
            }
            adr := oid
        }

        _pay(tmp, adr, 0x01); // 转币给卖家减费用

        assembly {
            sstore(tmp, 0x00) // 下架 listData[adr][tid] = new List(address(0), 0)
        }
    }

    // 量买
    function buy(address[] memory adr, uint256[] memory tid) external payable {
        unchecked {
            for (uint256 i; i < adr.length; ++i) buy(adr[i], tid[i]);
        }
    }
}
