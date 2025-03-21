// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import {Hashes} from "../Util/Hashes.sol";

contract Ownable is Hashes {
    modifier onlyOwner() {
        assembly {
            if iszero(eq(caller(), sload(OWO))) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER1)
                revert(0x80, 0x64)
            }
        }
        _;
    }

    constructor() payable {
        assembly {
            sstore(OWO, caller()) // owner = msg.sender
        }
    }

    function owner() public view returns (address adr) {
        assembly {
            adr := sload(OWO)
        }
    }
}
