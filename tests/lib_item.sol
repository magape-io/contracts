// SPDX-License-Identifier:None
pragma solidity 0.8.0;

import {Assert} from "remix_tests.sol";
import {Upgrade} from "../Deploy/Upgrade.sol";
import {XAPE} from "../GameAsset/XAPE.sol";
import {XAE} from "../GameAsset/XAE.sol";

library Z {
    bytes4 public constant B4a = 0x80ac58cd;
    bytes4 public constant B4b = 0x5b5e139f;

    address public constant AC7 = 0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7;
    address public constant AC9 = 0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC;
    address public constant ADM = 0xA34357486224151dDfDB291E13194995c22Df505;

    bytes32 public constant APP =
        0x095ea7b300000000000000000000000000000000000000000000000000000000;
    bytes32 public constant AFA =
        0xe985e9c500000000000000000000000000000000000000000000000000000001;
    bytes32 public constant AF2 =
        0xe985e9c500000000000000000000000000000000000000000000000000000002;
    bytes32 public constant TFM =
        0x23b872dd00000000000000000000000000000000000000000000000000000000;
    bytes32 public constant R =
        0x451487bb930cb3bda5170b73cdbec957c7669592809de8a278256ac95fdf4cf4;
    bytes32 public constant S =
        0x04fa784da9ad6f41766e09a789aaac8281cb68c7d8323b212a4675060181046d;
    bytes32 public constant R2 =
        0x0ccfb6183f320d729454803b899292650e52a259ec5b0bbfa2650a916f413642;
    bytes32 public constant S2 =
        0x33d6ba808c25541419deb2302fb2573595444d0fa59103142c8a32f5dc6ae958;

    string public constant E02 = "adr>0";
    string public constant E03 = "name!=''";
    string public constant E04 = "sym!=''";
    string public constant E05 = "cnt=0";
    string public constant E06 = "inf";
    string public constant E07 = "TIS==0";
    string public constant E08 = "ID1==null";
    string public constant E09 = "uri.len==53";
    string public constant E10 = "sig!=0";
    string public constant E11 = "TIS>0";
    string public constant E12 = "ID1==TIS";
    string public constant E13 = "uri==STR";
    string public constant E14 = "TIS==0";
    string public constant E15 = "ID11==TIS";
    string public constant E16 = "AC9!=app";
    string public constant E17 = "AC9==app";
    string public constant E18 = "ID3==AC7";
    string public constant E19 = "AC7==0";
    string public constant E20 = "AC7==1";
    string public constant E21 = "TIS==1";
    string public constant E22 = "ID3==null";
    string public constant E23 = "AC7==1";
    string public constant E24 = "AC7==4";
    string public constant E25 = "TIS==7";
    string public constant E26 = "ID1==AC7";
    string public constant E27 = "TIS==6";
    string public constant E28 = "TIS==5";
    string public constant E29 = "uri==mer";
    string public constant E30 = "uri==upg";
    string public constant E31 = "should throw error";
    string public constant E32 = "ID9==0";
    string public constant E33 = "TIS==4";
    string public constant E34 = "AC7==5";
    string public constant E35 = "TIS==3";
    string public constant E36 = "AC7==6";
    string public constant E37 = "balance should increase";
    string public constant E38 = "balance should be amt";

    function resetCounter(Upgrade a) public {
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
}
