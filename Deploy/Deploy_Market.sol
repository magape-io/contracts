// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Upgrade} from "../Deploy/Upgrade.sol";
import {Market} from "../Market/Market.sol";

contract Marketplace is Upgrade(address(new Market())) {
    constructor() {
        assembly {
            sstore(ER5, 0x57712Ed608cB7470DBBce3F2E0643588bE7CF50f) // node address
            sstore(TTF, 0xC376Ef652f7559eE5cA942663d90242225309027) // $MAC address
        }
    }
}
