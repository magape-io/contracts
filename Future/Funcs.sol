// SPDX-License-Identifier: None
pragma solidity 0.8.0;
pragma abicoder v1;

library Funcs {
    function conAdr2Hex(address a) external pure returns (bytes32 b) {
        assembly {
            b := a
        }
    }

    function conDec2Adr(uint256 a) external pure returns (address b) {
        assembly {
            b := a
        }
    }

    function conDec2Hex(uint256 a) external pure returns (bytes memory b) {
        unchecked {
            uint256 len;
            for (uint256 i = a; i > 0; i /= 256) ++len;
            b = new bytes(len);
            for (uint256 i; i < len; ++i) b[len - i - 1] = bytes1(uint8(a / (2**(8 * i))));
        }
    }

    function conHex2Dec(bytes memory a) external pure returns (uint256 b) {
        unchecked {
            for (uint256 i; i < a.length; ++i) b += uint256(uint8(a[i])) * (2**(8 * (a.length - i - 1)));
        }
    }

    function conHex2Str(bytes32 a) external pure returns (string memory) {
        assembly {
            mstore(0x80, 0x20)
            mstore(0xa0, 0x20)
            mstore(0xc0, a)
            return(0x80, 0x60)
        }
    }

    function conStr2Hex(string memory) external pure returns (bytes32) {
        assembly {
            return(0xa0, 0x20)
        }
    }

    function deploy(bytes memory a, uint256 b) external returns (address c) {
        assembly {
            c := create2(callvalue(), add(a, 0x20), mload(a), b)
        }
    }

    function getKeccak(uint256 a) external pure returns (bytes32 b) {
        assembly {
            mstore(0x00, a)
            b := keccak256(0x00, 0x20)
        }
    }

    function getKeccak(address a) external pure returns (bytes32 b) {
        assembly {
            mstore(0x00, a)
            b := keccak256(0x00, 0x20)
        }
    }

    function getKeccak(bytes32 a) external pure returns (bytes32 b) {
        assembly {
            mstore(0x00, a)
            b := keccak256(0x00, 0x20)
        }
    }

    function getKeccak(bytes32 a, bytes32 b) external pure returns (bytes32 c) {
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            c := keccak256(0x00, 0x40)
        }
    }

    function getSelect(string memory a) external pure returns (bytes4 b) {
        b = bytes4(keccak256(abi.encodePacked(a)));
    }

    function getConAdr(bytes memory a, uint256 b) external view returns (address c) {
        c = address(
            uint160(uint256(keccak256(abi.encodePacked(bytes1(0xff), address(this), b, keccak256(a)))))
        );
    }

    function getConLen(address a) external view returns (uint256 b) {
        b = a.code.length;
    }

    function getECRvsr(
        bytes32 h,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external pure returns (address a) {
        a = ecrecover(h, v, r, s);
    }

    function getECRvsr(bytes32 h, bytes memory c) external pure returns (address a) {
        uint8 v;
        bytes32 r;
        bytes32 s;
        assembly {
            r := mload(add(c, 0x20))
            s := mload(add(c, 0x40))
            v := byte(0, mload(add(c, 0x60)))
        }
        a = ecrecover(h, v, r, s);
    }

    function getStrLen(string memory a) external pure returns (uint256 b) {
        assembly {
            b := mload(a)
        }
    }
}
