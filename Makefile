-include .env
build:; forge build

deploy-anvil:; forge script script/DeployFundMe.s.sol --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast -v

deploy-sepolia:; forge script script/DeployFundMe.s.sol --rpc-url $(SEPOLIA_RPC_URL) --private-key $(SEPOLIA_PRIVATE_KEY) --broadcast -v

fundFundMe-anvil:; forge script script/Interactions.s.sol:FundFundMe  --rpc-url http://127.0.0.1:8545 --private-key 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d  --broadcast -v

fundFundMe-sepolia:;forge script script/Interactions.s.sol:FundFundMe  --rpc-url $(SEPOLIA_RPC_URL)  --private-key $(SEPOLIA_PRIVATE_KEY)  --broadcast

withdrawFundMe-anvil:; forge script script/Interactions.s.sol:WithdrawFundMe  --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80  --broadcast -v
withdrawFundMe-sepolia:; forge script script/Interactions.s.sol:WithdrawFundMe  --rpc-url $(SEPOLIA_RPC_URL)  --private-key $(SEPOLIA_PRIVATE_KEY)  --broadcast -v

withdrawFundMeNotOwner-anvil:; forge script script/Interactions.s.sol:WithdrawFundMe  --rpc-url http://127.0.0.1:8545 --private-key 0x47e179ec197488593b187f80a00eb0da91f1b9d0b13f8733639f19c30a34926a  --broadcast -v

test-fundme-sepolia:; forge test --match-test testUserCanSendFundsToFundMeInteractions --rpc-url $(SEPOLIA_RPC_URL)  --private-key $(SEPOLIA_PRIVATE_KEY) -vvvv
test-withdraw-sepolia:; forge test --match-test testUserCanFundAndOwnerWithdraw --rpc-url $(SEPOLIA_RPC_URL) -vvvv
test-fundme-anvil:; forge test --match-test testUserCanSendFundsToFundMeInteractions --rpc-url http://127.0.0.1:8545 -vvvv
test-withdraw-anvil:; forge test --match-test testUserCanFundAndOwnerWithdraw --rpc-url http://127.0.0.1:8545 -vvvv
withdrawFundMeNotOwner-sepolia:; forge script script/Interactions.s.sol:WithdrawFundMe  $(SEPOLIA_RPC_URL) --private-key 7aa197e909618d0e615d8190b835005521c71a415fd2efa591f6b024519b9a18  --broadcast -v