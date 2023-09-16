
# Foundry FundMe Smart Contract

## Introduction

This repository contains the Solidity smart contract code for Foundry FundMe, a decentralized crowdfunding platform. The smart contract enforces a minimum ETH contribution in USD and allows for fund withdrawals by the contract owner.

## Smart Contract Details

The smart contract, `FundMe.sol`, defines the FundMe contract, including functionality for funding, withdrawing funds, and accessing contract information. It utilizes Chainlink's AggregatorV3Interface for ETH to USD price conversion.

## Quick Start

To get started quickly, you can clone this repository using Git and follow the deployment and testing instructions provided below.

### Clone the Repository

```bash
git clone https://github.com/shrutic11/Foundry-Fund-Me-23.git
cd Foundry-Fund-Me-23
```

## Deployment

To deploy the FundMe smart contract, you can use the provided deployment script:

```bash
make deploy-anvil  # for deploying using a local RPC node (Anvil Network)
make deploy-sepolia # for deploying using a custom RPC node (Sepolia Network)
```

## Tests

The smart contract is tested using Forge's testing framework. Run the tests with the following commands:

```bash
make test-fundme-anvil      # Test fundme functionality on Anvil Network
make test-fundme-sepolia    # Test fundme functionality on Sepolia Network
make test-withdraw-anvil    # Test fund withdrawal on Anvil Network
make test-withdraw-sepolia  # Test fund withdrawal on Sepolia Network
```

## Usage

To use the smart contract, follow these steps:

1. **Fund the Project:**
   Call the `fund()` function, providing ETH as the value to fund the project. The function ensures that the contribution meets the minimum USD requirement.

2. **Withdraw Funds:**
   The contract owner can choose to withdraw funds using different methods: `withdrawTransfer()`, `withdrawSend()`, or `withdrawCall()`. Each method has its own approach for transferring funds to the contract owner.

# Libraries and Interfaces Used

## Solidity Libraries

- **PriceConverter**: A custom library used to convert ETH to USD based on the ETH to USD price feed obtained from Chainlink.

- **console** from `forge-std/Script.sol`: This is a library used for console logging.

## Smart Contract Interfaces

- **AggregatorV3Interface**: The interface for Chainlink's ETH to USD price feed.

## Helper Scripts

- **HelperConfig.s.sol**: A script to fetch the active network configuration.

## Deployment Scripts


- **DeployFundMe.s.sol**: A script to deploy the FundMe contract and set the ETH to USD price feed address.

## Makefile Commands

- Various `make` commands are provided for easy deployment and testing using different networks.

## License

This project is licensed under the [MIT License](LICENSE). See the LICENSE file for details.