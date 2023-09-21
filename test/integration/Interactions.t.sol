//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "script/DeployFundMe.s.sol";
import {console} from "forge-std/console.sol";
import {FundFundMe, WithdrawFundMe} from "script/Interactions.s.sol";

contract InteractionsFundMeTest is Test {
    FundMe fundMe;
    uint256 private constant SEND_ETH = 0.01 ether;
    uint256 private constant MINIMUM_USD = 5e8;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testUserCanFundAndOwnerWithdraw() public {
        /* All three actions: Deployement, funding, and withdrawal are performed by:
        default Foundry test account: 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38
        Read more at: https://book.getfoundry.sh/reference/config/testing */

        //Funding the FundMe using Interactions
        FundFundMe fundFundMe = new FundFundMe();

        fundFundMe.fundFundMe(address(fundMe), SEND_ETH);
        uint256 ownerInitialBalance = msg.sender.balance;

        //Withdrawing from FundMe
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        uint256 contractFundMeBalance = address(fundMe).balance;

        withdrawFundMe.withdrawFundMe(address(fundMe));
        uint256 ownerFinalBalance = msg.sender.balance;

        assert(address(fundMe).balance == 0);
        assert(
            ownerFinalBalance == ownerInitialBalance + contractFundMeBalance
        );
    }
}
