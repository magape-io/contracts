// SPDX-License-Identifier:None
pragma solidity 0.8.0;

import {Assert} from "remix_tests.sol";
import {Upgrade} from "../Deploy/Upgrade.sol";
import {CrossChain} from "../CrossChain/CrossChain.sol";
import {XAE} from "../GameAsset/XAE.sol";
import {XAPE} from "../GameAsset/XAPE.sol";

library Z {
    bytes32 public constant TTF =
        0xa9059cbb00000000000000000000000000000000000000000000000000000000;
    bytes32 public constant TP5 =
        0x2fea05d400000000000000000000000000000000000000000000000000000000;
    bytes32 public constant APP =
        0x095ea7b300000000000000000000000000000000000000000000000000000000;
    bytes32 public constant ER5 =
        0x00000007616d7420657272000000000000000000000000000000000000000000;
    bytes32 public constant TFM =
        0x23b872dd00000000000000000000000000000000000000000000000000000000;

    address public constant AC7 = 0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7;
    address public constant ADM = 0xA34357486224151dDfDB291E13194995c22Df505;

    string public constant E01 = "contract should not be 0";
    string public constant E02 = "ggc and item address should be set";
    string public constant E03 = "balance should be minted amount";
    string public constant E04 = "balance should be deducted";
    string public constant E05 = "total supply should be deducted";
    string public constant E31 = "should throw error";

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
}
