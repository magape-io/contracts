/*
Remotely write to contract using byte code and read contracts with
return value as byte code
*/

// SPDX-License-Identifier: None
pragma solidity 0.8.0;

contract Remote {
    function write(address adr, bytes memory byt) external {
        assembly {
            pop(call(gas(), adr, 0x00, add(byt, 0x20), mload(byt), 0x00, 0x00))
        }
    }

    function read(address adr, bytes memory byt)
        external
        view
        returns (bytes memory)
    {
        assembly {
            pop(staticcall(gas(), adr, add(byt, 0x20), mload(byt), 0x00, 0x00))

            let sze := returndatasize()
            let ptr := mload(0x40)
            returndatacopy(add(0x40, ptr), 0x00, sze)

            mstore(ptr, 0x20)
            mstore(add(0x20, ptr), sze)
            return(ptr, add(0x40, sze))
        }
    }
}
