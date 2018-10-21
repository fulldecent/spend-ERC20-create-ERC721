# Spend ERC-20 Create ERC-721

This is a technology demonstration showing a simple token usage scenario.

1. You sell utility tokens to your customers (ICO)
2. Your customers spend these tokens and create certificates
3. Anybody can verify the certificates

## Try the demo

Install MetaMask or other Web3-compatible browser setup, get a few Ether from a free faucet and load the demonstration website.

**Demo website: https://fulldecent.github.io/spend-ERC20-create-ERC721/**

## How does it work

**ERC-721 certificate contract** — This is a standard ERC-721 contract implemented using the [0xcert template](https://github.com/0xcert/ethereum-erc721/tree/master/contracts/tokens) with additional functions:

* `create(bytes32 dataHash) returns (uint256)` — Allows anybody to create a certificate (NFT). Causes the side effect of deducting a certain amount of money from the user, payable in ERC-20 tokens. The return value is a serial number.
* `hashForToken(uint256 tokenId) view` — Allows anybody to find the data hash for a given serial number.
* `mintingPrice() view` — Returns the price.
* `mintingCurrency() view` — Returns the currency (ERC-20)
* `setMintingPrice(uint256)` — Allows owner (see [0xcert ownable contract](https://github.com/0xcert/ethereum-utils/blob/master/contracts/ownership/Ownable.sol)) to set price
* `setMintingCurrency(ERC20 contract)`  — Allows owner (see [0xcert ownable contract](https://github.com/0xcert/ethereum-utils/blob/master/contracts/ownership/Ownable.sol)) to set currency

**ERC-20 token contract** — This is a standard ERC-721 contract implemented using the [OpenZeppelin template](https://github.com/OpenZeppelin/openzeppelin-solidity/tree/master/contracts/token/ERC20) for ERC-20 including Minter extension also with additional functions:

* `isSpender(address) view`, `addSpender(address)`, `renounceSpender()` — A new role for tracking who may spend these tokens, see [OpenZeppelin roles library](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/access/Roles.sol)
* `spend(account from, uint256 value)` — Allows an authorized spender to deduct money from a specific account's balance
* `mint(address to, uint256 value)`  — **FOR DEMO PURPOSES ONLY.** This implements the Minter role to allow ANYBODY to create tokens for free. This allows the demo to be used for anybody free of cost.

## Deployment

When you deploy the certificate and token contracts then you will be the owner with permissions to finish the deployment.

* Authorize the certificate contract as a spender for the tokens
* Set the tokens as the spendable currency for the certificate

**Watch deployment: https://www.youtube.com/watch?v=3SiMPZbwlR0**

## Contract development

I recommend saving these files on localhost and then developing using [Remix IDE](http://remix.ethereum.org). Follow this process using the command line:

1. Install remixd using `npm install remixd`
2. Switch into the project folder and run `remixd -s .`
3. Open Remix IDE and click the connect button
4. Develop and run the contract from Remix IDE

## Attribution

This project was created by William Entriken. Thank you to Arianee for funding the development of this technology demonstration.