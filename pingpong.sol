// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

contract PingPong{
    string public message;
    uint supply;

    function ping(string memory _message, uint _supply) public{
        message = _message;
        supply = _supply;
    }

    function pong() public view returns (string memory, uint){
        return (message, supply);
    }
}
