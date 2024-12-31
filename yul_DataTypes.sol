// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract YulDataTypes {
    
    // Function to demonstrate how to assign and return a uint256 value using Yul assembly
    function getUnit256() external pure returns (uint256) {
        uint256 value;

        assembly {
            value := 100 // Assign the value 100 to the variable 'value'
        }

        return value; // Return the assigned value
    }

    // Function to demonstrate how to assign and return a hexadecimal value as uint256 using Yul assembly
    function getHex() external pure returns (uint256) {
        uint256 hexValue;

        assembly {
            hexValue := 0x64 // Assign the hexadecimal value 0x64 (decimal 100) to 'hexValue'
        }

        return hexValue; // Return the assigned hexadecimal value
    }

    // Function to demonstrate assigning and returning an address using Yul assembly
    function getAddress() external pure returns (address) {
        address myAddress;

        assembly {
            // Assign a hardcoded address value to 'myAddress'
            myAddress := 0x1234567890abcdef1234567890abcdef12345678
        }

        return myAddress; // Return the assigned address
    }

    // Function to demonstrate assigning and returning a boolean value using Yul assembly
    function getBoolean() external pure returns (bool) {
        bool isTrue;

        bytes32 zero = bytes32(0); // Define a zero value as a 32-byte value

        assembly {
            // Assign the 'zero' value to 'isTrue'
            isTrue := zero // This will evaluate to 'false' because the value is zero
        }

        return isTrue; // Return the boolean value
    }

    // Function to demonstrate assigning and returning a bytes32 value using Yul assembly
    function demoBytes32() external pure returns (bytes32) {
        bytes32 demo = "";

        assembly {
            // Assign the string "Hello World!" as a bytes32 value (ASCII encoded)
            demo := "Hello World!" 
            // Actual bytes32 value: 0x48656c6c6f20576f726c64210000000000000000000000000000000000000000
        }

        return demo; // Return the bytes32 value
    }

    // Function to demonstrate assigning and returning a string using Yul assembly
    function demoString() external pure returns (string memory) {
        string memory demo;

        assembly {
            let data := "Hello World!" // Raw string data (ASCII encoded)

            // Allocate memory for the string (32 bytes for length + 32 bytes for data)
            demo := mload(0x40) // Get the current free memory pointer
            mstore(0x40, add(demo, 64)) // Update the free memory pointer to reserve space

            // Store the length of the string
            mstore(demo, 12) // "Hello World!" is 12 bytes long

            // Store the actual string data
            mstore(add(demo, 32), data) // Write the string data 32 bytes after the length
        }

        return demo; // Return the properly formatted string
    }
}