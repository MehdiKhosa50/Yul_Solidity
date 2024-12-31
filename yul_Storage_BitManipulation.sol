// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

contract StoragePart2 {

    // Declare state variables with different integer types. These variables occupy different storage slots due to their sizes.
    uint128 public A = 1;     // 16 bytes, occupies part of a 32-byte slot
    uint96  public B = 2;     // 12 bytes, occupies part of a 32-byte slot
    uint16  public C = 4;     // 2 bytes, occupies part of a 32-byte slot
    uint8   public D = 5;     // 1 byte, occupies part of a 32-byte slot
    
    // Note: All variables (A, B, C, D) together occupy a total of 32 bytes in storage (slot 0).

    // Function to load a value from a specific storage slot and return it as bytes32
    // It uses inline assembly to interact with the EVM directly.
    function loadYulSlotInBytes(uint256 slot) external view returns(bytes32 ret) {
        assembly {
            ret := sload(slot) // Load the value from the specified storage slot
        }
    }

    // Function to get the storage slot and offset for variable `A`
    // Returns both the storage slot number and the offset in that slot
    function getOffsetA() external pure returns (uint256 slot, uint256 offset) {
        assembly {
            slot := A.slot       // Get the storage slot for variable `A`
            offset := A.offset   // Get the offset of `A` within the slot
        }
    }

    // Function to get the storage slot and offset for variable `B`
    // Returns both the storage slot number and the offset in that slot
    function getOffsetB() external pure returns (uint256 slot, uint256 offset) {
        assembly {
            slot := B.slot       // Get the storage slot for variable `B`
            offset := B.offset   // Get the offset of `B` within the slot
        }
    }

    // Function to get the storage slot and offset for variable `C`
    // Returns both the storage slot number and the offset in that slot
    function getOffsetC() external pure returns (uint256 slot, uint256 offset) {
        assembly {
            slot := C.slot       // Get the storage slot for variable `C`
            offset := C.offset   // Get the offset of `C` within the slot
        }
    }

    // Function to get the storage slot and offset for variable `D`
    // Returns both the storage slot number and the offset in that slot
    function getOffsetD() external pure returns (uint256 slot, uint256 offset) {
        assembly {
            slot := D.slot       // Get the storage slot for variable `D`
            offset := D.offset   // Get the offset of `D` within the slot
        }
    }

    // Function to load a value from a specific storage slot and return it as a uint256
    // This function demonstrates direct access to a storage slot using inline assembly
    function loadYul(uint256 slot) external view returns(uint256 ret) {
        assembly {
            ret := sload(slot) // Load the value from the specified storage slot
        }
    }

    // Function to convert a uint256 value into bytes32 and return it
    // Demonstrates casting a 256-bit integer to bytes32 type
    function loadInBytes(uint256 value) external pure returns(bytes32 ret) {
        ret = bytes32(value); // Convert the uint256 value into a bytes32 value
    }

    // WARNING: This function should not be used in production due to potential security risks.
    // It demonstrates how to store a value in a specified storage slot using assembly.
    function storeYulVal(uint256 slot, uint256 newValue) external {
        assembly {            
            sstore(slot, newValue) // Store the new value at the specified slot
        }
    }

    // This function demonstrates how to update part of a variable in storage using bitwise operations.
    // It loads the current value of `C`, clears the bits for the part to be updated, 
    // shifts the new value into the correct position, and then combines them to store the new value back.
    // This is a common pattern for "packing" variables into slots efficiently.
    function writeToC(uint16 newC) external {
        assembly {
            // Load the current value of `C` from its storage slot
            let loadC := sload(C.slot)
            
            // Clear the bits of `C` that are going to be overwritten with new value
            let clearedC := and(
                   loadC,
                   0xffff0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff // Mask to clear the target bits
            )
            
            // Shift the new value `newC` to its appropriate position in storage (considering the offset of `C`)
            let shiftedNewC := shl(mul(C.offset, 8), newC)
            
            // Combine the cleared value with the shifted new value to update `C` in storage
            let newVal := or(shiftedNewC, clearedC)
            
            // Store the new value back to the storage slot for `C`
            sstore(C.slot, newVal)
        }
    }

    // This function is designed to read any offset within the storage slot of `C`
    // It uses the provided offset to shift the bits and extract the correct value.
    // The function currently reads the `C` slot and extracts the 16-bit value at the provided offset.
    // This function is an example of working with different parts of a variable stored in the same slot.
    function readOffset(uint256 offset) external view returns (uint256 ret) {
        assembly {
            // Load the current value of `C` from its storage slot
            let value := sload(C.slot)
            
            // Shift the value based on the given offset and mask it to extract the correct bits
            let shifted := shr(mul(offset, 8), value)
            ret := and(0xffff, shifted) // Mask to extract the lower 16 bits (assuming offset points to 16-bit data)
        }
    }

    // A specialized function to read the value of `C` at its specific offset
    // It demonstrates how the value of `C` is shifted and masked to retrieve only the relevant part of the value.
    function readOffsetC() external view returns (uint256 ret) {
        assembly {
            // Load the current value of `C` from its storage slot
            let value := sload(C.slot)
            
            // Shift the value based on the offset of `C` and mask to extract the relevant bits
            let shifted := shr(mul(C.offset, 8), value)
            
            // Mask to extract the correct 16-bit part of the shifted value
            ret := and(0xffff, shifted)
        }
    }
}