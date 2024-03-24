// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

//@audit-informational named imports
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/// @custom:security-contact security@etherprivatebank.com.br
contract eReais is ERC20, ERC20Burnable, ERC20Pausable, AccessControl {
    //audit-gas should be private + getter if external access is needed.
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant COMPLIANCE_ROLE = keccak256("COMPLIANCE_ROLE");
    bytes32 public constant TRANSFER_ROLE = keccak256("TRANSFER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    //@audit-gas - use uint256 0&1 for false and true.
    mapping(address => bool) private _isBlacklisted;

    constructor(
        address defaultAdmin,
        address pauser,
        address minter,
        address burner,
        address complianceOfficer,
        address transferOfficer
    ) ERC20("eReais", "EBRL") {
        //Revert if the address is already registered in this role.
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        _grantRole(PAUSER_ROLE, pauser);
        _grantRole(MINTER_ROLE, minter);
        _grantRole(COMPLIANCE_ROLE, complianceOfficer);
        _grantRole(TRANSFER_ROLE, transferOfficer);
        _grantRole(BURNER_ROLE, burner);
    }

    //OZ Standart Library
    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    //OZ Standart Library
    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    //@audit-gas functions not used internally should be marked as external
    function issue(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        require(!_isBlacklisted[to], "Recipient is blacklisted");
        _mint(to, amount);
    }

    //@audit-gas functions not used internally should be marked as external
    function redeem(uint256 amount) public onlyRole(BURNER_ROLE) {
        _burn(_msgSender(), amount);
    }

    //@audit-gas functions not used internally should be marked as external
    function isBlacklisted(address _address) public view returns (bool) {
        return _isBlacklisted[_address];
    }

    //@audit-gas functions not used internally should be marked as external
    function blacklistAddress(address _address, bool _flag ) public onlyRole(COMPLIANCE_ROLE) {
        _isBlacklisted[_address] = _flag;
        //@audit-low storage update without event emission
    }

    //@audit-gas functions not used internally should be marked as external
    function destroyBlackFunds(address _blacklistAddress) public onlyRole(COMPLIANCE_ROLE) {
        require(_isBlacklisted[_blacklistAddress], "Address is not blacklisted");
        uint256 dirtyFunds = balanceOf(_blacklistAddress);
        _burn(_blacklistAddress, dirtyFunds);
        //@audit-low storage update without event emission
    }

    // The following functions are overrides required by Solidity.
    function _update(address from, address to, uint256 value) internal override(ERC20,ERC20Pausable) {
        super._update(from, to, value);
    }
}
