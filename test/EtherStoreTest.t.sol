// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {EtherStore} from "../src/EtherStore.sol";
import {Test, console} from "forge-std/Test.sol";
import {DeployEtherStore} from "../script/DeployEtherStore.s.sol";

contract TestEtherStore is Test{
    EtherStore public etherStore;

    address public ALICE = makeAddr('ALICE');

    function setUp() external {
        DeployEtherStore deployer = new DeployEtherStore();
        etherStore = deployer.run();
        deal(ALICE, 100 ether);
    }

    function testCanDeposit() external {
        vm.startPrank(ALICE);
        
        uint256 depositAmount = 10 ether;
        etherStore.deposit{value: depositAmount}();

        uint256 balance = etherStore.getBalances();
        assertEq(balance, depositAmount, "Deposit failed: Incorrect balance");
        vm.stopPrank();
    }

    modifier deposited {
        vm.startPrank(ALICE);
        uint256 depositAmount = 10 ether;
        etherStore.deposit{value: depositAmount}();
        vm.stopPrank();
        _;
    }

    function testCanWithdraw() external deposited {
        uint256 amountToWithdraw = 5 ether;
        
        vm.startPrank(ALICE);
        uint256 amountBefore = etherStore.getBalances();
        etherStore.withdraw(amountToWithdraw);
        uint256 amountAfter = etherStore.getBalances();
        vm.stopPrank();

        assertEq(amountBefore - amountToWithdraw, amountAfter);
    }

    function testGetBalances() external {
        vm.startPrank(ALICE);
        assertEq(etherStore.getBalances(), 0);
        vm.stopPrank();
    }

    function testConsole() external view {
        console.log(address(ALICE).balance);
    }
}