// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {GameAdd} from "../Vote/GameAdd.sol"; // voteType = 0x01 (1)
import {GameRemove} from "../Vote/GameRemove.sol"; // voteType = 0x02 (2)
import {WithdrawBulk} from "../Vote/WithdrawBulk.sol"; // voteType = 0x03 (3)

// for future use
import {VoteTypeAdd} from "../Vote/VoteTypeAdd.sol"; // voteType = 0x08 (8)
import {VoteTypeRemove} from "../Vote/VoteTypeRemove.sol"; // voteType = 0x09 (9)
import {UpgradeContract} from "../Vote/UpgradeContract.sol"; // voteType = 0x0a (10)
import {UpgradeOwner} from "../Vote/UpgradeOwner.sol"; // voteType = 0x0b (11)
import {SuspendUser} from "../Vote/SuspendUser.sol"; // voteType = 0x0c (12)
import {SuspendUserResume} from "../Vote/SuspendUserResume.sol"; // voteType = 0x0d (13)
import {SuspendContract} from "../Vote/SuspendContract.sol"; // voteType = 0x0e (14)
import {SuspendContractResume} from "../Vote/SuspendContractResume.sol"; // voteType = 0x0f (15)
import {ERC20Mint} from "../Vote/ERC20Mint.sol"; // voteType = 0x10 (16)
import {ERC20ForceTransfer} from "../Vote/ERC20ForceTransfer.sol"; // voteType = 0x11 (17)
import {ERC721Mint} from "../Vote/ERC721Mint.sol"; // voteType = 0x12 (18)
import {ERC721ForceTransfer} from "../Vote/ERC721ForceTransfer.sol"; // voteType = 0x13 (19)