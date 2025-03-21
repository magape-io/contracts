// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import {Ownable} from "../Util/Ownable.sol";

contract Upgrade is Ownable {
    constructor(address adr) payable {
        assembly {
            sstore(IN2, adr) // implementation = adr;
        }
    }

    fallback() external payable {
        assembly {
            calldatacopy(0x00, 0x00, calldatasize())
            let res := delegatecall(
                gas(),
                sload(IN2),
                0x00,
                calldatasize(),
                0x00,
                0x00
            )
            let sze := returndatasize()
            returndatacopy(0x00, 0x00, sze)
            if iszero(res) {
                revert(0x00, sze)
            }
            return(0x00, sze)
        }
    }

    receive() external payable {
        assembly {
            calldatacopy(0x00, 0x00, calldatasize())
            let res := delegatecall(
                gas(),
                sload(IN2),
                0x00,
                calldatasize(),
                0x00,
                0x00
            )
            let sze := returndatasize()
            returndatacopy(0x00, 0x00, sze)
            if iszero(res) {
                revert(0x00, sze)
            }
            return(0x00, sze)
        }
    }

    function implementation() external view returns (address adr) {
        assembly {
            adr := sload(IN2)
        }
    }

    function mem(bytes32 byt) external view returns (bytes32 val) {
        assembly {
            val := sload(byt)
        }
    }

    function mem(bytes32 byt, bytes32 val) public payable onlyOwner {
        assembly {
            sstore(byt, val)
        }
    }

    function mem(bytes32[] memory byt, bytes32[] memory val)
        external
        payable
        onlyOwner
    {
        assembly {
            let len := add(mul(mload(byt), 0x20), 0x20)
            for {
                let i := 0x20
            } lt(i, len) {
                i := add(i, 0x20)
            } {
                sstore(mload(add(byt, i)), mload(add(val, i)))
            }
        }
    }
}
