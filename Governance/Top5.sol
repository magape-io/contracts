// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Hashes} from "../Util/Hashes.sol";

contract Top5 is Hashes {
    function isTop5(address adr) external view returns (bool bol, uint256 nod) {
        assembly {
            // 索子节点
            mstore(0x00, adr)
            nod := sload(add(keccak256(0x00, 0x20), 0x01))

            // 相应内存
            mstore(0x00, TP5)
            mstore(0x20, nod)
            let tmp := keccak256(0x00, 0x40)

            for {
                let i
            } lt(i, 0x05) {
                i := add(i, 0x01)
            } {
                // 在榜?
                if eq(adr, sload(add(tmp, i))) {
                    bol := 0x01
                    break
                }
            }
        }
    }

    function getTop5(uint256 nod)
        external
        view
        returns (
            address,
            address,
            address,
            address,
            address
        )
    {
        assembly {
            // 相应内存
            mstore(0x00, TP5)
            mstore(0x20, nod)
            let tmp := keccak256(0x00, 0x40)

            // 手动比循环便宜
            mstore(0x80, sload(tmp))
            mstore(0xa0, sload(add(tmp, 0x01)))
            mstore(0xc0, sload(add(tmp, 0x02)))
            mstore(0xe0, sload(add(tmp, 0x03)))
            mstore(0x0100, sload(add(tmp, 0x04)))
            return(0x80, 0xa0)
        }
    }

    function _setTop5(address top) internal {
        assembly {
            mstore(0x00, top)
            let ptr := keccak256(0x00, 0x20)
            let tmp := add(ptr, 0x02)
            // mintedCount++
            sstore(tmp, add(sload(tmp), 0x01))
            tmp := add(ptr, 0x01)
            let nod := sload(tmp)

            // set not if not exist
            if iszero(nod) {
                mstore(0x00, timestamp())
                mstore(0x20, caller())
                nod := add(mod(keccak256(0x00, 0x40), sload(ER5)), sload(ER3))
                sstore(tmp, nod)
                let num := add(ER5, nod)
                sstore(num, add(sload(num), 0x01))
            }

            // 相应内存
            mstore(0x00, TP5)
            mstore(0x20, nod)
            tmp := keccak256(0x00, 0x40)
            let ind
            let lwt := ETF

            for {
                let i
            } lt(i, 0x05) {
                i := add(i, 0x01)
            } {
                // 找前5最小
                let adr := sload(add(tmp, i))
                // 已上榜
                if eq(adr, top) {
                    return(0x00, 0x00)
                }
                mstore(0x00, adr)
                // 查balanceOf()
                ptr := sload(add(keccak256(0x00, 0x20), 0x02))
                if lt(ptr, lwt) {
                    ind := i
                    lwt := ptr
                }
            }

            mstore(0x00, top)
            // if(balanceOf(msg.sender) > min)
            if gt(sload(keccak256(0x00, 0x20)), lwt) {
                sstore(add(tmp, ind), top)
            }
        }
    }
}
