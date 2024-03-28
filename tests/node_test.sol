// SPDX-License-Identifier:None
pragma solidity 0.8.0;

import "../tests/lib_node.sol";

contract node_test {
    Node private nod;
    GGC private ggc;
    Item private itm;
    Upgrade private pxy;
    Upgrade private px2;
    Upgrade private px3;
    address private immutable TIS = address(this);

    function checkProxy() public {
        ggc = GGC(address(px2 = new Upgrade(address(new GGC()))));
        itm = Item(address(px3 = new Upgrade(address(new Item()))));
        Assert.notEqual(
            address(nod = Node(address(pxy = new Upgrade(address(new Node()))))),
            address(0),
            Z.E02
        );
    }

    function checkCreateVoteAddGame() public {
        pxy.mem(Z.TP5, Z.toBytes32(address(itm))); // item.sol adr
        px3.mem(Z.getKeccak(TIS, 1), Z.toBytes32(7)); // node
        nod.createVote(TIS, 1);
        (, , , address adr) = nod.checkVoting(nod.count());
        Assert.equal(adr, TIS, Z.E03);
    }

    function checkCreateVoteRemoveGame() public {
        nod.createVote(TIS, 2);
        (uint256 sta, , , ) = nod.checkVoting(nod.count());
        Assert.equal(sta, 2, Z.E04);
    }

    function checkCreateVoteMassWithdrawal() public {
        nod.createVote(Z.AC7, 1e20);
        (uint256 sta, address adr, , ) = nod.checkVoting(nod.count());
        Assert.equal(sta, 1e20, Z.E05);
        Assert.equal(adr, Z.AC7, Z.E06);
    }

    function checkCancelVote() public {
        nod.cancelVote(2);
        (uint256 sta, , , ) = nod.checkVoting(2);
        Assert.equal(sta, 0, Z.E07);
    }

    function checkTopUp() public {
        address ad2 = address(nod);
        (uint256 bal, uint256 amt) = (ggc.balanceOf(ad2), 1e18);
        ggc.mint(TIS, amt);
        ggc.approve(ad2, amt);
        nod.topUp(address(ggc), amt);
        Assert.equal(ggc.balanceOf(ad2), bal, Z.E08);
    }

    function checkResourceOut() public {
        (uint256 bal, uint256 amt) = (ggc.balanceOf(TIS), 1e18);
        ggc.mint(address(nod), 1e20);
        pxy.mem(Z.APP, Z.toBytes32(Z.ADM)); // signer
        pxy.mem(Z.TTF, Z.toBytes32(address(ggc))); // ggc.sol adr
        nod.resourceOut(address(ggc), 1e18, 27, Z.R, Z.S);
        Z.resetCounter(pxy);
        Assert.equal(ggc.balanceOf(TIS), bal + amt, Z.E08);
    }

    function checkGamesStatus() public {
        address adr = address(ggc);
        pxy.mem(Z.toBytes32(Z.toUint(adr) << 5), Z.toBytes32(1));
        (bool bol, ) = nod.games(adr);
        Assert.ok(bol, Z.E09);
    }

    function checkNewResourceOutVoted() public {
        (uint256 bal, uint256 amt) = (ggc.balanceOf(TIS), 1e18);
        nod.resourceOut(address(ggc), 1e18, 27, Z.R, Z.S);
        Z.resetCounter(pxy);
        Assert.equal(ggc.balanceOf(TIS), bal + amt, Z.E08);
    }

    function checkTopup() public {
        (address adr, uint256 amt) = (address(itm), 1e18);
        ggc.approve(address(nod), amt);
        nod.topUp(adr, amt);
        (, uint256 gam) = nod.games(adr);
        Assert.equal(gam, amt, Z.E16);
    }

    function checkNewResourceOutTopup() public {
        (uint256 bal, uint256 amt) = (ggc.balanceOf(TIS), 1e18);
        nod.resourceOut(address(itm), 1e18, 27, Z.R, Z.S);
        Z.resetCounter(pxy);
        Assert.equal(ggc.balanceOf(TIS), bal + amt, Z.E08);
    }

    function checkNewResourceOutTopupFail() public {
        try nod.resourceOut(address(itm), 1e18, 27, Z.R, Z.S) {} catch (
            bytes memory err
        ) {
            Assert.notEqual(err.length, 0, Z.E13);
        }
    }

    function checkResourceIn() public {
        address adr = address(nod);
        (uint256 bal, uint256 amt) = (ggc.balanceOf(adr), 5e17);
        ggc.approve(adr, amt);
        nod.resourceIn(address(ggc), amt);
        Assert.equal(ggc.balanceOf(adr), bal + amt, Z.E10);
    }

    function checkNonTop5VoteFail() public {
        try nod.vote(nod.count(), true) {} catch (bytes memory err) {
            Assert.notEqual(err.length, 0, Z.E13);
        }
    }

    function checkAddTop5() public {
        px3.mem(Z.getKeccak(Z.TP5, Z.toBytes32(7)), Z.toBytes32(TIS));
        (bool bol, ) = itm.isTop5(TIS);
        Assert.ok(bol, Z.E11);
    }

    function checkVoteAddGameFinal() public {
        nod.createVote(Z.AC7, 1);
        _mockVotes();
        (bool bol, ) = nod.games(Z.AC7);
        Assert.ok(bol, Z.E09);
    }

    function checkVoteIllegalFail() public {
        try nod.vote(nod.count(), true) {} catch (bytes memory err) {
            Assert.notEqual(err.length, 0, Z.E13);
        }
    }

    function checkVoteRemoveGameFinal() public {
        nod.createVote(Z.AC7, 2);
        _mockVotes();
        (bool bol, ) = nod.games(Z.AC7);
        Assert.ok(!bol, Z.E14);
    }

    function checkVoteWithdrawFinal() public {
        (uint256 bal, uint256 amt) = (ggc.balanceOf(TIS), 1e20);
        ggc.mint(address(nod), amt);
        nod.createVote(TIS, amt);
        _mockVotes();
        Assert.equal(ggc.balanceOf(TIS), bal + amt, Z.E15);
    }

    function _mockVotes() private {
        uint256 cnt = nod.count();
        pxy.mem(Z.fmtIndex(cnt, 2), Z.fmtVote(address(ggc)));
        pxy.mem(Z.fmtIndex(cnt, 3), Z.fmtVote(address(itm)));
        nod.vote(cnt, true);
        (uint256 sta, , , ) = nod.checkVoting(cnt);
        Assert.equal(sta, 0, Z.E12);
    }
}
