// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

contract StoragePart3 {

    // Fixed-length array (size of 3 elements)
    uint256[3] fixedLengthArray;

    // Dynamic array (can grow in size)
    uint256[] dynamicArray;

    // Small dynamic array of uint16 values (2 bytes each)
    uint16[] smallArray;

    // Simple mapping (key-value pair, uint256 to uint256)
    mapping(uint256 => uint256) private myMapping;

    // Nested mapping (two layers of mappings)
    mapping(uint256 => mapping(uint256 => uint256)) public nestedMapping;

    // Mapping from an address to a list of uint256 values
    mapping(address => uint256[]) public mappingAddressToList;

    // Constructor that initializes arrays and mappings with predefined values
    constructor() {
        // Initialize fixed-length array with 3 values
        fixedLengthArray = [100,199,465];
        
        // Initialize dynamic array with 5 values
        dynamicArray = [100,7,899,999, 4584];
        
        // Initialize small array with 3 values (uint16 type)
        smallArray = [1, 2, 3];
        
        // Set a value in the mapping (key: 1, value: 10000)
        myMapping[1] = 10000;
        
        // Set a value in the nested mapping (key: 1, subkey: 2, value: 8589565)
        nestedMapping[1][2] = 8589565;
        
        // Set an address mapping to a list of 4 uint256 values
        mappingAddressToList[0x93f8dddd876c7dBE3323723500e83E202A7C96CC] = [777,7888,55555, 999];
    }

    // Function to read a value from the fixed-length array at a specific index
    function readFixedArray(uint256 index) external view returns(uint256 ret) {
        assembly {
            let slot := fixedLengthArray.slot  // Get the storage slot for fixedLengthArray
            ret := sload(add(slot, index))      // Load value at the given index
        }
    }

    // Function to write a value to the fixed-length array at a specific index
    function writeToFixedArray(uint256 index, uint256 value) external {
        assembly {
            let slot := fixedLengthArray.slot  // Get the storage slot for fixedLengthArray
            sstore(add(slot, index), value)     // Store the new value at the given index
        }
    }

    // Function to get the length of the dynamic array
    function dynamicArrayLength() external view returns (uint256 ret) {
        assembly {
            ret := sload(dynamicArray.slot)    // Load the length of dynamicArray
        }
    }

    // Function to read a specific element in the dynamic array by its index
    function readDynamicArrayLocation(uint256 index) external view returns (uint256 ret) {
        uint256 slot;
        assembly {
            slot := dynamicArray.slot  // Get the storage slot for dynamicArray
        }

        // Compute the location of the element using keccak256 hash
        bytes32 location = keccak256(abi.encode(slot));

        assembly {
            ret := sload(add(location, index))  // Load the value at the given index
        }
    }

    // Function to read the first value of the small array (note: only the first element)
    function readSmallArray() external view returns (uint256 ret) {
        assembly {
            ret := sload(smallArray.slot)   // Load the first value in smallArray
        }
    }

    // Function to read a specific element in the small array using its index
    function readSmallArrayLocation(uint256 index) external view returns (bytes32 ret) {
        uint256 slot;
        assembly {
            slot := smallArray.slot  // Get the storage slot for smallArray
        }

        // Compute the location of the element using keccak256 hash
        bytes32 location = keccak256(abi.encode(slot));

        assembly {
            ret := sload(add(location, index))  // Load the value at the given index
        }
    }

    // Function to retrieve a value from the myMapping mapping based on a provided key
    function getMappingValue(uint256 key) external view returns (uint256 ret) {
        uint256 slot;
        assembly {
            slot := myMapping.slot  // Get the storage slot for myMapping
        }

        // Compute the location of the value using keccak256 hash (key and slot)
        bytes32 location = keccak256(abi.encode(key, uint256(slot)));

        assembly {
            ret := sload(location)  // Load the value associated with the given key
        }
    }

    // Function to retrieve a value from the nestedMapping mapping
    function getNestedMapping() external view returns (uint256 ret) {
        uint256 slot;
        assembly {
            slot := nestedMapping.slot  // Get the storage slot for nestedMapping
        }

        // Compute the location of the value in the nested mapping using keccak256
        bytes32 location = keccak256(
            abi.encode(
                uint256(2),  // First key in the nested mapping (subkey)
                keccak256(    // Hash the second key (primary key)
                    abi.encode(
                        uint256(1), uint256(slot)  // Primary key (1) and slot location
                    )
                )
            )
        );

        assembly {
            ret := sload(location)  // Load the value from the computed location
        }
    }

    // Function to get the length of a list in mappingAddressToList for a specific address
    function lengthOfNestedMappingList() external view returns (uint256 ret) {
        uint256 addressToListSlot;
        assembly {
            addressToListSlot := mappingAddressToList.slot  // Get the storage slot for mappingAddressToList
        }

        // Compute the location for the list of uint256 values for a specific address
        bytes32 location = keccak256(
            abi.encode(
                address(0x93f8dddd876c7dBE3323723500e83E202A7C96CC),  // Address to map
                uint256(addressToListSlot)  // Slot of the mapping
            )
        );

        assembly {
            ret := sload(location)  // Load the length of the list from the computed location
        }
    }

    // Function to retrieve a specific value from the list in mappingAddressToList for a specific address
    function getAddressToList(uint256 index)
        external
        view
        returns (uint256 ret)
    {
        uint256 slot;
        assembly {
            slot := mappingAddressToList.slot  // Get the storage slot for mappingAddressToList
        }

        // Compute the location of the element using keccak256
        bytes32 location = keccak256(
            abi.encode(
                keccak256(    // Compute the hash of the address and its slot
                    abi.encode(
                        address(0x93f8dddd876c7dBE3323723500e83E202A7C96CC),  // Address to map
                        uint256(slot)  // Slot of the mapping
                    )
                )
            )
        );

        assembly {
            ret := sload(add(location, index))  // Load the value at the given index
        }
    }

}