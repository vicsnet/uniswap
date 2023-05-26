// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Exchange is ERC20 {
    address public cryptoDevTokenAddress;

    constructor(address _CryptoDevtoken) ERC20("CryptoDev LP Token", "CDLP") {
        require(
            _CryptoDevtoken != address(0),
            "Token Address  Passed is a null address"
        );
        cryptoDevTokenAddress = _CryptoDevtoken;
    }

    function getReserve() public view returns (uint) {
        return ERC20(cryptoDevTokenAddress).balanceOf(address(this));
    }

  

    function addLiquidity(uint256 tokenAmount) public payable returns (uint) {
        uint liquidity;
        uint ethBalance = addrress(this).balance;
        uint cryptoDevTokenReserve = getReserve();
        ERC20 cryptoDevToken = ERC20(cryptoDevTokenAddress);
        // assuming a hypothetical function
        //that returns the balance of the
        //token in the contract
        if (cryptoDevTokenReserve == 0) {
            cryptoDevToken.transferFrom(msg.sender, address(this), tokenAmount);
            liquidity = ethBalance;
            _mint(msg.sender, liquidity);
        } else {
            uint ethReserve = ethBalance - msg.value;

            uint cryptoDevTokenAmount = (msg.value * cryptoDevTokenReserve) /
                (ethReserve);

            require(
                tokenAmount >= cryptoDevTokenAmount,
                "Amount of tokens sent is less than the minimum tokens required"
            );

            cryptoDevToken.transferFrom(
                msg.sender,
                address(this),
                cryptoDevTokenAmount
            );

            liquidity = (totalSupply() * msg.value) / ethReserve;
            _mint(msg.sender, liquidity);
        }
        return liquidity;
    }

    /**
     * @dev Returns the amount Eth/Crypto Dev tokens that would be return to the user
     * in the swap
     */

    function removeLiquidity(uint _amount) public returns (uint, uint) {
        require(_amount > 0, "_amount should be greater than zero");
        uint ethReserve = address(this).balance;
        uint _totalSupply = totalSupply();

        uint ethAmount = (ethReserve * _amount) / _totalSupply;

        uint cryptoDevTokenAmount = (getReserve() * _amount) / _totalSupply;

        _burn(msg.sender, _amount);

        payable(msg.sender).transfer(ethAmount);

        ERC20(cryptoDevTokenAddress).transfer(msg.sender, cryptoDevTokenAmount);
        return (ethAmount, cryptoDevTokenAmount);
    }

    /**
     * @dev Returns the amount Eth/Crypto Dev tokens that would be returned to the user
     * in the swap
     */
      function getAmountOfTokens(
        uint256 inputAmount,
        uint256 inputReserve,
        uint256 outputReserve
    ) public pure returns (uint256) {
        require(inputReerve >0 && outputReserve >0 , "Invalid reserves");
        uint256 inputAmountWithFee = inputAmount * 99;
        uint256 numerator = inputAmountWithFee * outputReserve;
        uint256 denominator = (inputReserve * 100) + inputAmountWithFee;
       
        return numerator/ denominator;
    }

    /**
* @dev Swaps Eth for CryptoDev Tokens
*/

function ethToCryptoDevToken(uint _minTokens) public payable{
    uint256 tokenReserve = getReserve();
    // call the `getAmountOfTokens` to get the amount of Crypto Dev tokens
    // that would be returned to the user after the swap
    // Notice that the `inputReserve` we are sending is equal to
    // `address(this).balance - msg.value` instead of just `address(this).balance`
    // because `address(this).balance` already contains the `msg.value` user has sent in the given call
    // so we need to subtract it to get the actual input reserve

    uint256 tokensBought =getAmountOfTokens(msg.value, address(this).balance- msg.value, tokenReserve);

    require(tokensBought >= _minTokens, "Insufficient output amount");
    // Transfer the `Crypto Dev` tokens to the user

     ERC20(cryptoDevTokenAddress).transfer(msg.sender, tokensBought);
}
/**
* @dev Swaps CryptoDev Tokens for Eth
*/

function cryptoDevTokenToEth(uint _tokensSold, uint _minEth) public{
    uint256 tokenReserve = getReserve();
     // call the `getAmountOfTokens` to get the amount of Eth
    // that would be returned to the user after the swap

    uint256 ethBought = getAmountOfTokens(_tokensSold, tokenReserve, address(this).balance);
    require (ethBought >= _minEth,"insufficient output amount" );
     ERC20(cryptoDevTokenAddress).transferFrom(
        msg.sender,
        address(this),
        _tokensSold
    );
    // send the `ethBought` to the user from the contract
    payable(msg.sender).transfer(ethBought);

}

}
