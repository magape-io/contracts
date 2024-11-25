// SPDX-License-Identifier:None
pragma solidity 0.8.28;

import {Ownable} from "../Util/Ownable.sol";
import {NotBan} from "../Util/NotBan.sol";

contract MAC is Ownable, NotBan {
    event Transfer(address indexed, address indexed, uint256);
    event Approval(address indexed, address indexed, uint256);

    constructor() payable {}

    function name() external pure returns (string memory) {
        assembly {
            mstore(0x80, 0x20)
            mstore(0xa0, 0x0a)
            mstore(0xc0, "MagApeCoin")
            return(0x80, 0x60)
        }
    }

    function symbol() external pure returns (string memory) {
        assembly {
            mstore(0x80, 0x20)
            mstore(0xa0, 0x03)
            mstore(0xc0, "MAC")
            return(0x80, 0x60)
        }
    }

    function decimals() external pure returns (uint256 val) {
        assembly {
            val := 0x12
        }
    }

    function totalSupply() external view returns (uint256 amt) {
        assembly {
            amt := sload(INF)
        }
    }

    function allowance(address adr, address ad2)
        external
        view
        returns (uint256 amt)
    {
        assembly {
            mstore(0x00, adr)
            mstore(0x20, ad2)
            amt := sload(keccak256(0x00, 0x40))
        }
    }

    function balanceOf(address adr) external view returns (uint256 amt) {
        assembly {
            // mstore(0x00, adr)
            // amt := sload(keccak256(0x00, 0x20))
            amt := sload(add(0x01, adr))
        }
    }

    function approve(address adr, uint256 amt)
        external
        payable
        returns (bool bol)
    {
        assembly {
            mstore(0x00, caller())
            mstore(0x20, adr)
            sstore(keccak256(0x00, 0x40), amt)
            mstore(0x00, amt)
            log3(0x00, 0x20, EAP, caller(), adr)
            bol := 0x01
        }
    }

    function transfer(address adr, uint256 amt)
        external
        payable
        notBan1(adr)
        returns (bool bol)
    {
        assembly {
            let tmp := add(0x01, caller())
            let bal := sload(tmp)
            if gt(amt, bal) {
                // require(balanceOf(msg.sender) >= amt)
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER2)
                revert(0x80, 0x64)
            }
            sstore(tmp, sub(bal, amt))
            tmp := add(0x01, adr)
            sstore(tmp, add(sload(tmp), amt))

            mstore(0x00, amt) // emit Transfer(adr, ad2, amt)
            log3(0x00, 0x20, ETF, caller(), adr)
            bol := 0x01
        }
    }

    function transferFrom(
        address adr,
        address ad2,
        uint256 amt
    ) public payable notBan1(adr) returns (bool bol) {
        assembly {
            let tmp := add(0x01, adr)
            let bal := sload(tmp)

            mstore(0x00, adr)
            mstore(0x20, ad2)
            let ptr := keccak256(0x00, 0x40)
            let alw := sload(ptr)
            if or(gt(amt, bal), gt(amt, alw)) {
                // require(allowance >= amt)
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER2)
                revert(0x80, 0x64)
            }

            sstore(ptr, sub(alw, amt))
            sstore(tmp, sub(bal, amt))

            tmp := add(0x01, ad2)
            sstore(tmp, add(sload(tmp), amt))

            mstore(0x00, amt) // emit Transfer(adr, ad2, amt)
            log3(0x00, 0x20, ETF, caller(), adr)
            bol := 0x01
        }
    }

    function mint(address adr, uint256 amt) external payable onlyOwner {
        assembly {
            let tmp := add(0x01, adr)
            sstore(tmp, add(sload(tmp), amt))
            sstore(INF, add(sload(INF), amt))
            mstore(0x00, amt) // emit Transfer(address(0), ad2, amt)
            log3(0x00, 0x20, ETF, 0x00, adr)
        }
    }

    function burn(uint256 amt) external payable {
        assembly {
            let tmp := add(0x01, caller())
            sstore(tmp, sub(sload(tmp), amt))
            sstore(INF, sub(sload(INF), amt))
            mstore(0x00, amt) // emit Transfer(adr, address(0), amt)
            log3(0x00, 0x20, ETF, caller(), 0x00)
        }
    }
}
