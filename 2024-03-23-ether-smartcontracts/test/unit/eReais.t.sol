//License SPX-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {eReais} from "../../src/eReais.sol";
import {eReaisDeploy} from "../../script/eReaisDeploy.s.sol";

contract eReaisTest is Test{
	eReais reais;
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant COMPLIANCE_ROLE = keccak256("COMPLIANCE_ROLE");
    bytes32 public constant TRANSFER_ROLE = keccak256("TRANSFER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
	
	address Barba = makeAddr("Barba");
    address defaultAdmin = makeAddr("defaultAdmin");
    address pauser = makeAddr("pauser");
    address minter = makeAddr("minter");
    address burner = makeAddr("burner");
    address complianceOfficer = makeAddr("complianceOfficer");
    address transferOfficer = makeAddr("transferOfficer");

    uint256 valueToMint = 10 * 10e18;

	
	function setUp() external{
		eReaisDeploy deploy = new eReaisDeploy();
		reais = deploy.run(defaultAdmin, pauser, minter, burner, complianceOfficer, transferOfficer);
	}
	
    error AccessControlUnauthorizedAccount(address account, bytes role);
    event Transfer(address from, address to, uint256 value);
	function test_ifIssueFunctionsWorksAsExpected() public {
        // vm.prank(Barba);
        // vm.expectRevert(abi.encodeWithSelector(AccessControlUnauthorizedAccount.selector, Barba, MINTER_ROLE));
        // reais.issue(Barba, valueToMint);

        // assertEq(reais.balanceOf(Barba), 0);

        vm.prank(minter);
        vm.expectEmit();
        emit Transfer(address(0), Barba, valueToMint);
        reais.issue(Barba, valueToMint);

        assertEq(reais.balanceOf(Barba), valueToMint);
    }
}