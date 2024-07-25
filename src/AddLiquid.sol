// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";

contract AddLiquid {
    /**
     *  ADD LIQUIDITY WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1000 USDC and 1 WETH.
     *  Mint a position (deposit liquidity) in the pool USDC/WETH to msg.sender.
     *  The challenge is to provide the same ratio as the pool then call the mint function in the pool contract.
     *
     */
    function addLiquidity(address usdc, address weth, address pool, uint256 usdcReserve, uint256 wethReserve) public {
        IUniswapV2Pair pair = IUniswapV2Pair(pool);

        // your code start here

        // see available functions here: https://github.com/Uniswap/v2-core/blob/master/contracts/interfaces/IUniswapV2Pair.sol

        (uint112 reserve0, uint112 reserve1,) = pair.getReserves();
        require(reserve0 == usdcReserve && reserve1 == wethReserve, "Incorrect reserve values");

        //Amount of tokens held by the current contract.
        uint256 balance0 = IERC20(usdc).balanceOf(address(this));
        uint256 balance1 = IERC20(weth).balanceOf(address(this));

        //Initializing local variable to calculate the optimal amount of tokens.
        uint256 amount0;
        uint256 amount1;

        // Calculate the optimal amounts to add liquidity in the same ratio as the pool
        uint256 amount0Optimal = (balance1 * reserve0) / reserve1;
        uint256 amount1Optimal = (balance0 * reserve1) / reserve0;

        //Calculations for number of token0 and token1 to add.
        if (amount0Optimal <= balance0) {
            amount0 = amount0Optimal;
            amount1 = balance1;
        } else {
            amount0 = balance0;
            amount1 = amount1Optimal;
        }

        // Approve the pair contract to spend tokens.
        IERC20(usdc).approve(pool, amount0);
        IERC20(weth).approve(pool, amount1);

        // Transfer tokens to the pool contract.
        IERC20(usdc).transfer(pool, amount0);
        IERC20(weth).transfer(pool, amount1);

        // Mint the LP tokens to msg.sender
        pair.mint(msg.sender);
    }

    // Internal function
    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = x < y ? x : y;
    }
}
