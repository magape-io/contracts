// SPDX-License-Identifier: None
pragma abicoder v1;
pragma solidity 0.8.0;

contract P001 {
    /*
    This is an example of the puzzle sequence, it will return the
    corresponding contract address and the chain network ID of the
    next puzzle.

    For this example we will be using asking what is the most stable
    currency in BNB chain, which the answer is BUSD-T

    0x55d398326f99059fF775485246999027B3197955

    Once the above address is input, it will reveal Klaytn Baobao
    contract address and its network chain ID
    */

    uint256 private constant BIT = 0x94;
    uint256 private constant ADD = 0x0168;
    uint256 private constant MIX = 0x007df39145965925c065008f7e947fe768ed4efbf2;
    address private constant NFT = 0xD8555E9A128C07928C1429D834640372C8381828;

    function nextHint(address adr) external returns (address ctc, uint256 nid) {
        assembly {
            // Only MagApe NFT holder are able to participate
            // require(MAC(NFT).balanceOf(msg.sender) > 0, "No NFT");
            mstore(0x80, shl(224, 0x70a08231))
            mstore(0x84, origin())
            pop(staticcall(gas(), NFT, 0x80, 0x24, 0x00, 0x20))
            if iszero(mload(0x00)) {
                mstore(0x80, shl(0xe5, 0x461bcd))
                mstore(0xa0, shl(0xe0, 0x20))
                mstore(0xc0, shl(0xb0, 0x064e6f204e4654))
                revert(0x80, 0x64)
            }

            // Only able to participate once per address
            // require(result[msg.sender] == 0, "No Retry");
            if gt(sload(origin()), 0x00) {
                mstore(0x80, shl(0xe5, 0x461bcd))
                mstore(0xa0, shl(0xe0, 0x20))
                mstore(0xc0, shl(0xa0, 0x084e6f205265747279))
                revert(0x80, 0x64)
            }

            // Decode the messages into address and network ID
            // ctc = address(uint160(uint256(byt) - uint256(uint160(adr))));
            mstore(0x00, sub(MIX, adr))

            // For tracking purposes
            // ranking[msg.sender] = (RNK++, nid);
            nid := add(sload(0x00), 0x01)
            sstore(0x00, nid)
            sstore(nid, origin())
            sstore(shl(0x01, origin()), nid)

            // Keep a record of the address
            // result[msg.sender] = nid = (uint160(ctc) >> BIT) + ADD;
            nid := add(shr(BIT, ctc), ADD)
            sstore(origin(), nid)
        }
    }

    function ranking(uint256 num) external view returns (address, uint256) {
        assembly {
            mstore(0x00, sload(num))
            mstore(0x20, sload(mload(0x00)))
            return(0x00, 0x40)
        }
    }

    function result(address adr) external view returns (uint256, uint256) {
        assembly {
            mstore(0x00, sload(adr))
            mstore(0x20, sload(shl(0x01, adr)))
            return(0x00, 0x40)
        }
    }

    function participants() external view returns (uint256) {
        assembly {
            mstore(0x00, sload(0x00))
            return(0x00, 0x20)
        }
    }
}
