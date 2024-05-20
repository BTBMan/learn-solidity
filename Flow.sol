// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Flow {
    function ifTest(uint x) public  pure returns(bool) {
        if (x == 1) {
            return(true);
        }else{
            return(false);
        }
    }

    function forTest() public pure returns(uint256){
        uint sum = 0;
        for (uint i; i < 10; i++) {
            sum += i;
        }

        return(sum);
    }

    function whileTest() public pure returns(uint256){
        uint sum = 0;
        uint i = 0;

        while (i < 10) {
            sum += i;
            i++;
        }

        return(sum);
    }

    function doWhileTest() public pure returns(uint256){
        uint sum = 0;
        uint i = 0;

        do {
            sum += i;
            i++;
        } while (i<10);

        return sum;
    }

    function ternaryTest(bool x) public pure returns(uint){
        return x ? 1 : 2;
    }
}