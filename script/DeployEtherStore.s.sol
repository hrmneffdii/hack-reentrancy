// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {EtherStore} from "../src/EtherStore.sol";

contract DeployEtherStore is Script{
    EtherStore public etherStore;
    
    function run() external returns(EtherStore) {
        vm.startBroadcast();
        etherStore = new EtherStore();
        vm.stopBroadcast();

        return etherStore;
    }
}