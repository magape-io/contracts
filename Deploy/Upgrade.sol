// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Ownable} from "../Util/Ownable.sol";

contract Upgrade is Ownable {
    constructor(address adr) {
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
            switch res
            case 0 {
                revert(0x00, sze)
            }
            default {
                return(0x00, sze)
            }
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
            switch res
            case 0 {
                revert(0x00, sze)
            }
            default {
                return(0x00, sze)
            }
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

    function mem(bytes32 byt, bytes32 val) external onlyOwner {
        assembly {
            sstore(byt, val)
        }
    }
}
