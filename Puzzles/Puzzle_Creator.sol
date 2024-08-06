// SPDX-License-Identifier: None
pragma solidity 0.8.0;
pragma abicoder v1;

contract Puzzle_Creator {
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

    event Result(address indexed, uint256 indexed);

    uint256 private constant BIT = 0x94;
    uint256 private constant ADD = 0x0168;
    uint256 private constant MIX = 0x007df39145965925c065008f7e947fe768ed4efbf2;
    address private constant NFT = 0x3FB236F17054c24DB20FDf6135Ce334DE7451928;

    constructor() payable {}

    function nextHint(address adr) external {
        assembly {
            // Only MagApe NFT holder are able to participate
            // require(MAC(NFT).balanceOf(msg.sender) > 0, "No NFT");
            mstore(0x80, shl(0xe0, 0x70a08231))
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

            // Keep a record of the address
            // result[msg.sender] = tmp = (uint160(ctc) >> BIT) + ADD;
            sstore(origin(), add(shr(BIT, sub(MIX, adr)), ADD))

            // For tracking purposes
            // ranking[msg.sender] = (RNK++, tmp);
            let tmp := add(sload(0x00), 0x01)
            sstore(0x00, tmp)
            sstore(tmp, origin())
            sstore(shl(0x01, origin()), tmp)

            // Broadcast the result to listening service
            // emit Result(msg.sender, RNK)
            log3(0x00, 0x00, 0xe8f062c04470f78a887153f0f4b52a017e7a9fcbcceb38366ff8e3013101f8c4, caller(), tmp)
        }
    }
}
