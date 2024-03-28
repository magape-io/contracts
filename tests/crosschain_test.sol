// SPDX-License-Identifier:None
pragma solidity 0.8.0;

import "../tests/lib_crosschain.sol";

contract crosschain_test {
    CrossChain private crc;
    XAE private ggc;
    XAPE private itm;
    Upgrade private pxy;
    Upgrade private px2;
    Upgrade private px3;
    address private immutable TIS = address(this);

    function checkProxy() public {
        ggc = XAE(address(px2 = new Upgrade(address(new XAE()))));
        itm = XAPE(address(px3 = new Upgrade(address(new XAPE()))));
        Assert.notEqual(
            address(
                crc = CrossChain(
                    address(pxy = new Upgrade(address(new CrossChain())))
                )
            ),
            address(0),
            Z.E01
        );
    }

    function checkSetContract() public {
        pxy.mem(Z.TTF, Z.toBytes32(address(ggc)));
        pxy.mem(Z.TP5, Z.toBytes32(address(itm)));
        Assert.notEqual(pxy.mem(Z.TTF), bytes32(0), Z.E02);
        Assert.notEqual(pxy.mem(Z.TP5), bytes32(0), Z.E02);
    }

    function checkMint() public {
        uint256 amt = 1e20;
        ggc.mint(TIS, amt);
        Assert.equal(amt, ggc.balanceOf(TIS), Z.E03);
    }

    function checkTransfer() public {
        (uint256 amt, uint256 bal, uint256 ttl) = (
            2e19,
            ggc.balanceOf(TIS),
            ggc.totalSupply()
        );
        ggc.approve(address(crc), amt);
        crc.transferTKN(0xfa, TIS, amt);
        Assert.equal(ggc.balanceOf(TIS), bal - amt, Z.E04);
        Assert.equal(ggc.totalSupply(), ttl - amt, Z.E05);
    }

    function checkSetAmount() public {
        //pxy.mem(Z.TFM, Z.toBytes32(3e14));
        // unable to check wei as unit testing cannot send ether
        pxy.mem(Z.ER5, Z.toBytes32(1e19));
        ggc.mint(TIS, 1e24);
        Assert.notEqual(pxy.mem(Z.ER5), bytes32(0), Z.E02);
    }

    function checkTransferError() public {
        uint256 amt = 2e19;
        ggc.approve(address(crc), amt);
        try crc.transferTKN(0xfa, TIS, amt) {} catch (bytes memory err) {
            Assert.notEqual(err.length, 0, Z.E31);
        }
    }
}
