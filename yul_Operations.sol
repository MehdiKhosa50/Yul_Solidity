// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

// Importing Hardhat's console log to enable debugging during development
import "hardhat/console.sol";

contract YulOperations {
    // Function to check if a number is prime using assembly
    function isPrime(uint256 x) public pure returns (bool p) {
        // Assume the number is prime initially
        p = true;

        assembly {
            // Calculate halfX = x / 2 + 1 to optimize the loop range
            let halfX := add(div(x, 2), 1)

            // Loop from i = 2 to halfX - 1 (prime checking range)
            for {
                let i := 2
            } lt(i, halfX) {
                i := add(i, 1)
            } {
                // If x is divisible by i (mod(x, i) == 0), it's not a prime number
                if iszero(mod(x, i)) {
                    p := 0 // Set p to false (not prime)
                    break // Exit the loop early as we found a divisor
                }
            }
        }
    }

    // Function to add two numbers using assembly
    function checkAdd(uint256 a, uint256 b) external pure returns (uint256 c) {
        assembly {
            // Use the assembly add function to add a and b
            c := add(a, b)
        }
    }

    // Function to divide two numbers using assembly
    function checkDiv(uint256 a, uint256 b) external pure returns (uint256 c) {
        assembly {
            // Use the assembly div function to divide a by b
            c := div(a, b)
        }
    }

    // Function to check if a is less than b using assembly
    function checkLt(uint256 a, uint256 b) external pure returns (uint256 c) {
        assembly {
            // Use the assembly lt function to check if a < b
            c := lt(a, b)
        }
    }

    // Function to calculate the modulus of a and b using assembly
    function checkMod(uint256 a, uint256 b) external pure returns (uint256 c) {
        assembly {
            // Use the assembly mod function to calculate a % b
            c := mod(a, b)
        }
    }

    // Function to check if a number is zero using assembly
    function checkZero(uint256 a) external pure returns (bool c) {
        assembly {
            // Use the assembly iszero function to check if a is 0
            c := iszero(a)
        }
    }

    // Function to check if a uint256 value is zero using assembly and return bytes32
    function checkZeroBytes32(uint256 a) external pure returns (bytes32 c) {
        assembly {
            // Use the assembly iszero function to check if a is 0 and return a bytes32 result
            c := iszero(a)
        }
    }

    // Function that demonstrates a condition where the result is updated based on a truthy value
    function isTruthy() external pure returns (uint256 result) {
        result = 2; // Initialize result to 2

        assembly {
            // If the condition (2) is true, set result to 5
            if 2 {
                result := 5
            }
        }

        return result; // Returns 5 since the condition was true
    }

    // Function that demonstrates a condition where the result is updated based on a falsy value
    function isFalsy() external pure returns (uint256 result) {
        result = 1; // Initialize result to 1

        assembly {
            // If the condition (0) is false, do not update the result
            if 0 {
                result := 2
            }
        }

        return result; // Returns 1 since the condition was false
    }

    // Function to demonstrate the use of negation in assembly
    function negation() external pure returns (uint256 result) {
        result = 1; // Initialize result to 1

        assembly {
            // Check if 0 is zero (which it is) and update result to 2
            if iszero(0) {
                result := 2
            }
        }

        return result; // Returns 2 since the condition is true
    }

    // Function to return the maximum of two values using assembly
    function max(uint256 x, uint256 y) external pure returns (uint256 maximum) {
        assembly {
            // If x is less than y, set maximum to y
            if lt(x, y) {
                maximum := y
            }
            // If x is not less than y, set maximum to x
            if iszero(lt(x, y)) {
                maximum := x
            }
        }
    }

    // Function that demonstrates the use of switch-case in assembly for comparing two values
    function checkSwitch(uint256 x, uint256 y)
        external
        pure
        returns (uint256 lesser)
    {
        uint256 sum;
        assembly {
            // Calculate sum of x and y
            sum := add(x, y)

            // Switch-case to check which number is lesser and set accordingly
            switch lt(x, y)
            case true {
                // If x is less than y, set lesser to x
                lesser := x
            }
            case false {
                // If x is not less than y, set lesser to y
                lesser := y
            }
        }
    }

    // Function that mimics the behavior of a while loop using a for loop in assembly
    function CheckWhile() external pure returns (uint256 result) {
        assembly {
            // Simulate a while loop using a for loop with i starting at 0
            // Condition: while i < 10
            // Post-iteration: i = i + 1
            for {
                let i := 0
            } lt(i, 10) {
                i := add(i, 1)
            } {
                // Add the value of i to result in each iteration
                result := add(result, i)
            }
        }
    }
}
