// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Hashes} from "../Util/Hashes.sol";

contract GameAdd is Hashes {
    function vote(uint256 ind, bool vot) external {
        assembly {
            // emit Vote(cnt, vot+=4);
            mstore(0x00, add(vot, 0x04))
            log2(0x00, 0x20, EVO, ind)

            mstore(0x00, ind)
            let ptr := keccak256(0x00, 0x20)
            let up
            let down

            // searching for empty slots
            let tmp
            for {
                let i := ptr
            } lt(i, add(ptr, 0x05)) {
                i := add(i, 0x01)
            } {
                let sli := sload(i)

                // stop and fill if empty slot found
                if iszero(sli) {
                    tmp := i
                    break
                }

                // calculate total up and down votes
                if gt(sli, 0x00) {
                    switch gt(sli, STR)
                    case 1 {
                        up := add(up, 0x01) // ++up;

                        // reset 1st byte to get address
                        mstore(0x00, sli)
                        mstore8(0x00, 0x00)
                        sli := mload(0x00)
                    }
                    default {
                        down := add(down, 0x01) // ++down;
                    }
                }

                // stop if voted
                if eq(sli, caller()) {
                    tmp := 0x00
                    break
                }
            }

            // (bool top5, uint256 nod) = MagApe(TP5).isTop5(msg.sender);
            mstore(0x00, TP5)
            mstore(0x04, caller())
            pop(staticcall(gas(), sload(TP5), 0x00, 0x24, 0x00, 0x40))

            let sta := add(0x05, ptr)
            // require(top5 && nod == vote[ind].node && tmp > 0);
            if or(or(iszero(mload(0x00)), iszero(eq(mload(0x20), sload(add(ptr, 0x08))))), iszero(tmp)) {
                revert(0x00, 0x00)
            }

            // vote[ind].voters.push(abi.encodePacked(vot, msg.sender));
            mstore(0x00, caller())
            mstore8(0x00, vot)
            sstore(tmp, mload(0x00))

            // if voting reaching a conclusion
            if or(eq(up, 0x02), eq(down, 0x02)) {
                switch vot
                case 0x00 {
                    down := add(down, 0x01) // ++down;
                }
                default {
                    up := add(up, 0x01) // ++up;
                }

                mstore(0x00, 0x07) // default emit: voting failed

                // if voting is successful
                if gt(up, 0x02) {
                    // game[vote[ind].receipient] = true;
                    sstore(shl(0x05, sload(add(ptr, 0x06))), 0x01)
                    mstore(0x00, 0x06) // emit: voting successful
                }

                // vote[ind].status = 0;
                sstore(sta, 0x00)

                // emit Vote(cnt, 6/7)
                log2(0x00, 0x20, EVO, ind)
            }
        }
    }
}
