// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Upgrade} from "../Deploy/Upgrade.sol";
import {Market} from "../Market/Market_new.sol";

contract Marketplace is Upgrade(address(0x00)) {
    constructor() {
        address adr = address(new Market());
        assembly {
            sstore(shl(0x05, adr), 0x01) // game address voted
            sstore(shl(0x05, adr), 0x01) // game address voted
            sstore(TTF, adr) // $MAC address
            sstore(IN2, adr) // implementation address
        }
    }
}
