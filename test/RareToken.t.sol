// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {RareToken} from "../src/RareToken.sol";

contract RareTokenTest is Test {
    
    // State variables for testing
    RareToken public token;
    address public owner;
    address public alice;
    address public bob;
    address public charlie;
    
    // Runs before EACH test function
    function setUp() public {
        owner = address(this);
        alice = makeAddr("alice");  // Creates labeled address
        bob = makeAddr("bob");
        charlie = makeAddr("charlie");
        
        // Deploy token with 1000 initial supply
        token = new RareToken("RareToken", "RARE", 1000);
    }
    
    // Test functions MUST start with "test"
    function testName() public view {
        assertEq(token.name(), "RareToken");
    }

    function testSymbol() public view {
        assertEq(token.symbol(),"RARE");
    }

    function testDecimals() public view {
        assertEq(token.decimals(),18);
    }

    function testTotalSupply() public view {
        assertEq(token.totalSupply(),1000 *10** token.decimals());
    }

    function testTransfer() public {

        uint256 precallOwnerBalance = token.balanceOf(owner);

        uint256 amount = 100 * 10 ** token.decimals();
        
        token.transfer(alice, amount);

        uint256 postcallOwnerBalance = token.balanceOf(owner);
        
        assertEq(token.balanceOf(alice), amount);
        assertEq(postcallOwnerBalance,precallOwnerBalance - amount);
    }

    function testApprove() public {

        uint256 amount = 100 * 10 ** token.decimals();

        token.approve(bob, amount);

        assertEq(token.allowance(owner, bob), amount);
    }

    function testTransferFromMultipleTransfers() public {
        uint256 approveAmount = 100 * 10 ** token.decimals();
        uint256 firstTransfer = 30 * 10 ** token.decimals();
        uint256 secondTransfer = 50 * 10 ** token.decimals();
        
        token.approve(alice, approveAmount);
        
        // First transfer
        vm.prank(alice);
        token.transferFrom(owner, bob, firstTransfer);
        
        // Second transfer
        vm.prank(alice);
        token.transferFrom(owner, charlie, secondTransfer);
        
        // Assertions
        assertEq(token.balanceOf(bob), firstTransfer);
        assertEq(token.balanceOf(charlie), secondTransfer);
        assertEq(token.allowance(owner, alice), approveAmount - firstTransfer - secondTransfer);
    }
}