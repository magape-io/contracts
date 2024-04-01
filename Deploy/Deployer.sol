// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {MAC} from "../GameAsset/MAC.sol";
import {Magape} from "../GameAsset/Magape.sol";
import {Node} from "../Governance/Node.sol";
import {Upgrade} from "../Deploy/Upgrade.sol";
import {Hashes} from "../Util/Hashes.sol";
import {CrossChain} from "../CrossChain/CrossChain.sol";
import "../Vote/VoteTypes.sol";

contract Deployer is Hashes {
    constructor(
        address adr,
        address ad2,
        address ad3
    ) {
        (
            Upgrade mac,
            Upgrade mag,
            Upgrade nod,
            Upgrade crc,
            GameAdd vo1,
            GameRemove vo2,
            WithdrawBulk vo3
        ) = (
                new Upgrade(address(new MAC())),
                new Upgrade(address(new Magape())),
                new Upgrade(address(new Node())),
                new Upgrade(address(new CrossChain())),
                new GameAdd(),
                new GameRemove(),
                new WithdrawBulk()
            );

        assembly {
            sstore(0x01, nod)
            sstore(0x02, mag)
            sstore(0x03, mac)
            sstore(0x04, crc)

            mstore(
                0x80,
                0x40c10f1900000000000000000000000000000000000000000000000000000000
            )
            mstore(0x84, nod)
            mstore(0xa4, 0x5955e3bb3e743fec00000)
            pop(call(gas(), mac, 0x00, 0x80, 0x44, 0x00, 0x00))
            mstore(0x84, adr)
            mstore(0xa4, 0x108b2a2c2802909400000)
            pop(call(gas(), mac, 0x00, 0x80, 0x44, 0x00, 0x00))
            mstore(0x84, mag)
            mstore(0xa4, 0x1a784379d99db42000000)
            pop(call(gas(), mac, 0x00, 0x80, 0x44, 0x00, 0x00))

            mstore(
                0x80,
                0xb88bab2900000000000000000000000000000000000000000000000000000000
            )

            mstore(0x84, APP)
            mstore(0xa4, ad2)
            pop(call(gas(), mag, 0x00, 0x80, 0x44, 0x00, 0x00))
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00))

            mstore(0x84, ER4)
            mstore(0xa4, 0x59)
            pop(call(gas(), mag, 0x00, 0x80, 0x44, 0x00, 0x00))
            mstore(0x84, add(ER4, 0x01))
            mstore(
                0xa4,
                0x68747470733a2f2f776879696e6469616e2e64646e732e6e65742f69706e732f
            )
            pop(call(gas(), mag, 0x00, 0x80, 0x44, 0x00, 0x00))
            mstore(0x84, add(ER4, 0x02))
            mstore(
                0xa4,
                0x6b326b3472386a7064656e6869356932686b6461346c76393130303265316a64
            )
            pop(call(gas(), mag, 0x00, 0x80, 0x44, 0x00, 0x00))
            mstore(0x84, add(ER4, 0x03))
            mstore(
                0xa4,
                0x6e3668697277327871377364626d6878353264746e62716a2f00000000000000
            )
            pop(call(gas(), mag, 0x00, 0x80, 0x44, 0x00, 0x00))

            mstore(0x84, TTF)
            mstore(0xa4, mac)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00))
            pop(call(gas(), crc, 0x00, 0x80, 0x44, 0x00, 0x00))
            pop(call(gas(), mag, 0x00, 0x80, 0x44, 0x00, 0x00))

            mstore(0x84, TP5)
            mstore(0xa4, mag)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00))
            pop(call(gas(), crc, 0x00, 0x80, 0x44, 0x00, 0x00))
            mstore(0xa4, nod)

            mstore(0x84, ER5)
            mstore(0xa4, 0x4563918244f40000)
            pop(call(gas(), crc, 0x00, 0x80, 0x44, 0x00, 0x00))
            mstore(0xa4, 0x01)
            pop(call(gas(), mag, 0x00, 0x80, 0x44, 0x00, 0x00))

            mstore(0x84, ER3)
            mstore(0xa4, 0x01)
            pop(call(gas(), mag, 0x00, 0x80, 0x44, 0x00, 0x00))

            mstore(0x84, 0x01)
            mstore(0xa4, vo1)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00))
            mstore(0x84, 0x02)
            mstore(0xa4, vo2)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00))
            mstore(0x84, 0x03)
            mstore(0xa4, vo3)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00))

            mstore(0x84, OWO)
            mstore(0xa4, adr)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00))
            mstore(0xa4, nod)
            pop(call(gas(), mac, 0x00, 0x80, 0x44, 0x00, 0x00))
            pop(call(gas(), mag, 0x00, 0x80, 0x44, 0x00, 0x00))
            pop(call(gas(), crc, 0x00, 0x80, 0x44, 0x00, 0x00))
        }
    }

    function contractAddresses()
        external
        view
        returns (
            address nod,
            address mag,
            address mac,
            address crc
        )
    {
        assembly {
            nod := sload(0x01)
            mag := sload(0x02)
            mac := sload(0x03)
            crc := sload(0x04)
        }
    }
}
