// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import { Test } from "forge-std/Test.sol";
import {SimpleEscrow,SimpleEscrowLegacy,EscrowInfo, EscrowStatus} from "../src/sample/SimpleEscrow.sol";

contract TestSimpleEscrow is Test {

    SimpleEscrow public simpleEscrow;
    SimpleEscrowLegacy public simpleEscrowLegacy;

    EscrowInfo public dummy;

    function setUp() public {
        simpleEscrow = new SimpleEscrow();
        simpleEscrowLegacy = new SimpleEscrowLegacy();
    }

    function test_SimpleEscrow_Save() external {
        simpleEscrow.saveEscrowInfo(getDummy(1));
    }

    function test_SimpleEscrowLegacy_Save() external {
        simpleEscrowLegacy.saveEscrowInfo(getDummy(1));
    }

    function getDummy(uint256 id) internal returns(EscrowInfo memory dummy) {
        dummy = EscrowInfo({
            id: id,
            depositor: 0x1111111111111111111111111111111111111111,
            beneficiary: 0x2222222222222222222222222222222222222222,
            amount: 1 ether,
            deadline: block.timestamp,
            status: EscrowStatus.Pending
        });
    }
}