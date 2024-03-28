// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Hashes} from "../Util/Hashes.sol";

contract CrossChain is Hashes {
    event CrossTKN(uint256 indexed, uint256 indexed, address indexed, uint256);
    event CrossNFT(uint256 indexed, uint256 indexed, address indexed, uint256);

    function isOverwritten(address adr)
        external
        view
        returns (
            /*bool coi,
            uint256 amt,*/
            bool tkn,
            uint256 bal
        )
    {
        assembly {
            mstore(0x00, adr)
            let ptr := keccak256(0x00, 0x20)
            /*coi := sload(ptr)
            amt := sload(add(ptr, 0x01))*/
            tkn := sload(add(ptr, 0x02))
            bal := sload(add(ptr, 0x03))
        }
    }

    function _tokenBurnWithFee(uint256 amt) private {
        assembly {
            mstore(0x00, caller()) // user's pointer
            let usr := keccak256(0x00, 0x20)

            /***
            // can uncomment this if admin is minting on behalf
            // and if want to offset the gas fee
            // may omit since user paying own minting fee
            // inclusive fee in gas
            let wei
            switch gt(sload(usr), 0x00)
            case 0x00 { wei := sload(TFM) } // default value
            default {wei := sload(add(usr, 0x01)) } // overwrite value

            if gt(wei, callvalue()) { // require(msg.value >= amt)
                mstore(0x80, ERR) 
                mstore(0xa0, STR)
                mstore(0xc0, ER5)
                revert(0x80, 0x64)
            }

            pop(call(gas(), sload(OWO), selfbalance(), 0x00, 0x00, 0x00, 0x00)) // transfer to admin
            ***/

            // inclusive fee in token
            // check for fee overwrite
            switch sload(add(usr, 0x02))
            case 0x00 {
                // default value
                amt := add(amt, sload(ER5))
            }
            default {
                // overwrite value
                amt := add(amt, sload(add(usr, 0x03)))
            }
        }
        _transferAndBurn(TTF, amt);
    }

    function _transferAndBurn(bytes32 byt, uint256 num) private {
        assembly {
            let tkn := sload(byt)

            // require(Asset(tkn).transferForm(msg.sender, to, fee))
            mstore(0x80, TFM)
            mstore(0x84, caller())
            mstore(0xa4, address())
            mstore(0xc4, num)
            if iszero(call(gas(), tkn, 0x00, 0x80, 0x64, 0x00, 0x00)) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER2)
                revert(0x80, 0x64)
            }

            // Asset(tkn).burn(amt)
            mstore(0x80, 0x42966c6800000000000000000000000000000000000000000000000000000000)
            mstore(0x84, num)
            pop(call(gas(), tkn, 0x00, 0x80, 0x24, 0x00, 0x00))
        }
    }

    function transferTKN(
        uint256 toChain,
        address to,
        uint256 amt
    ) external payable {
        assembly {
            mstore(0x00, amt) // emit CrossTKN(block.chainid, toChain, to, amt);
            log4(
                0x00,
                0x20,
                0x31a11e5f15e0fbf9fa21513afcd0b26821d8524893395636633bdac130be8ce2,
                chainid(),
                toChain,
                to
            )
        }
        _tokenBurnWithFee(amt);
    }

    function transferNFT(
        uint256 toChain,
        address toa,
        uint256 tid
    ) external payable {
        assembly {
            mstore(0x00, tid) // emit CrossNFT(block.chainid, toChain, to, id);
            log4(
                0x00,
                0x20,
                0x65e7d15f348dcceb483e723cc14dc98456634dffec85e8ff9772eae549a6159c,
                chainid(),
                toChain,
                toa
            )
        }
        _tokenBurnWithFee(0x00);
        _transferAndBurn(TP5, tid);
    }
}
