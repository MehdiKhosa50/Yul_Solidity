// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

contract Memory {
    // Define a struct to hold three uint256 values (x, y, z)
    struct Point {
        uint256 x;
        uint256 y;
        uint256 z;
    }    

    // Events to log memory pointer locations for debugging
    event MemoryPointer(bytes32);
    event MemoryPointerV2(bytes32, bytes32);
    event Debug(bytes32, bytes32, bytes32, bytes32);

    // Function to read a high value from a specific memory location
    function readHighValue() external pure {
        assembly {
            // 'pop' is used here to discard the value read from memory location 0xffffffffffffffff
            pop(mload(0xffffffffffffffff))
        }
    }

    // Function to demonstrate different uses of mstore and mstore8
    function differentMstore() external pure {
        assembly {
            // mstore8 writes a byte at the memory location 0x00
            mstore8(0x00, 5)
            // mstore writes a full 32-byte word to the memory location 0x00
            mstore(0x00, 5)
        }
    }

    // Function to demonstrate storing a struct in memory and logging pointer location
    function structMemory() external {
        bytes32 x40;
        assembly {
            // Get the current free memory pointer (location where new memory will be allocated)
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);

        // Define a Point struct and initialize with values
        Point memory p = Point({x: 1, y: 2, z: 3});
        bytes32 structLocation;
        assembly {
            // Store the new free memory pointer after the struct is created
            x40 := mload(0x40)
            structLocation := p
        }
        emit MemoryPointerV2(x40, structLocation);  // Emit the memory pointer and struct location
    }

    // Function to demonstrate struct memory manipulation and logging both pointer and memory size
    function structMemoryV2() external {
        bytes32 x40;
        bytes32 size;
        assembly {
            // Store the free memory pointer and the current memory size
            x40 := mload(0x40)
            size := msize()
        }
        emit MemoryPointerV2(x40, size);

        // Define a Point struct and initialize it
        Point memory p = Point({x: 1, y: 2, z: 3});
        bytes32 structLocation;
        assembly {
            // Store updated free memory pointer and size after using the struct
            x40 := mload(0x40)
            size := msize()
            structLocation := p
        }
        emit Debug(x40, size, structLocation, 0);  // Emit the updated pointers and struct location
    }

    // Function to demonstrate memory allocation and changes with fixed-size array
    function fixedArray() external {
        bytes32 x40;
        assembly {
            // Capture the memory pointer before creating the array
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);

        // Define and initialize a fixed-size array of uint256
        uint256[2] memory arr = [uint256(5), uint256(6)];
        bytes32 arrayLocation;
        assembly {
            // Store the updated free memory pointer after the array is created
            x40 := mload(0x40)
            arrayLocation := arr
        }
        emit MemoryPointerV2(x40, arrayLocation);  // Emit the new memory pointer and array location
    }

    // Function to demonstrate using abi.encode to encode data
    function abiEncode() external {
        bytes32 x40;
        assembly {
            // Store the current free memory pointer
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);

        // Encode data using abi.encode for uint256(5) and uint256(6)
        bytes memory encoded = abi.encode(uint256(5), uint256(6));
        assembly {
            // Capture the updated memory pointer after encoding
            x40 := mload(0x40)
        }
        emit MemoryPointerV2(x40, bytes32(encoded.length));  // Emit the memory pointer and the encoded data length
    }

    // Function to demonstrate encoding with different data types using abi.encode
    function abiEncode2() external {
        bytes32 x40;
        assembly {
            // Store the initial free memory pointer
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);

        // Encode data with uint256(5) and uint128(6)
        bytes memory encoded = abi.encode(uint256(5), uint128(6));
        assembly {
            // Capture the updated memory pointer after encoding
            x40 := mload(0x40)
        }
        emit MemoryPointerV2(x40, bytes32(encoded.length));  // Emit the memory pointer and encoded data length
    }

    // Function to demonstrate packed encoding using abi.encodePacked
    function abiEncodePacked() external {
        bytes32 x40;
        assembly {
            // Store the current free memory pointer
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);

        // Perform packed encoding with multiple data types
        bytes memory encoded = abi.encodePacked(uint256(5), uint128(6), uint8(3));
        assembly {
            // Capture the memory pointer after packed encoding
            x40 := mload(0x40)
        }
        emit MemoryPointerV2(x40, bytes32(encoded.length));  // Emit memory pointer and length of packed encoded data
    }

    // Function to demonstrate reading and working with array values in memory
    function arrayValues(uint256[] memory arr) external {
        bytes32 location;
        bytes32 len;
        bytes32 valueAtIndex0;
        bytes32 valueAtIndex1;
        assembly {
            // Capture memory location, length, and values at specific indices of the array
            location := arr
            len := mload(arr)
            valueAtIndex0 := mload(add(arr, 0x20))
            valueAtIndex1 := mload(add(arr, 0x40))
        }
        emit Debug(location, len, valueAtIndex0, valueAtIndex1);  // Emit memory location, length, and values at indices 0 and 1
    }

    // Function to demonstrate manipulation of memory pointer with an array
    function breakFreeMemoryPointer(uint256[1] memory foo)
        external
        pure
        returns (uint256)
    {
        assembly {
            // Update the free memory pointer to a new location
            mstore(0x40, 0x80)
        }
        // Initialize a new array and return a value using both the original and new array
        uint256[1] memory bar = [uint256(6)];
        return bar[0] + foo[0];  // Return sum of elements from both arrays
    }
}