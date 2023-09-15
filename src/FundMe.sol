// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";
import {console} from "forge-std/Script.sol";

error FundMe__NotOwner();
error FundMe__NotMinimumEth();
error FundMe__WithdrawFailed();

contract FundMe {
    using PriceConverter for uint256;

    uint256 private constant MINIMUM_USD = 5e8;
    AggregatorV3Interface private s_priceFeedAddress;
    address private immutable i_owner;

    address[] private s_funders;
    mapping(address s_funders => uint256 s_amountFunded)
        private s_fundersToAmountFunded;

    constructor(address _priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeedAddress = AggregatorV3Interface(_priceFeedAddress);

        //FundMe Contract Owner
        console.log("FundMe Contract Owner: %s", i_owner, "\n");
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    function fund() public payable {
        if (msg.value.convertSentAmountInUSD(s_priceFeedAddress) < MINIMUM_USD)
            revert FundMe__NotMinimumEth();
        s_funders.push(msg.sender);
        s_fundersToAmountFunded[msg.sender] += msg.value;

        //Understanding FundMe Contract Data
        console.log("%s funded %s wei to FundMe", msg.sender, msg.value, "\n");
    }

    function withdrawTransfer() public onlyOwner {
        //Checking FundMe Balance before and after withdrawal
        console.log(
            "Before withdrawing from FundMe: %s",
            address(this).balance,
            "\n"
        );
        payable(msg.sender).transfer(address(this).balance);
        resetFunders();
        console.log(
            "After withdraw from FundMe: %s",
            address(this).balance,
            "\n"
        );
    }

    function withdrawSend() public onlyOwner returns (bool) {
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        if (!sendSuccess) revert FundMe__WithdrawFailed();
        resetFunders();
        return sendSuccess;
    }

    function withdrawCall() public onlyOwner returns (bool) {
        (bool sendSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        if (!sendSuccess) revert FundMe__WithdrawFailed();
        resetFunders();
        return sendSuccess;
    }

    function resetFunders() public {
        uint256 totalFunders = s_funders.length;
        for (uint256 i = 0; i < totalFunders; i++) {
            s_fundersToAmountFunded[s_funders[i]] = 0;
        }
        s_funders = new address[](0);
    }

    function getPriceFeedVersion() public view returns (uint256) {
        return s_priceFeedAddress.version();
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    /* // View/pure getters */
    function getMinimumUSD() public pure returns (uint256) {
        return MINIMUM_USD;
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getFunders() public view returns (address[] memory) {
        return s_funders;
    }
}
