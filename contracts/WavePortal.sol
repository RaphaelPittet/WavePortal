// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {

    uint256 totalWaves;
    mapping(address => uint) public senderCount;
    address[] public addressIndices;

    constructor() {
        console.log("Yo yo, I am your first smart contract !");
    }

    // get number of wave done by userAdress
    function currentCount(address userAddress) public view returns (uint) {
     return senderCount[userAddress];
    }

    // get address who done the most wave
    function getTopWaverAddress() public view returns (address){
        uint256 biggerValue = 0;
        address bestAddress;
        for (uint256 i = 0; i < addressIndices.length; i++) {
            uint256 value = senderCount[addressIndices[i]];
            if(value > biggerValue){
                biggerValue = value;
                bestAddress = addressIndices[i];
            }
        }
        console.log("thanks to %s", bestAddress);
        return bestAddress;
    }

    // get number of wave done by the most waved address
    function getTopWaverCount() public view returns (uint){
        address topWaverAddress = getTopWaverAddress();

        console.log(" count = %d",senderCount[topWaverAddress]);
        return senderCount[topWaverAddress];
    }

    function wave() public {
        totalWaves += 1;
        uint256 isExist;
        senderCount[msg.sender] += 1;
        for (uint256 i = 0; i < addressIndices.length; i++) {
            if(msg.sender == addressIndices[i]){
                isExist =1;
                break;
            }
        }
        if(isExist != 1){
            addressIndices.push(msg.sender);
        }

        console.log("%s has waved!", msg.sender);
    }

    function getTotalWaves() public view returns (uint256){
        console.log("We have %d total waves !", totalWaves);
        return totalWaves;
    }
}