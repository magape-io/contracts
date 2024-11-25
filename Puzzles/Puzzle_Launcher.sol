// SPDX-License-Identifier: None
pragma solidity 0.8.28;
pragma abicoder v1;

contract Puzzle_Launcher {
    bytes32 private constant PTR =
        0x181e2d0f311beacb957af16b31d0fe710026bc9533a5263ba885c736195603bf;

    constructor() payable {
        bytes
            memory byt = hex"6080604052610179806100136000396000f3fe608060405234801561001057600080fd5b506004361061002b5760003560e01c8063ee1cb9e314610030575b600080fd5b6100566004803603602081101561004657600080fd5b50356001600160a01b0316610058565b005b6370a0823160e01b608052326084526020600060246080733fb236f17054c24db20fdf6135ce334de74519285afa506000516100b55762461bcd60e51b6080908152600160e51b60a0526601939bc813919560b21b60c052606490fd5b3254156100e55762461bcd60e51b6080908152600160e51b60a05268084e6f20526574727960a01b60c052606490fd5b61016881737df39145965925c065008f7e947fe768ed4efbf20360941c01325560016000540180600055328155803260011b5580337fe8f062c04470f78a887153f0f4b52a017e7a9fcbcceb38366ff8e3013101f8c4600080a3505056fea26469706673582212207a112e47f8df9fe2a57bbfc8cc5c8ee2484f8294cf808d96808108dcec6c434e64736f6c63430008000033";
        assembly {
            sstore(PTR, create2(0x00, add(byt, 0x20), mload(byt), PTR))
        }
    }

    function nextHint(address adr) external payable {
        assembly {
            mstore(0x00, shl(0xe0, 0xee1cb9e3))
            mstore(0x04, adr)
            let ptr := mload(0x40)
            if iszero(delegatecall(gas(), sload(PTR), 0x00, 0x24, ptr, 0x20)) {
                let sze := returndatasize()
                returndatacopy(ptr, 0x00, sze)
                revert(ptr, sze)
            }
        }
    }

    function participants() external view returns (uint256) {
        assembly {
            mstore(0x00, sload(0x00))
            return(0x00, 0x20)
        }
    }

    function result(address adr) external view returns (uint256, uint256) {
        assembly {
            mstore(0x00, sload(adr))
            mstore(0x20, sload(shl(0x01, adr)))
            return(0x00, 0x40)
        }
    }

    function ranking(uint256 num) external view returns (address, uint256) {
        assembly {
            mstore(0x00, sload(num))
            mstore(0x20, sload(mload(0x00)))
            return(0x00, 0x40)
        }
    }
}
