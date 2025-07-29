// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// library BytecodeStorageFactory {
abstract contract BytecodeStorageFactory {
    error Create2FailedDeployment();

    function getBytecode(bytes memory data, address implementation)
        internal
        pure
        returns (bytes memory)
    {
        return
            abi.encodePacked(
                hex"3d60",                           // RETURDATASIZE, PUSH
                uint8(0x2d + data.length),          // size of minimal proxy (45 bytes) + size of data
                hex"80",                             // DUP1
                hex"600a",                           // PUSH1 creation code length(10 bytes)
                hex"3d3981f3363d3d373d3d3d363d73",   // DUP1, PUSH1, default offset 0a, standard EIP1167 implementation
                implementation,                      // implementation address
                hex"5af43d82803e903d91602b57fd5bf3", // standard EIP1167 implementation
                data                                // data saved on bytecode storage
            );
    }

    function deploy(bytes memory bytecode, uint256 salt) internal returns(address) {
        address addr;

        assembly {
            addr := create2(
                0, // callvalue()
                add(bytecode, 0x20), // offset
                mload(bytecode), // length
                salt // salt
            )
        }

        if(addr == address(0)) {
            revert Create2FailedDeployment();
        }
            
        return addr;
    }
}