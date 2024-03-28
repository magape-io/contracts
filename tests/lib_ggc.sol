// SPDX-License-Identifier:None
pragma solidity 0.8.0;

import {Assert} from "remix_tests.sol";
import {Upgrade} from "../Deploy/Upgrade.sol";
import {XAE} from "../GameAsset/XAE.sol";

library Z {
    bytes32 public constant OWO =
        0x6352211e00000000000000000000000000000000000000000000000000000000;
    address public constant AC7 = 0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7;

    string public constant E02 = "contract should not be 0";
    string public constant E03 = "name should not be empty";
    string public constant E04 = "symbol should not be empty";
    string public constant E05 = "decimals should be 18";
    string public constant E06 = "totalSupply should be 0 before mint";
    string public constant E07 = "balance of contract should be 0";
    string public constant E08 = "balance of contract should be 1e20";
    string public constant E09 = "allowance should be 1e19";
    string public constant E10 = "balance of user 7 should be 0";
    string public constant E11 = "balance of user 7 should be 1e18";
    string public constant E12 = "allowance should be 9e18";
    string public constant E13 = "balance of user 7 should be 1e19";
    string public constant E14 = "balance of contract should be 9e19";
    string public constant E15 = "allowance should still be 9e18";
    string public constant E16 = "balance of user 7 should be 2e19";
    string public constant E17 = "total supply should be 11e19";
    string public constant E18 = "owner should be this contract";
    string public constant E19 = "owner should changed to user";
    string public constant E21 = "should throw error";
    string public constant E22 = "balance of contract should be 8e19";
    string public constant E23 = "balance of AC7 should be 2e19";
    string public constant E24 = "balance of contract should be 7e19";
    string public constant E25 = "balance of AC7 should be 3e19";
    string public constant E26 = "balance must change";

    function toBytes32(address a) public pure returns (bytes32) {
        return bytes32(uint256(uint160(a)));
    }

    function toBytes32(uint256 a) public pure returns (bytes32) {
        return bytes32(a);
    }
}
