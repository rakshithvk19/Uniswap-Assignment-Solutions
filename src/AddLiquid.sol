// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";
import {console2} from "forge-std/Test.sol";

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

        /**
         * Additional research question
         * 1. Why are we using state variables to capture the balances of each token held in the pool? Why can't we use ERC20's balanceOf() each time to fetch the balance of each token held in the pool?
         * 2. If one already knows the pool address, then can someone transfer tokens directly to the pools address?
         * 3. Does the code follow CEI pattern ?
         */
        /**
         * Represents the state variable that captures the value of tokens held by the pool which is contextualized to the state of the pool.
         * This is different from using ERC20's balanceOf() on the pool address.
         * The reason we are using a state variable reserve instead of using balanceOf() every time is to prevent price manipulation
         * A trader can directly send a huge amount of a single token to the pool manipulating its price and perform a profitable swap.
         */
        (uint112 reserve0, uint112 reserve1,) = pair.getReserves();
        require(reserve0 == usdcReserve && reserve1 == wethReserve, "Incorrect reserve values");

        uint256 balance0 = IERC20(usdc).balanceOf(address(this));
        uint256 balance1 = IERC20(weth).balanceOf(address(this));

        // Calculate the optimal amounts to add liquidity in the same ratio as the pool
        uint256 amount0Optimal = (balance1 * reserve0) / reserve1;
        uint256 amount1Optimal = (balance0 * reserve1) / reserve0;

        uint256 amount0;
        uint256 amount1;
        if (amount0Optimal <= balance0) {
            amount0 = amount0Optimal;
            amount1 = balance1;
        } else {
            amount0 = balance0;
            amount1 = amount1Optimal;
        }

        // Approve the pair contract to spend tokens
        IERC20(usdc).approve(pool, amount0);
        IERC20(weth).approve(pool, amount1);

        // Transfer tokens to the pair contract
        IERC20(usdc).transfer(pool, amount0);
        IERC20(weth).transfer(pool, amount1);

        // Mint the LP tokens to msg.sender
        pair.mint(msg.sender);

        // Optionally, you can calculate and return the liquidity minted
        // uint256 liquidity = pair.balanceOf(msg.sender) - liquidityBefore;

        // Emit an event if needed
        // emit LiquidityAdded(msg.sender, amount0, amount1, liquidity);
    }

    // Internal function
    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = x < y ? x : y;
    }
}
