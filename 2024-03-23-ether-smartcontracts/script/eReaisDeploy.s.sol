//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol"; //Ferramenta do Foundry
import {eReais} from "../src/eReais.sol";//Contrato á ser deployado

contract eReaisDeploy is Script {

	function run(address defaultAdmin,
                 address pauser,
                 address minter,
                 address burner,
                 address complianceOfficer,
                 address transferOfficer
                ) external returns(eReais reais){
		
		vm.startBroadcast();
		
		reais = new eReais(defaultAdmin, pauser, minter, burner, complianceOfficer, transferOfficer);

		vm.stopBroadcast();
	}
}