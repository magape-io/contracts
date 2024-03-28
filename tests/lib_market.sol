// SPDX-License-Identifier:None
pragma solidity 0.8.0;

import {Assert} from "remix_tests.sol";
import {Upgrade} from "../Deploy/Upgrade.sol";
import {Market} from "../Market/Market.sol";
import {XAPE} from "../GameAsset/XAPE.sol";
import {XAE} from "../GameAsset/XAE.sol";

library Z {
    address public constant AC7 = 0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7;
    address public constant ADM = 0xA34357486224151dDfDB291E13194995c22Df505;

    bytes32 public constant APP =
        0x095ea7b300000000000000000000000000000000000000000000000000000000;
    bytes32 public constant TFM =
        0x23b872dd00000000000000000000000000000000000000000000000000000000;
    bytes32 public constant R =
        0x451487bb930cb3bda5170b73cdbec957c7669592809de8a278256ac95fdf4cf4;
    bytes32 public constant S =
        0x04fa784da9ad6f41766e09a789aaac8281cb68c7d8323b212a4675060181046d;

    string public constant STR =
        "ifps://QmNvWjdSxcXDzevFNYw46QkNvuTEod1FF8Le7GYLxWAavk";
    string public constant E01 = "contract should not be 0";
    string public constant E02 = "listing of ggc should exist";
    string public constant E03 = "owner of should change";
    string public constant E04 = "balance of should increase";
    string public constant E05 = "seller should be getting amt less fee";
    string public constant E06 = "onwer should be getting the fee";

    function resetCounter(Upgrade a) public {
        // reset counter
        bytes32 ptr;
        assembly {
            mstore(0x00, origin())
            ptr := add(keccak256(0x00, 0x20), 0x01)
        }
        a.mem(ptr, bytes32(0));
    }

    function toBytes32(address a) public pure returns (bytes32) {
        return bytes32(uint256(uint160(a)));
    }

    function toBytes32(uint256 a) public pure returns (bytes32) {
        return bytes32(a);
    }

    function getKeccak(bytes32 a, bytes32 b) public pure returns (bytes32) {
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            mstore(0x00, keccak256(0x00, 0x40))
            return(0x00, 0x20)
        }
    }
}
