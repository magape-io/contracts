// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Upgrade} from "../Deploy/Upgrade.sol";
import {Market} from "../Market/Market.sol";

contract Marketplace is Upgrade(address(new Market())) {
    constructor() payable {
        assembly {
            sstore(ER5, 0x7Aa858A3Dc72caDDe3D52Fe791Bd9f0BdC7C4304) // node address
            sstore(TTF, 0xf4B1Bff3BCfd0b394e8eD7D348Cb5d79A53840FD) // $MAC address
        }
    }
}
