// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import {Top5} from "../Governance/Top5.sol";
import {ECDSA} from "../Util/ECDSA.sol";
import {Ownable} from "../Util/Ownable.sol";
import {NFTFee} from "../GameAsset/NFTFee.sol";

contract Attachment is ECDSA, NFTFee, Top5, Ownable {
    event MetadataUpdate(uint256);

    constructor() payable {}

    function _mint(address adr) private {
        assembly {
            let tid := add(sload(INF), 0x01) // count++
            sstore(INF, tid)

            mstore(0x00, adr) // balanceOf(msg.sender)++
            let tmp := keccak256(0x00, 0x20)
            sstore(tmp, add(sload(tmp), 0x01))

            mstore(0x00, tid) // ownerOf[tid] = msg.sender
            sstore(keccak256(0x00, 0x20), adr)

            log4(0x00, 0x00, ETF, 0x00, adr, tid) // emit Transfer()
        }
    }

    function _transfer(uint256 amt) private {
        assembly {
            // ERC20(TTF).transfer(msg.sender, amt);
            mstore(0x80, TTF)
            mstore(0x84, caller())
            mstore(0xa4, amt)
            amt := call(gas(), sload(TTF), 0x00, 0x80, 0x44, 0x00, 0x00)
        }
    }

    // mini game rewards
    function miniGame(
        uint256 amt,
        uint256 len,
        uint256 bid,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external payable {
        unchecked {
            for (uint256 i; i < len; ++i) _mint(msg.sender);
        }
        if (amt > 0x00) _transfer(amt);
        isVRS(amt, len, bid, v, r, s);
        _setTop5(msg.sender);
    }

    // paid minting
    function mint(
        uint256 amt,
        uint256 len,
        uint256 bid,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external payable {
        unchecked {
            for (uint256 i; i < len; ++i) _mint(msg.sender);
        }
        if (amt > 0x00) _pay(amt);
        isVRS(amt, len, bid, v, r, s);
        _setTop5(msg.sender);
    }

    // admin minting
    function mint(address adr, uint256 amt) external payable onlyOwner {
        unchecked {
            for (uint256 i; i < amt; ++i) _mint(adr);
        }
        _setTop5(adr);
    }

    // destory of tokens (no reward)
    function burn(uint256 tid) public payable notBan0 {
        assembly {
            // ownerOf(tid)
            mstore(0x00, tid)
            let ptr := keccak256(0x00, 0x20)
            let frm := sload(ptr)

            // require(ownerOf(tid) == msg.sender)
            if iszero(eq(frm, caller())) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER2)
                revert(0x80, 0x64)
            }

            sstore(ptr, 0x00) // ownerOf[id] = toa
            sstore(add(ptr, 0x01), 0x00) // approve[tid] = toa

            mstore(0x00, frm) // --balanceOf(msg.sender)
            let tmp := keccak256(0x00, 0x20)
            sstore(tmp, sub(sload(tmp), 0x01))

            log4(0x00, 0x00, ETF, frm, 0x00, tid) // emit Transfer(frm, address(0), tid)
        }
    }

    // destory of tokens (with rewards)
    function dust(
        uint256[] calldata ids,
        uint256 amt,
        uint256 bid,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external payable {
        _transfer(amt);
        unchecked {
            for (uint256 i; i < ids.length; ++i) burn(ids[i]);
        }
        isVRS(amt, 0, bid, v, r, s);
    }

    // burn and mint
    function merge(
        uint256[] calldata ids,
        uint256 amt,
        uint256 bid,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external payable {
        uint256 num;
        unchecked {
            for (uint256 i; i < ids.length; ++i) {
                burn(ids[i]);
                num += ids[i];
            }
        }
        _mint(msg.sender);
        if (amt > 0) _pay(amt);
        isVRS(amt, num, bid, v, r, s);
    }

    // metadata update
    function upgrade(
        uint256 tid,
        uint256 amt,
        uint256 bid,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external payable {
        assembly {
            // emit MetadataUpdate(tid)
            mstore(0x00, tid)
            log1(
                0x00,
                0x20,
                0xf8e1a15aba9398e019f0b49df1a4fde98ee17ae345cb5f6b5e2c27f5033e8ce7
            )
        }
        if (amt > 0) _pay(amt);
        isVRS(amt, 0, bid, v, r, s);
    }
}
