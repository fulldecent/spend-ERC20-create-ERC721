pragma solidity ^0.4.25;

import "@0xcert/ethereum-erc721/contracts/tokens/NFToken.sol";
import "@0xcert/ethereum-utils/contracts/ownership/Ownable.sol";
import {ERC20Spendable} from "./AriaToken.sol";

/**
 * @notice A non-fungible certificate that anybody can create by spending tokens
 */
contract AriaCertificate is NFToken, Ownable
{
    /// @notice The price to create new certificates
    uint256 _mintingPrice;
    
    /// @notice The currency to create new certificates
    ERC20Spendable _mintingCurrency;

    /// @dev The serial number of the next certificate to create
    uint256 nextCertificateId = 1;
    
    mapping(uint256 => bytes32) certificateDataHashes;

    /**
     * @notice Query the certificate hash for a token
     * @param tokenId Which certificate to query
     * @return The hash for the certificate
     */
    function hashForToken(uint256 tokenId) external view returns (bytes32) {
        return certificateDataHashes[tokenId];
    }

    /**
     * @notice The price to create certificates
     * @return The price to create certificates
     */
    function mintingPrice() external view returns (uint256) {
        return _mintingPrice;
    }

    /**
     * @notice The currency (ERC20) to create certificates
     * @return The currency (ERC20) to create certificates
     */
    function mintingCurrency() external view returns (ERC20Spendable) {
        return _mintingCurrency;
    }

    /**
     * @notice Set new price to create certificates
     * @param newMintingPrice The new price
     */
    function setMintingPrice(uint256 newMintingPrice) onlyOwner external {
        _mintingPrice = newMintingPrice;
    }

    /**
     * @notice Set new ERC20 currency to create certificates
     * @param newMintingCurrency The new currency
     */
    function setMintingCurrency(ERC20Spendable newMintingCurrency) onlyOwner external {
        _mintingCurrency = newMintingCurrency;
    }
    
    /**
     * @notice Allows anybody to create a certificate, takes payment from the
     *   msg.sender
     * @param dataHash A representation of the certificate data using the Aria
     *   protocol (a 0xcert cenvention).
     * @return The new certificate ID
     *   
     */
    function create(bytes32 dataHash) external returns (uint) {
        // Take payment for this service
        _mintingCurrency.spend(msg.sender, _mintingPrice);
        
        // Create the certificate
        uint256 newCertificateId = nextCertificateId;
        _mint(msg.sender, newCertificateId);
        certificateDataHashes[newCertificateId] = dataHash;
        nextCertificateId = nextCertificateId + 1;
        
        return newCertificateId;
    }
}