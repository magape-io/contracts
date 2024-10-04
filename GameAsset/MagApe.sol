// SPDX-License-Identifier: None
pragma solidity 0.8.27;

import {Attachment} from "../GameAsset/Attachment.sol";

contract MagApe is Attachment {
    event Transfer(address indexed, address indexed, uint256 indexed);
    event Approval(address indexed, address indexed, uint256 indexed);
    event ApprovalForAll(address indexed, address indexed, bool);

    function supportsInterface(bytes4 a) external pure returns (bool bol) {
        assembly {
            bol := or(eq(a, INF), eq(a, IN2))
        }
    }

    function name() external pure returns (string memory) {
        assembly {
            mstore(0x80, 0x20)
            mstore(0xa0, 0x06)
            mstore(0xc0, "MagApe")
            return(0x80, 0x60)
        }
    }

    function symbol() external pure returns (string memory) {
        assembly {
            mstore(0x80, 0x20)
            mstore(0xa0, 0x06)
            mstore(0xc0, "MagApe")
            return(0x80, 0x60)
        }
    }

    function count() external view returns (uint256 amt) {
        assembly {
            amt := sload(INF)
        }
    }

    function balanceOf(address adr) external view returns (uint256 amt) {
        assembly {
            mstore(0x00, adr)
            amt := sload(keccak256(0x00, 0x20))
        }
    }

    function ownerOf(uint256 tid) external view returns (address adr) {
        assembly {
            mstore(0x00, tid)
            adr := sload(keccak256(0x00, 0x20))
        }
    }

    function _uint2Str(uint256 tid) private pure returns (string memory str) {
        assembly {
            let byt
            let len
            if eq(tid, 0x00) {
                byt := 0x3000000000000000000000000000000000000000000000000000000000000000
                len := 0x01
            }
            for {

            } gt(tid, 0x00) {
                len := add(len, 0x01)
            } {
                byt := div(byt, 0x0100)
                byt := or(
                    byt,
                    mul(
                        add(mod(tid, 0x0a), 0x30),
                        0x100000000000000000000000000000000000000000000000000000000000000
                    )
                )
                tid := div(tid, 0x0a)
            }

            str := mload(0x40)
            mstore(0x40, add(str, 0x40))
            mstore(str, len)
            mstore(add(str, 0x20), byt)
        }
    }

    function tokenURI(uint256 tid) external view returns (string memory str) {
        assembly {
            let pos := 0x01
            str := mload(0x40)
            mstore(str, sload(ER4))

            for {
                let i := add(mload(str), 0x20)
            } gt(i, 0x20) {
                i := sub(i, 0x20)
            } {
                mstore(add(str, mul(pos, 0x20)), sload(add(ER4, pos)))
                pos := add(pos, 0x01)
            }
            mstore(0x40, add(str, mul(pos, 0x20)))
        }
        str = string(abi.encodePacked(str, _uint2Str(tid)));
    }

    function getApproved(uint256 tid) external view returns (address adr) {
        assembly {
            mstore(0x00, tid)
            adr := sload(add(keccak256(0x00, 0x20), 0x01))
        }
    }

    function isApprovedForAll(address frm, address toa)
        external
        view
        returns (bool bol)
    {
        assembly {
            mstore(0x00, frm)
            mstore(0x20, toa)
            bol := sload(keccak256(0x00, 0x40))
        }
    }

    function approve(address toa, uint256 tid) external {
        assembly {
            mstore(0x00, tid) // ownerOf(tid)
            let tmp := keccak256(0x00, 0x20)
            let oid := sload(tmp)

            mstore(0x00, oid) // isApprovedForAll(oid, msg.sender)
            mstore(0x20, caller())
            mstore(0x00, sload(keccak256(0x00, 0x40)))

            // require(msg.sender == ownerOf(tid) || isApprovedForAll(ownerOf(tid), msg.sender))
            if and(iszero(eq(caller(), oid)), iszero(mload(0x00))) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER1)
                revert(0x80, 0x64)
            }

            sstore(add(tmp, 0x01), toa) // approve[tid] = toa

            log4(0x00, 0x00, EAP, oid, toa, tid) // emit Approval()
        }
    }

    function setApprovalForAll(address toa, bool bol) external {
        assembly {
            mstore(0x00, caller())
            mstore(0x20, toa)
            sstore(keccak256(0x00, 0x40), bol)

            mstore(0x00, bol) // emit ApprovalForAll()
            log3(0x00, 0x20, EAA, caller(), toa)
        }
    }

    function _transfer(address toa, uint256 tid) private {
        address frm;

        assembly {
            mstore(0x00, tid) // ownerOf(tid)
            let ptr := keccak256(0x00, 0x20)
            frm := sload(ptr)

            mstore(0x00, frm)
            mstore(0x20, caller())
            let tmp := sload(keccak256(0x00, 0x40))

            let app := add(ptr, 0x01)

            // require(getApproved(tid) == toa || ownerOf(tid) == msg.sender || isApprovedForAll(msg.sender))
            if and(
                and(iszero(eq(sload(app), toa)), iszero(eq(frm, caller()))),
                eq(tmp, 0x00)
            ) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER2)
                revert(0x80, 0x64)
            }

            sstore(ptr, toa) // ownerOf[id] = toa
            sstore(app, 0x00) // approve[tid] = toa

            mstore(0x00, frm) // balanceOf(msg.sender)--
            tmp := keccak256(0x00, 0x20)
            sstore(tmp, sub(sload(tmp), 0x01))

            mstore(0x00, toa) // balanceOf(toa)++
            tmp := keccak256(0x00, 0x20)
            sstore(tmp, add(sload(tmp), 0x01))

            log4(0x00, 0x00, ETF, frm, toa, tid) // emit Transfer()
        }
        notBan2(frm, toa);
    }

    function transferFrom(
        address,
        address toa,
        uint256 tid
    ) external {
        _transfer(toa, tid);
    }

    function safeTransferFrom(
        address,
        address toa,
        uint256 tid
    ) external {
        _transfer(toa, tid);
    }

    function safeTransferFrom(
        address,
        address toa,
        uint256 tid,
        bytes memory
    ) external {
        _transfer(toa, tid);
    }
}
