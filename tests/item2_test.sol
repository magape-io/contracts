// SPDX-License-Identifier:None
pragma solidity 0.8.0;

import "../tests/lib_item.sol";

contract item2_test {
    XAPE private itm;
    XAE private ggc;
    Upgrade private pxy;
    Upgrade private px2;
    address immutable TIS = address(this);

    function checkProxy() public {
        ggc = XAE(address(px2 = new Upgrade(address(new XAE()))));
        Assert.notEqual(
            address(
                itm = XAPE(address(pxy = new Upgrade(address(new XAPE()))))
            ),
            address(0),
            Z.E02
        );
    }

    function checkSetList() public {
        bytes32 amt = Z.toBytes32(7 ether);
        pxy.mem(Z.APP, Z.toBytes32(Z.ADM)); // signer
        pxy.mem(Z.AFA, Z.toBytes32(address(ggc)));
        pxy.mem(Z.AF2, amt);
        Assert.equal(pxy.mem(Z.AF2), amt, Z.E38);
    }

    function checkTokenMintFail() public {
        try itm.mint(1, 1, 0, 28, Z.R2, Z.S2) {} catch (bytes memory err) {
            Assert.notEqual(err.length, 0, Z.E31);
        }
    }

    function checkTokenMint() public {
        _mint(7 ether);
    }

    // test script can't send ether
    // receive() external payable { }

    // test coin insufficient

    // function checkCoinMint() public payable {
    //     (uint amt, uint bal, string[] memory str) = (7 ether, itm.balanceOf(TIS), new string[](1));
    //     str[0] = Z.STR;
    //     Z.resetCounter(pxy);
    //     pxy.mem(Z.AFA, Z.toBytes32(1));
    //     pxy.mem(Z.AF2, Z.toBytes32(amt));
    //     payable(this).transfer(amt);
    //     itm.mint{value: amt}(1, str, 28, Z.R2, Z.S2);
    //     Assert.equal(itm.balanceOf(TIS), ++bal, Z.E37);
    // }

    function checkTokenMintFee() public {
        Z.resetCounter(pxy);
        pxy.mem(Z.TFM, Z.toBytes32(3000)); // setFee
        _mint(7 ether);
    }

    function _mint(uint256 amt) private {
        (uint256 bal, uint256 ba2) = (itm.balanceOf(TIS), ggc.balanceOf(TIS));
        ggc.mint(TIS, amt);
        ggc.approve(address(itm), amt);
        itm.mint(1, 1, 0, 28, Z.R2, Z.S2);
        Assert.equal(ggc.balanceOf(TIS), ba2 + amt, Z.E37);
        Assert.equal(itm.balanceOf(TIS), ++bal, Z.E38);
    }
}
