// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {

    uint256 totalWaves;
    uint256 private seed;
    // mapping of all addres who waved me and the number of wave 
    mapping(address => uint) public senderCount;
    // array used as an index for senderCount mapping
    address[] public addressIndices;

    // storing the address with the last time the user waved at us.
    mapping(address => uint256) public lastWavedAt;

    event NewWave(address indexed from, uint256 timestamp, string message);
    /*
     * struct named Wave.
     */
    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    /*
     * Declaration of a variable waves that lets us store an array of structs.
     */
    Wave[] waves;


    constructor() payable {
        console.log("Yo yo, I am your first smart contract !");
        //Set the initial seed
        seed = (block.timestamp + block.difficulty) % 100;

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


    function wave(string memory _message) public {

        // Make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m"
        );
        // Update the current timestamp we have for the user
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;

        bool isExist;
        senderCount[msg.sender] += 1;
        for (uint256 i = 0; i < addressIndices.length; i++) {
            if(msg.sender == addressIndices[i]){
                isExist =true;
                break;
            }
        }
        if(isExist != true){
            addressIndices.push(msg.sender);
        }

        console.log("%s has waved!", msg.sender);
        waves.push(Wave(msg.sender, _message, block.timestamp));
        
        // Generate a new seed for the next user that sends a wave
        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);


        //Give a 20% chance that the user wins the prize.
        if (seed <= 30) {
            console.log("%s won!", msg.sender);

            // functionality to send money to waver
            uint256 prizeAmount = 0.0001 ether;
            require(
            prizeAmount <= address(this).balance,
            "Trying to withdraw more money than the contract has."
            );

            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }
        emit NewWave(msg.sender, block.timestamp, _message);
    }

    /*
     * Return the struct array, waves, to us.
     */
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256){
        console.log("We have %d total waves !", totalWaves);
        return totalWaves;
    }
}