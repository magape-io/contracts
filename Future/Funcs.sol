// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

library Funcs {
    function conAdr2Hex(address a) public pure returns (bytes32) {
        assembly {
            mstore(0x00, a)
            return(0x00, 0x20)
        }
    }

    function conDec2Adr(uint256 a) public pure returns (address) {
        assembly {
            mstore(0x00, a)
            return(0x00, 0x20)
        }
    }

    function conDec2Hex(uint256 a) public pure returns (bytes memory b) {
        unchecked {
            uint256 len;
            for (uint256 i = a; i > 0; i /= 256) ++len;
            b = new bytes(len);
            for (uint256 i; i < len; ++i)
                b[len - i - 1] = bytes1(uint8(a / (2**(8 * i))));
        }
    }

    function conDec2Str(uint256 a) public pure returns (string memory b) {
        assembly {
            let c
            let d
            if eq(a, 0x00) {
                c := 0x3000000000000000000000000000000000000000000000000000000000000000
                d := 0x01
            }
            for {

            } gt(a, 0x00) {
                d := add(d, 0x01)
            } {
                c := div(c, 0x0100)
                c := or(
                    c,
                    mul(
                        add(mod(a, 0x0a), 0x30),
                        0x100000000000000000000000000000000000000000000000000000000000000
                    )
                )
                a := div(a, 0x0a)
            }

            b := mload(0x40)
            mstore(0x40, add(b, 0x40))
            mstore(b, d)
            mstore(add(b, 0x20), c)
        }
    }

    function conHex2Dec(bytes memory a) public pure returns (uint256 b) {
        unchecked {
            uint256 c = a.length;
            for (uint256 i; i < c; ++i)
                b += uint256(uint8(a[i])) * (2**(8 * (c - i - 1)));
        }
    }

    function conHex2Str(bytes32 a) public pure returns (string memory) {
        assembly {
            mstore(0x80, 0x20)
            mstore(0xa0, 0x20)
            mstore(0xc0, a)
            return(0x80, 0x60)
        }
    }

    function conStr2Hex(string memory) public pure returns (bytes32) {
        assembly {
            return(0xa0, 0x20)
        }
    }

    function deploy(bytes memory a, uint256 b) public returns (address) {
        assembly {
            mstore(0x00, create2(callvalue(), add(a, 0x20), mload(a), b))
            return(0x00, 0x20)
        }
    }

    function getKeccak(uint256 a) public pure returns (bytes32) {
        assembly {
            mstore(0x00, a)
            mstore(0x00, keccak256(0x00, 0x20))
            return(0x00, 0x20)
        }
    }

    function getKeccak(address a) public pure returns (bytes32) {
        assembly {
            mstore(0x00, a)
            mstore(0x00, keccak256(0x00, 0x20))
            return(0x00, 0x20)
        }
    }

    function getKeccak(bytes32 a) public pure returns (bytes32) {
        assembly {
            mstore(0x00, a)
            mstore(0x00, keccak256(0x00, 0x20))
            return(0x00, 0x20)
        }
    }

    function getKeccak(bytes32 a, bytes32 b) public pure returns (bytes32) {
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            mstore(0x00, keccak256(0x00, 0x40))
            return(0x00, 0x20)
        }
    }

    function getSelect(string memory a) public pure returns (bytes4) {
        return (bytes4(keccak256(abi.encodePacked(a))));
    }

    function getConAdr(bytes memory a, uint256 b)
        public
        view
        returns (address)
    {
        return (
            address(
                uint160(
                    uint256(
                        keccak256(
                            abi.encodePacked(
                                bytes1(0xff),
                                address(this),
                                b,
                                keccak256(a)
                            )
                        )
                    )
                )
            )
        );
    }

    function getConLen(address a) public view returns (uint256) {
        return (a.code.length);
    }

    function getRecover(
        bytes32 h,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public pure returns (address) {
        return (ecrecover(h, v, r, s));
    }

    function getRecover(bytes32 h, bytes memory c)
        public
        pure
        returns (address)
    {
        uint8 v;
        bytes32 r;
        bytes32 s;
        assembly {
            v := byte(0x00, mload(add(c, 0x60)))
            r := mload(add(c, 0x20))
            s := mload(add(c, 0x40))
        }
        return (ecrecover(h, v, r, s));
    }

    function getBitShift(uint256 a, address b) public pure returns (bytes32) {
        assembly {
            mstore(0x00, shl(a, b))
            return(0x00, 0x20)
        }
    }

    function getStrLen(string memory a) public pure returns (uint256) {
        assembly {
            mstore(0x00, mload(a))
            return(0x00, 0x20)
        }
    }
}
