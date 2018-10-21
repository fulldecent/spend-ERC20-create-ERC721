pragma solidity ^0.4.25;

import "openzeppelin-solidity/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-solidity/access/Roles.sol";

/**
 * This is an access control role for entities that may spend tokens
 */
contract SpenderRole {
  using Roles for Roles.Role;

  event SpenderAdded(address indexed account);
  event SpenderRemoved(address indexed account);

  Roles.Role private spenders;

  constructor() internal {
    _addSpender(msg.sender);
  }

  modifier onlySpender() {
    require(isSpender(msg.sender));
    _;
  }

  function isSpender(address account) public view returns (bool) {
    return spenders.has(account);
  }

  function addSpender(address account) public onlySpender {
    _addSpender(account);
  }

  function renounceSpender() public {
    _removeSpender(msg.sender);
  }

  function _addSpender(address account) internal {
    spenders.add(account);
    emit SpenderAdded(account);
  }

  function _removeSpender(address account) internal {
    spenders.remove(account);
    emit SpenderRemoved(account);
  }
}

/**
 * @dev ERC20 spender logic
 */
contract ERC20Spendable is ERC20, SpenderRole {
  /**
   * @dev Function to mint tokens
   * @param from The address that will spend the tokens
   * @param value The amount of tokens to spend
   * @return A boolean that indicates if the operation was successful
   */
  function spend(
    address from,
    uint256 value
  )
    public
    onlySpender
    returns (bool)
  {
    _burn(from, value);
    return true;
  }
}

contract AriaToken is ERC20, ERC20Mintable, ERC20Spendable {

    /**
     * @dev For testing purposes, this allows anybody to mint tokens. Simply
     *     remove this line for production use so the ERC20Mintable contract
     *     can provide a more secure minter role.
     */
    function mint(address to, uint256 value) 
        public 
        /*onlyMinter*/
        returns (bool)
    {
        _mint(to, value);
        return true;
    }
}