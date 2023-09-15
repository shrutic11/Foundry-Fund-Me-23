//SPDX-License-Identifier: MIT

import {FundMe} from "../src/FundMe.sol";
import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/devOpsTools.sol";

pragma solidity ^0.8.19;

contract FundFundMe is Script {
    uint256 public s_amountSent;

    function run() external {
        address mostRecentFundMe = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        fundFundMe(mostRecentFundMe, s_amountSent);
    }

    function fundFundMe(address _mostRecentContract, uint256 _amount) public {
        //startBroadcast takes the user account and performs all the subsequent actions as him till stopBroadcast is called, and broadcasts it on chain - anvil/sepolia
        vm.startBroadcast();
        FundMe(payable(_mostRecentContract)).fund{value: _amount}();
        vm.stopBroadcast();
    }
}

/* =========================================================================*/ /* =========================================================================*/

contract WithdrawFundMe is Script {
    function run() external {
        address mostRecentFundMe = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        withdrawFundMe(mostRecentFundMe);
    }

    function withdrawFundMe(address _mostRecentFundMe) public {
        vm.startBroadcast();
        FundMe(payable(_mostRecentFundMe)).withdrawTransfer();
        vm.stopBroadcast();
    }
}
