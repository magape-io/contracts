// SPDX-License-Identifier:None
pragma solidity 0.8.0;

import "../tests/lib_market.sol";

contract market_test {
    XAPE private itm;
    Market private mkt;
    XAE private ggc;
    Upgrade private pxy;
    Upgrade private px2;
    Upgrade private px3;
    address immutable TIS = address(this);

    function checkProxy() public {
        itm = XAPE(address(px2 = new Upgrade(address(new XAPE()))));
        ggc = XAE(address(px3 = new Upgrade(address(new XAE()))));
        Assert.notEqual(
            address(
                mkt = Market(address(pxy = new Upgrade(address(new Market()))))
            ),
            address(0),
            Z.E01
        );
    }

    function checkListing() public {
        px2.mem(Z.APP, Z.toBytes32(Z.ADM)); // signer
        (address adr, address ad2) = (address(ggc), address(itm));
        itm.mint(0, 1, 0, 27, Z.R, Z.S); // mint
        itm.setApprovalForAll(address(mkt), true);
        mkt.list(ad2, 1, adr, 1 ether);
        Assert.equal(
            pxy.mem(Z.getKeccak(Z.toBytes32(ad2), Z.toBytes32(1))),
            Z.toBytes32(adr),
            Z.E02
        );
    }

    // add listing using coin unable as unit test cannot send coin

    function checkChangeOwner() public {
        address adr = address(mkt);
        px2.mem(
            0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6,
            Z.toBytes32(Z.AC7)
        );
        Assert.equal(itm.ownerOf(1), Z.AC7, Z.E03);
        px2.mem(
            Z.getKeccak(Z.toBytes32(Z.AC7), Z.toBytes32(adr)),
            Z.toBytes32(1)
        );
        Assert.ok(itm.isApprovedForAll(Z.AC7, adr), Z.E03);
    }

    function checkBuyWithFee() public {
        (uint256 amt, address adr, uint256 fee) = (1 ether, address(itm), 3000);
        ggc.mint(TIS, amt);
        ggc.approve(address(mkt), amt);
        pxy.mem(Z.TFM, Z.toBytes32(fee)); // setFee
        mkt.buy(adr, 1);
        Assert.equal(
            pxy.mem(Z.getKeccak(Z.toBytes32(adr), Z.toBytes32(1))),
            Z.toBytes32(0),
            Z.E02
        );
        Assert.equal(itm.ownerOf(1), TIS, Z.E03);
        Assert.equal(ggc.balanceOf(Z.AC7), (amt * (1e4 - fee)) / 1e4, Z.E05);
        Assert.equal(ggc.balanceOf(TIS), (amt * fee) / 1e4, Z.E06);
    }
}
