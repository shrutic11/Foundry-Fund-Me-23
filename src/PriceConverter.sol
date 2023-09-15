//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getETHInUSD(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        (, int256 latestPrice, , , ) = priceFeed.latestRoundData();

        return uint256(latestPrice);
        //1632_52214616 dollars
    }

    function convertSentAmountInUSD(
        uint256 sentAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 AmountInUSD = (sentAmount * getETHInUSD(priceFeed)) / 1e18;
        return AmountInUSD;
    }
}
