// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import {Hashes} from "../Util/Hashes.sol";

contract GameActive is Hashes {
    constructor() payable {}
    
    function gameActive(address adr) internal view {
        assembly {
            // (bool isActive, uint256 amtPool) = Node(adr).games(mer);
            mstore(
                0x80,
                0x79131a1900000000000000000000000000000000000000000000000000000000
            )
            mstore(0x84, adr)
            pop(staticcall(gas(), sload(TP5), 0x80, 0x24, 0x00, 0x40))
            // require(isActive || amtPool >= MAC);
            if and(iszero(mload(0x00)), lt(mload(0x20), sload(ER5))) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER1)
                revert(0x80, 0x64)
            }
        }
    }
}
