// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Upgrade} from "../Deploy/Upgrade.sol";
import {Distribute} from "../Market/Distribute.sol";

contract Arena is Upgrade(address(0x00)) {
    constructor() {
        address dis = address(new Distribute());
        assembly {
            sstore(TFM, 0x05) // fee = 20%
            sstore(IN2, dis)
        }
    }
}
