// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BytecodeStorageLibs} from "../BytecodeStorageLibs.sol";

enum EscrowStatus { Pending, Completed, Cancelled, Disputed }

struct EscrowInfo {
    uint256 id;
    address depositor;
    address beneficiary;
    uint256 amount;
    uint256 deadline;
    EscrowStatus status;
}
contract SimpleEscrow is BytecodeStorageLibs {

    constructor() BytecodeStorageLibs() {
    }

    function getEscrowInfo(uint256 id) external view returns(EscrowInfo memory info) {
        info = abi.decode(get(id),(EscrowInfo));
    }

    function saveEscrowInfo(EscrowInfo memory info) external {
        store(info.id,abi.encode(info));
    }
}


contract SimpleEscrowLegacy {
    mapping(uint256 => EscrowInfo) private _info;


    function getEscrowInfo(uint256 id) external view returns(EscrowInfo memory info) {
        info = _info[id];
    }

    function saveEscrowInfo(EscrowInfo memory info) external {
        _info[info.id] = info;
    }
}