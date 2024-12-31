// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Storage {

    // Declare and initialize three uint256 variables, each occupying 32 bytes of storage
    uint256 x = 3;    // 32 bytes
    uint256 y = 5;    // 32 bytes
    uint256 z = 7;    // 32 bytes

    // Declare and initialize two uint128 variables, each occupying 16 bytes of storage
    uint128 a = 1;     // 16 bytes
    uint128 b = 2;     // 16 bytes

    // This function allows you to store a new value in a specific storage slot
    // It uses inline assembly to directly access storage and modify the value at the given slot
    function storeYulVal(uint256 slot, uint256 newValue) external {
        assembly {            
            sstore(slot, newValue) // Store the new value at the specified slot
        }
    }

    // This function returns the storage slot of the variable `a`
    // It uses inline assembly to retrieve the slot number of the variable `a`
    function getSlot() external pure returns(uint256 slot) {
        assembly {
            slot := a.slot // Retrieve the storage slot of `a`
        }
    }

    // This function loads the content of a given storage slot and returns it as a 32-byte value (bytes32)
    // It uses inline assembly to read the value from the specified slot and returns it as bytes32
    function loadYulSlotInBytes(uint256 slot) external view returns(bytes32 ret) {
        assembly {
            ret := sload(slot) // Load the value from the specified slot
        }
    }

    // This function loads the content of a given storage slot and returns it as a uint256 value
    // It uses inline assembly to read the value from the specified slot and returns it as uint256
    function loadYul(uint256 slot) external view returns(uint256 ret) {
        assembly {
            ret := sload(slot) // Load the value from the specified slot
        }
    }

    // This function returns the storage slot of the variable `x`
    // It uses inline assembly to retrieve the slot number of the variable `x`
    function getXSlot() external pure returns(uint256 ret) {
        assembly {
            ret := x.slot // Retrieve the storage slot of `x`
        }
    }

    // This function returns the storage slot of the variable `y`
    // It uses inline assembly to retrieve the slot number of the variable `y`
    function getYSlot() external pure returns(uint256 ret) {
        assembly {
            ret := y.slot // Retrieve the storage slot of `y`
        }
    }

    // This function returns the storage slot of the variable `z`
    // It uses inline assembly to retrieve the slot number of the variable `z`
    function getZSlot() external pure returns(uint256 ret) {
        assembly {
            ret := z.slot // Retrieve the storage slot of `z`
        }
    }

    // This function allows the user to set a new value for the variable `x`
    // It is a regular Solidity function that updates the value of `x` in storage
    function setX(uint256 newX) public {
        x = newX; // Update the value of `x` to the new value provided
    }

    // This function retrieves and returns the current value of `x`
    // It is a regular Solidity function that returns the value of `x` from storage
    function retrieve() public view returns (uint256){
        return x; // Return the current value of `x`
    }

}