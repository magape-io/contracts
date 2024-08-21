// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Upgrade} from "../Proxy/Upgrade.sol";
import {Market} from "../Market/Market.sol";

contract Marketplace is Upgrade(address(new Market())) {
    constructor() payable {
        assembly {
            sstore(ER5, 0x54ea7794f11464E4f81750c92dbfCd9a758b7D05) // node address
            sstore(TTF, 0xF04ebA6b2dD3De0CEe1fD024A7222071E2076492) // $MAC address
        }
    }
}
