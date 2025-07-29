// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BytecodeStorage {
    function get() external view returns(bytes memory data) {
        uint256 codeLen;
        uint256 offset = 0x2d; // standard EIP1167 code length
        assembly {
            codeLen := extcodesize(address())
        }
        uint256 dataLen = codeLen - offset;
        data = new bytes(dataLen);

        assembly {
            dataLen := sub(extcodesize(address()),0x2d)
            extcodecopy(address(), add(data, 0x20), 0x2d , dataLen)
        }
    }
}