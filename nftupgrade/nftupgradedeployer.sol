// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import {MAC} from "../GameAsset/MAC.sol";
import {MagApe} from "../GameAsset/MagApe.sol";
import {Node} from "../Governance/Node.sol";
import {Upgrade} from "../Proxy/Upgrade.sol";
import {Hashes} from "../Util/Hashes.sol";
import {CrossChain} from "../CrossChain/CrossChain.sol";
import {Distribute} from "../Market/Distribute.sol";
import {Market} from "../Market/Market.sol";
import "../Vote/VoteTypes.sol";

contract Deployer is Hashes {

    constructor() payable {
        address adr = msg.sender; // owner
        address ad2 = msg.sender; // signer
        address ad3 = msg.sender; // game

        (
            Upgrade mac,
            Upgrade mag,
            Upgrade nod,
            Upgrade crc,
            Upgrade are,
            Upgrade mkt,
            GameAdd vo1,
            GameRemove vo2,
            WithdrawBulk vo3
        ) = (
                new Upgrade(address(new MAC())),
                new Upgrade(address(new MagApe())),
                new Upgrade(address(new Node())),
                new Upgrade(address(new CrossChain())),
                new Upgrade(address(new Distribute())),
                new Upgrade(address(new Market())),
                new GameAdd(),
                new GameRemove(),
                new WithdrawBulk()
            );

        assembly {
            sstore(0x01, nod)
            sstore(0x02, mag)
            sstore(0x03, mac)
            sstore(0x04, crc)
            sstore(0x05, are)
            sstore(0x06, mkt)

            // MAC(address(mac)).mint();
            mstore(
                0x80,
                0x40c10f1900000000000000000000000000000000000000000000000000000000
            )
            mstore(0x84, nod)
            mstore(0xa4, 0x5955e3bb3e743fec00000)
            pop(call(gas(), mac, 0x00, 0x80, 0x44, 0x00, 0x00)) // mint(nod, 6.75m)
            mstore(0x84, adr)
            mstore(0xa4, 0x108b2a2c2802909400000)
            pop(call(gas(), mac, 0x00, 0x80, 0x44, 0x00, 0x00)) // mint(adr, 1.25m)
            mstore(0x84, mag)
            mstore(0xa4, 0x1a784379d99db42000000)
            pop(call(gas(), mac, 0x00, 0x80, 0x44, 0x00, 0x00)) // mint(mag, 2m)

            // Upgrade(mag).mem(APP, adr);
            mstore(
                0x80,
                0xb88bab2900000000000000000000000000000000000000000000000000000000
            )

            // Upgrade(mag).mem(APP, ad2);
            mstore(0x84, APP)
            mstore(0xa4, ad2)
            pop(call(gas(), mag, 0x00, 0x80, 0x44, 0x00, 0x00)) // mag.signer = ad2
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00)) // nod.signer = ad2

            // Upgrade(mag).mem(ER4, str);
            mstore(0x84, ER4)
            mstore(0xa4, 0x14)
            pop(call(gas(), mag, 0x00, 0x80, 0x44, 0x00, 0x00)) // mag.uri1 = len
            mstore(0x84, add(ER4, 0x01))
            mstore(
                0xa4,
                0x68747470733a2f2f672e6d61676170652e696f2f000000000000000000000000 // testnets
            )
            pop(call(gas(), mag, 0x00, 0x80, 0x44, 0x00, 0x00)) // mag.uri2 = str1

            // Upgrade(nod).mem(adr << 5, true);
            mstore(0x84, shl(0x05, ad3))
            mstore(0xa4, 0x01)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00)) // game[ad3] = true

            /*** 
            TO ADD MORE GAMES
            LIVE: REMOVE START
            ***/
            mstore(0x84, shl(0x05, 0x4D11dF920E0E48c7E132e5a9754C7e754Cd6EBFB))
            mstore(0xa4, 0x01)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00)) // game[game2] = true

            mstore(0x84, shl(0x05, 0x40f0de13ff4454f2dc786e38504cf4efc2dd12ca))
            mstore(0xa4, 0x01)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00)) // game[game3] = true
            /***
            LIVE: REMOVE END
            ***/

            // Upgrade(nod).mem(TTF, gg2);
            mstore(0x84, TTF)
            mstore(0xa4, mac)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00)) // nod.MAC = mac
            pop(call(gas(), crc, 0x00, 0x80, 0x44, 0x00, 0x00)) // crc.MAC = mac
            pop(call(gas(), mag, 0x00, 0x80, 0x44, 0x00, 0x00)) // mag.MAC = mac

            // Upgrade(nod).mem(TP5, mag);
            mstore(0x84, TP5)
            mstore(0xa4, mag)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00)) // nod.MAG = mag
            pop(call(gas(), crc, 0x00, 0x80, 0x44, 0x00, 0x00)) // crc.MAG = mag

            // Upgrade(mag).mem(ER5, 0x0c);
            mstore(0x84, ER5)
            mstore(0xa4, 0x4563918244f40000)
            pop(call(gas(), crc, 0x00, 0x80, 0x44, 0x00, 0x00)) // crc.tkn = 5e18
            mstore(0xa4, 0x01)
            pop(call(gas(), mag, 0x00, 0x80, 0x44, 0x00, 0x00)) // mag.totalNodes = 1

            // Upgrade(mag).mem(ER3, 0x01)
            mstore(0x84, ER3)
            mstore(0xa4, 0x01)
            pop(call(gas(), mag, 0x00, 0x80, 0x44, 0x00, 0x00)) // mag.nodeAdjust = 1

            // Upgrade(nod).mem(vo_, ad_);
            mstore(0x84, 0x01)
            mstore(0xa4, vo1)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00)) // nod.voteTypes[1] = vo1
            mstore(0x84, 0x02)
            mstore(0xa4, vo2)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00)) // nod.voteTypes[2] = vo2
            mstore(0x84, 0x03)
            mstore(0xa4, vo3)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00)) // nod.voteTypes[3] = vo3

            // Upgrade(are).mem(TFM, 0x05);
            mstore(0x84, TFM)
            mstore(0xa4, 0x05)
            pop(call(gas(), are, 0x00, 0x80, 0x44, 0x00, 0x00)) // are.fee = 5 (20%)

            // Upgrade(mkt).mem(___, adr);
            mstore(0x84, ER5)
            mstore(0xa4, nod)
            pop(call(gas(), mkt, 0x00, 0x80, 0x44, 0x00, 0x00)) // mkt.node = nod
            mstore(0x84, TTF)
            mstore(0xa4, mac)
            pop(call(gas(), mkt, 0x00, 0x80, 0x44, 0x00, 0x00)) // mkt.node = nod

            // Upgrade(___).mem(OWO, adr);
            mstore(0x84, OWO)
            mstore(0xa4, adr)
            pop(call(gas(), nod, 0x00, 0x80, 0x44, 0x00, 0x00)) // nod.owner = adr
            pop(call(gas(), mac, 0x00, 0x80, 0x44, 0x00, 0x00)) // mac.owner = adr
            pop(call(gas(), mag, 0x00, 0x80, 0x44, 0x00, 0x00)) // mag.owner = adr
            pop(call(gas(), crc, 0x00, 0x80, 0x44, 0x00, 0x00)) // crc.owner = adr
            pop(call(gas(), are, 0x00, 0x80, 0x44, 0x00, 0x00)) // are.owner = adr
            pop(call(gas(), mkt, 0x00, 0x80, 0x44, 0x00, 0x00)) // mkt.owner = adr
        }
    }

    function contractAddresses()
        external
        view
        returns (
            address nod,
            address mag,
            address mac,
            address crc,
            address are,
            address mkt
        )
    {
        assembly {
            nod := sload(0x01)
            mag := sload(0x02)
            mac := sload(0x03)
            crc := sload(0x04)
            are := sload(0x05)
            mkt := sload(0x06)
        }
    }
}
