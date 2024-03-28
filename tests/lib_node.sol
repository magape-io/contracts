// SPDX-License-Identifier:None
pragma solidity 0.8.0;

import {Assert} from "remix_tests.sol";
import {Upgrade} from "../Deploy/Upgrade.sol";
import {Node} from "../Governance/Node.sol";
import {GGC} from "../GameAsset/GGC.sol";
import {Item} from "../GameAsset/Item.sol";

library Z {
    bytes32 public constant TTF =
        0xa9059cbb00000000000000000000000000000000000000000000000000000000;
    bytes32 public constant TP5 =
        0x2fea05d400000000000000000000000000000000000000000000000000000000;
    bytes32 public constant APP =
        0x095ea7b300000000000000000000000000000000000000000000000000000000;
    bytes32 public constant R =
        0x5568b5565151508fac71ad34cb981e6f3b4e9f0fa75732af4c686a34a0625bbc;
    bytes32 public constant S =
        0x05c363be1f2d552fe17c4cd9df805d14a1b35268d0298b9f2d25a9f689c745a4;

    address public constant AC7 = 0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7;
    address public constant ADM = 0xA34357486224151dDfDB291E13194995c22Df505;

    string public constant E02 = "contract should not be 0";
    string public constant E03 = "address should be sender";
    string public constant E04 = "status should be 2";
    string public constant E05 = "withdrawal amount should be 1e20";
    string public constant E06 = "withdrawal address to should be AC7";
    string public constant E07 = "status should be 0";
    string public constant E08 = "contract balance should be 1e18";
    string public constant E09 = "game should be added and return true";
    string public constant E10 = "node balance should be 995e17";
    string public constant E11 = "msg sender should be in top 5";
    string public constant E12 = "status should be more than 0";
    string public constant E13 = "should throw error";
    string public constant E14 = "game should be removed and return false";
    string public constant E15 = "contract balance should be 1e20";
    string public constant E16 = "game addres should be 1e18";

    function toUint(address a) public pure returns (uint256) {
        return uint256(uint160(a));
    }

    function toBytes32(address a) public pure returns (bytes32) {
        return bytes32(toUint(a));
    }

    function toBytes32(uint256 a) public pure returns (bytes32) {
        return bytes32(a);
    }

    function fmtIndex(uint256 a, uint256 b) public pure returns (bytes32) {
        assembly {
            mstore(0x00, a)
            mstore(0x00, add(keccak256(0x00, 0x20), b))
            return(0x00, 0x20)
        }
    }

    function fmtVote(address a) public pure returns (bytes32) {
        assembly {
            mstore(0x00, a)
            mstore8(0x00, 0x01)
            return(0x00, 0x20)
        }
    }

    function getKeccak(address a, uint256 b) public pure returns (bytes32 c) {
        assembly {
            mstore(0x00, a)
            c := add(keccak256(0x00, 0x20), b)
        }
    }

    function getKeccak(bytes32 a, bytes32 b) public pure returns (bytes32 c) {
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            c := keccak256(0x00, 0x40)
        }
    }

    function resetCounter(Upgrade a) public {
        bytes32 ptr;
        assembly {
            mstore(0x00, origin())
            ptr := add(keccak256(0x00, 0x20), 0x01)
        }
        a.mem(ptr, bytes32(0));
    }
}
