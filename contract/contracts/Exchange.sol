// SPDX-License-Identifier: MIT

pragma solidity ^0.8.5;

contract Exchange{
    function calculateOutputAmount(uint inputAmount, uint inputReserve, uint outputReserve) private pure returns (uint){
        uint outputAmount = (outputReserve * inputAmount)/(inputReserve + inputAmount);
        return outputAmount;
    }

    function addLiquidity(uint256 tokenAmount) public payable{
        // assuming a hypothetical function
        //that returns the balance of the
        //token in the contract
        if(getReserve()==0){

        IERC20 token = IERC20(tokenAddress);
        token.transferFrom(msg.sender, address(this), tokenAmount);
        uint liquidity = address(this).balance;
        _mint(msg.sender, liquidity);
        }
        else{
            uint ethReserve = address(this).balance - msg.value;
            uint tokenReserve = getReserve();
            uint proportionalTokenAmount = (msg.value * tokenReserve) /ethReserve;
            require(tokenAmount >= proportionalTokenAmount, "incorrect ratio of tokens provided");
            IERC20 token = IERC20(tokenAddress);
            token.trasferFrom(msg.sender, address(this), proportionalTokenAmount);
            uint liquidity = (totalSupply() * msg.value)/ethReserve;
            _mint(msg.sender, liquidity);
        }

    }
}