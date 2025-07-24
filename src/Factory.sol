// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Create2} from "@openzeppelin/contracts/utils/Create2.sol";



abstract contract Factory {
    struct EscrowInfo {
        address _shipper; // shipper의 주소
        address _carrier; // carrier의 주소
        uint256 _deliveryCost; // shipper의 운송비용
    }

    
    error Create2FailedDeployment(); 

    address private implementation;

    mapping(uint256 => address) private pointer;

    constructor(address _implementation) {
        implementation = _implementation;
    }

    function store(uint256 key, bytes memory value) external  {
        pointer[key] = deploy(getBytecode(value), key);
    }

    function get(uint256 key) external view returns(bytes memory) {
        bytes memory data = new bytes( 0x60 /* 96 */ );
        address point = pointer[key];
        assembly {
            extcodecopy(point, add(data, 0x20), 0x2d /* 45 */, 0x60 /* 96 */)
        }

        return data;
    }

    function getBytecode(bytes memory data)
        internal
        view
        returns (bytes memory)
    {
        return
            abi.encodePacked(
                hex"3d60", // RETURDATASIZE, PUSH2
                uint8(0x2d + data.length), // size of minimal proxy (45 bytes) + size of data
                hex"8060",
                hex"0b",
                hex"3d3981f3363d3d373d3d3d363d73", // DUP1, PUSH1, default offset 0a, standard EIP1167 implementation
                implementation,                          // implementation address
                hex"5af43d82803e903d91602b57fd5bf3",     // standard EIP1167 implementation
                data                                   // data saved on bytecode storage
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