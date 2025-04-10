// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

contract UpgradeOwner {
    constructor() payable {}

    function vote(uint256 ind, bool vot) external payable {
        // This is a future voting module to be added into the DAO
        // If this is activated, the community is able to update
        // the owner of this node contract or other contracts
        // Voting mechanism can follow the current practice of
        // 1 - top 5 nft owners can vote
        // 2 - 3 out of 5 to vote for or against
        // 3 - adhere to sub-node type
        // 4 - only can vote once
        // However, it can be evolved into:
        // a - all top 5 need to vote for or against, or
        // b - up to n number of voters instead (need to change memory position, or
        // c - top 5 token holders to vote (requires external checking), or
        // d - everyone can vote, need 100 votes from different addresses, or
        // e - can vote twice, but each vote will have to pay an increment MAC
        // This module will be activated only when the DAO community
        // have attained a significant number where we will lose 100%
        // of control and the community is ready to take on a fair
        // governance. Only with sheer mass will then the voting will
        // receive more opinions and it will be more difficult to
        // create malicious votes.
    }
}
