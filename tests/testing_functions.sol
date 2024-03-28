// SPDX-License-Identifier: None
pragma solidity 0.8.0;

contract test {
    function getByte() external pure returns(bytes32 byt) {
        assembly {
            byt := sub(0x00000007616d7420657272000000000000000000000000000000000000000000, 0x01)
        }
    }

    // function UinttoString(uint256 tid) public pure returns (string memory) {
    //     assembly {
    //         let len := 0x00

    //         for {
    //             let i := tid
    //         } gt(i, 0x00) {

    //         } {
    //             len := add(len, 0x01)
    //             i := div(i, 0x0a)
    //         }

    //         for {
    //             let ptr := add(0xc0, len)
    //         } gt(tid, 0x00) {
    //             tid := div(tid, 0x0a)
    //         } {
    //             ptr := sub(ptr, 0x01)
    //             mstore8(ptr, add(0x30, mod(tid, 0xa)))
    //         }

    //         if eq(len, 0x00) {
    //             len := 0x01
    //             mstore8(0xc0, 0x30)
    //         }

    //         mstore(0x80, 0x20)
    //         mstore(0xa0, len)
    //         return(0x80, 0x60)
    //     }
    // }
}

/***
    Attachment.sol
    ***/
// function testMint() external { // 154013
//     _mint("ifps://QmNvWjdSxcXDzevFNYw46QkNvuTEod1FF8Le7GYLxWAavk/");
//     setTop5(msg.sender);
// }

// function testMint(string[] calldata uris) external {
//     uint len = uris.length;
//     unchecked {
//         for(uint i; i < len; ++i) _mint(uris[i]);
//     }
//     setTop5(msg.sender);
// }

/***
    Node.sol
    ***/
// function resourceOut() external {
//     _transfer(msg.sender, 0x0a);
// }

/***
    Top5.sol
    ***/
// function TESTgetTop5() external view returns(address, uint, address, uint, address, uint, address, uint, address, uint) {
//     assembly {
//         mstore(0x80, sload(TP5))
//         mstore(0xa0, sload(keccak256(0x80, 0x20)))
//         mstore(0xc0, sload(add(TP5, 0x01)))
//         mstore(0xe0, sload(keccak256(0xc0, 0x20)))
//         mstore(0x0100, sload(add(TP5, 0x02)))
//         mstore(0x0120, sload(keccak256(0x0100, 0x20)))
//         mstore(0x0140, sload(add(TP5, 0x03)))
//         mstore(0x0160, sload(keccak256(0x0140, 0x20)))
//         mstore(0x0180, sload(add(TP5, 0x04)))
//         mstore(0x01a0, sload(keccak256(0x0180, 0x20)))
//         return(0x80, 0x140)
//     }
// }

// function TESTsetTop5() external {
//     assembly {
//         mstore(0x00, 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4)
//         sstore(TP5, mload(0x00))
//         sstore(keccak256(0x00, 0x20), 0x05)
//         mstore(0x00, 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2)
//         sstore(add(TP5, 0x01), mload(0x00))
//         sstore(keccak256(0x00, 0x20), 0x06)
//         mstore(0x00, 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db)
//         sstore(add(TP5, 0x02), mload(0x00))
//         sstore(keccak256(0x00, 0x20), 0x07)
//         mstore(0x00, 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB)
//         sstore(add(TP5, 0x03), mload(0x00))
//         sstore(keccak256(0x00, 0x20), 0x08)
//         mstore(0x00, 0x617F2E2fD72FD9D5503197092aC168c91465E7f2)
//         sstore(add(TP5, 0x04), mload(0x00))
//         sstore(keccak256(0x00, 0x20), 0x09)
//     }
// }

// function TESTaddBal() external {
//     assembly {
//         mstore(0x00, caller())
//         let ptr := keccak256(0x00, 0x20)
//         sstore(ptr, add(sload(ptr), 0x01))
//     }
//     setTop5(msg.sender);
// }

/********** 
    CrossChain.sol 
    ************/
// function TESToverwrite() external {
//     assembly {
//         mstore(0x00, caller())
//         let ptr := keccak256(0x00, 0x20)
//         sstore(ptr, 0x01) // 没放 add 就是免除费用
//         // sstore(add(ptr, 0x01), 1000000000000000000) // 加值
//         sstore(add(ptr, 0x02), 0x01)
//         sstore(add(ptr, 0x03), 0x00)

//     }
// }

// function TESTsetVal() external {
//     assembly {
//         sstore(OWO, 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2)
//         sstore(TFM, 0x110d9316ec000) // 3e14
//         sstore(TFM, 0x8ac7230489e80000)
//     }
// }

// function TESTtkn (uint amt) external {
//     assembly {
//         let itm := sload(TTF)
//         let tkn := sload(ER5)

//         mstore(0x00, caller()) // 覆盖值
//         let usr := keccak256(0x00, 0x20)
//         if gt(sload(add(usr, 0x02)), 0x00) { tkn := sload(add(usr, 0x03)) }

//         mstore(0x80, TFM)  // require(transferForm(msg.sender, to, fee))
//         mstore(0x84, caller())
//         mstore(0xa4, address())
//         mstore(0xc4, add(amt, tkn))
//         if iszero(call(gas(), itm, 0x00, 0x80, 0x64, 0x00, 0x00)) {
//             mstore(0x80, ERR)
//             mstore(0xa0, STR)
//             mstore(0xc0, ER2)
//             revert(0x80, 0x64)
//         }
//     }
// }

/********** 
    Item.sol 
    ************/
// function tokenURI (uint tid) external pure returns (string memory) {
//     assembly {
//         mstore(0xc0, sload(ER4)) // 用ER4存
//         mstore(0xe0, sload(add(ER4, 0x01)))
//         let len := 0x00

//         for { let i := tid } gt(i, 0x00) { } {
//             len := add(len, 0x01)
//             i := div(i, 0x0a)
//         }

//         for { let ptr := add(0x0100, len) } gt(tid, 0x00) { tid := div(tid, 0x0a) } {
//             ptr := sub(ptr, 0x01)
//             mstore8(ptr, add(0x30, mod(tid, 0x0a)))
//         }

//         if eq(len, 0x00) { // tid 为 0
//             len := 0x01
//             mstore8(0x0100, 0x30)
//         }

//         mstore(0x80, 0x20)
//         mstore(0xa0, add(len, 0x40))
//         return(0x80, 0xa0)
//     }
// }
