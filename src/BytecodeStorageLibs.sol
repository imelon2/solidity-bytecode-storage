// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {BytecodeStorage} from "./BytecodeStorage.sol";
import {BytecodeStorageFactory} from "./BytecodeStorageFactory.sol";

abstract contract BytecodeStorageLibs is BytecodeStorageFactory {
    // using BytecodeStorageFactory for bytes;
    address private implementation;

    mapping(uint256 => address) private pointer;

    constructor() { 
        implementation = address(new BytecodeStorage());
    }

    function store(uint256 key, bytes memory value) internal  {
        pointer[key] = deploy(getBytecode(value, implementation),key);

        // bytes memory bytecode = value.getBytecode(address(implementation));
        // pointer[key] = bytecode.deploy(key);
    }

    function get(uint256 key) internal view returns(bytes memory) {
        return BytecodeStorage(pointer[key]).get();
    }
}