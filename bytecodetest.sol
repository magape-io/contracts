// SPDX-License-Identifier: None
pragma solidity 0.8.0;

contract bytecodetest {
    uint256 public num;

    fallback() external {}

    function addNum(uint256 adm) external {
        num += adm;
    }
}

// 0x75278362000000000000000000000000000000000000000000000000000000000000ffff
// 0x4e70b1dc00000000000000000000000000000000000000000000000000000000

contract Universal {
    function write(address adr, bytes memory byt) external {
        assembly {
            pop(call(gas(), adr, 0x00, add(byt, 0x20), mload(byt), 0x00, 0x00))
        }
    }

    function read(address adr, bytes memory byt)
        external
        view
        returns (bytes memory by2)
    {
        assembly {
            let ptr := mload(0x40)
            pop(staticcall(gas(), adr, add(byt, 0x20), mload(byt), 0x00, 0x20))
            let sze := returndatasize()

            mstore(0x00, sze)

            // returndatacopy(ptr, 0x00, sze)
            // return(ptr, sze)
        }
    }

    function readTest(address adr) external view returns (uint) {
        assembly {
            mstore(0xa0, "so funny")
            mstore(0x00, 0x4e70b1dc00000000000000000000000000000000000000000000000000000000)
            let ptr := mload(0x40)
            let sus := staticcall(gas(), adr, 0x00, 0x04, 0xc0, 0x20)
            // let sze := returndatasize()

            // mstore(0x80, sze)

            // returndatacopy(ptr, 0x00, sze)
            return(0xc0, 0x20)
        }
    }
}
