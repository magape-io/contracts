// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Upgrade} from "../Deploy/Upgrade.sol";
import {Market} from "../Market/Market.sol";

contract Marketplace is Upgrade(address(new Market())) {
    constructor() {
        assembly {
            sstore(ER5, 0x0AD61A3312aB48d24B714DB368d2F9AE03A39f31) // node address
            sstore(TTF, 0x281Ff91326C020206D8B472c4De657413a35829D) // $MAC address
        }
    }
}
