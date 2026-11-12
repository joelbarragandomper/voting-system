// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Voting} from "../src/Voting.sol";

contract DeployVoting is Script {
    function run() public returns (Voting voting) {
        vm.startBroadcast();
        voting = new Voting();
        vm.stopBroadcast();
    }
}
