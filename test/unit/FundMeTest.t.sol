//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "script/DeployFundMe.s.sol";
import {console} from "forge-std/console.sol";

contract fundMeTest is Test {
    FundMe fundMe;
    uint256 private constant SEND_ETH = 1 ether;
    uint256 private constant MINIMUM_USD = 5e8;
    uint256 private constant STARTING_BALANCE = 1000 ether;
    address private TEST_USER = makeAddr("TEST_USER");

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(TEST_USER, STARTING_BALANCE);
    }

    modifier funded() {
        vm.prank(TEST_USER);
        fundMe.fund{value: SEND_ETH}();
        _;
    }

    function testMinimumUSDIsFiveDollars() public {
        assertEq(fundMe.getMinimumUSD(), MINIMUM_USD);
    }

    function testTheDeployerIsOwner() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testUserCanSendFunds() public funded {
        assertEq(address(fundMe).balance, SEND_ETH);
    }

    function testFundTransferRevertForLessThanFiveDollars() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFunderIsGettingAddedToTheFunders() public funded {
        assertEq(fundMe.getFunders()[0], TEST_USER);
    }

    function testUnAuthorizedWithdrawalIsDenied() public funded {
        vm.prank(TEST_USER);
        vm.expectRevert();
        fundMe.withdrawTransfer();
    }

    function testOwnerCanWithdrawTheFundsUsingTransfer() public funded {
        vm.prank(fundMe.getOwner());
        fundMe.withdrawTransfer();

        assertEq(address(fundMe).balance, 0);
    }

    function testOwnerCanWithdrawTheFundsUsingSend() public funded {
        vm.prank(fundMe.getOwner());
        fundMe.withdrawSend();

        assertEq(address(fundMe).balance, 0);
    }

    function testOwnerCanWithdrawTheFundsUsingCall() public funded {
        vm.prank(fundMe.getOwner());

        fundMe.withdrawCall();

        assertEq(address(fundMe).balance, 0);
    }

    function testTheFundersArrayIsResetAfterWithdrawal() public funded {
        vm.prank(fundMe.getOwner());
        fundMe.withdrawTransfer();

        assertEq(fundMe.getFunders().length, 0);
    }

    function testWithdrawFromMultipleFunders() public {
        uint160 addresses = 10;
        uint160 startingAddress = 1;
        for (uint160 i = startingAddress; i <= addresses; i++) {
            hoax(address(i), SEND_ETH);
            fundMe.fund{value: SEND_ETH}();
        }
        uint256 fundMeInitialBalance = address(fundMe).balance;
        uint256 ownerInitialBalance = fundMe.getOwner().balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdrawTransfer();

        uint256 ownerEndingBalance = fundMe.getOwner().balance;

        assert(
            ownerEndingBalance == fundMeInitialBalance + ownerInitialBalance
        );
        assert(address(fundMe).balance == 0);
        assertEq(fundMe.getFunders().length, 0);
    }

    // function testUserIsRedirectedToFundWithReceiveFunctionSelector()
    //     public
    //     ded
    // {}

    // function testUserIsRedirectedToFallbackWithFallbackFunctionSelector()
    //     public
    // {}

    function testGetPriceFeedVersion() public {
        assertEq(fundMe.getPriceFeedVersion(), 4);
    }
}
