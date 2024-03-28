// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Resources} from "../Governance/Resources.sol";
import {Manual} from "../Governance/Manual.sol";

contract Node is Resources, Manual {
    event Transfer(address indexed, address indexed, uint256);
    /* 
    Voting event explained
    0x00 - Voting is over / cancelled
    0x01 - Addition of game
    0x02 - Removal of game
    0x04 - Voted against
    0x05 - Voted for
    0x06 - Voting succcessful
    0x07 - Voting failed
    >0xff - (255) Bulk withdrawal
    */
    event Vote(uint256 indexed, uint256);

    function games(address adr) external view returns (bool stt, uint256 amt) {
        // stt - status if game is voted in
        // amt - amount left with game (if not voted in)
        assembly {
            stt := sload(shl(0x05, adr))
            amt := sload(shl(0x06, adr))
        }
    }

    function checkVoting(uint256 ind)
        external
        view
        returns (
            bytes32[5] memory, // first byte = vote casted, last 20 bytes = address
            uint256, // status
            address, // recipient or game address
            address, // vote creator
            uint256 // node number of creator
        )
    {
        assembly {
            mstore(0x00, ind)
            let ptr := keccak256(0x00, 0x20)
            for {
                let i
            } lt(i, 0x09) {
                i := add(i, 0x01)
            } {
                mstore(add(0x80, mul(i, 0x20)), sload(add(ptr, i)))
            }
            return(0x80, 0x0120)
        }
    }

    function count() external view returns (uint256 cnt) {
        assembly {
            cnt := sload(INF)
        }
    }

    function cancelVote(uint256 cnt) external {
        assembly {
            mstore(0x00, cnt)
            let ptr := keccak256(0x00, 0x20)

            // require(vote[cnt].creator == msg.sender);
            if iszero(eq(sload(add(ptr, 0x07)), caller())) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER1)
                revert(0x80, 0x64)
            }

            sstore(add(ptr, 0x05), 0x00) // vote[cnt].status = 0;

            // emit Vote(cnt, 0);
            mstore(0x00, 0x00)
            log2(0x00, 0x20, EVO, cnt)
        }
    }

    function createVote(address adr, uint256 stt) external returns (uint256 cnt) {
        assembly {
            // (bool, uint256 nod) = MagApe(TP5).isTop5(msg.sender);
            mstore(0x00, TP5)
            mstore(0x04, caller())
            pop(staticcall(gas(), sload(TP5), 0x00, 0x24, 0x00, 0x40))
            let nod := mload(0x20)

            // require(nod > 0 && (voteType[stt] != address(0) || stt > 255));
            if or(iszero(nod), and(iszero(sload(stt)), lt(stt, 0x0100))) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER1)
                revert(0x80, 0x64)
            }

            cnt := add(sload(INF), 0x01)
            sstore(INF, cnt) // ++count;

            mstore(0x00, cnt)
            let ptr := keccak256(0x00, 0x20)
            sstore(add(ptr, 0x05), stt) // status
            sstore(add(ptr, 0x06), adr) // address of affecting contract / user
            sstore(add(ptr, 0x07), caller()) // votes[id].owner = msg.sender
            sstore(add(ptr, 0x08), nod) // votes[id].node = nod

            // emit Vote(cnt, stt > 255 ? 3 : stt));
            if gt(stt, 0xff) {
                stt := 0x03
            }
            mstore(0x00, stt)
            log2(0x00, 0x20, EVO, cnt)
        }
    }

    function vote(uint256 ind, bool vot) external {
        assembly {
            mstore(0x80, VOT)
            mstore(0x84, ind)
            mstore(0xa4, vot)

            // uint256 stt = votes[id].status;
            let stt := sload(add(0x05, keccak256(0x84, 0x20)))
            // address adr = voteType[stt];
            let adr := sload(stt)

            // if (stt > 255) adr = voteType[3];
            if gt(stt, 0xff) {
                adr := sload(0x03)
            }

            // require(Vote(adr).vote(ind, vot) && adr != address(0));
            if or(iszero(delegatecall(gas(), adr, 0x80, 0x44, 0x00, 0x00)), iszero(adr)) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER1)
                revert(0x80, 0x64)
            }
        }
    }
}
