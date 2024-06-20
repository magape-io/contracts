// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Upgrade} from "../Deploy/Upgrade.sol";
import {Market} from "../Market/Market_new.sol";

// import {MAC} from "../GameAsset/MAC.sol";
// import {Node} from "../Governance/Node.sol";

contract Marketplace is Upgrade(address(0x00)) {
    constructor() {
        address adr = address(new Market());
        assembly {
            sstore(ER5, 0xd73d9339b38c462cC41DB4548f67Dd6774326866) // node address
            sstore(TTF, 0x2f75Bf420A799829D3C4060c1D25EAe8F940fC37) // $MAC address
            sstore(IN2, adr) // implementation address
        }
    }

    // address public NOD_;
    // address public MAC_;

    // constructor() {
    //     address nod = NOD_ = address(new Upgrade(address (new Node())));
    //     address mac = MAC_ = address(new Upgrade(address (new MAC())));
    //     address adr = address(new Market());



    //     assembly {
    //         mstore(
    //             0x80,
    //             0xb88bab2900000000000000000000000000000000000000000000000000000000
    //         )
    //         mstore(0x84, shl(0x05, 0xA34357486224151dDfDB291E13194995c22Df505))
    //         mstore(0xa4, 0x01)
    //         pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00)) // game[505] = true

    //         // MAC(address(mac)).mint();
    //         mstore(
    //             0x80,
    //             0x40c10f1900000000000000000000000000000000000000000000000000000000
    //         )
    //         mstore(0x84, origin())
    //         mstore(0xa4, 0x5955e3bb3e743fec00000)
    //         pop(call(gas(), mac, 0x00, 0x80, 0x44, 0x00, 0x00)) // mint(nod, 6.75m)

    //         sstore(ER5, nod) // node address
    //         sstore(TTF, mac) // $MAC address
    //         sstore(IN2, adr) // implementation address
    //     }
    // }
}
