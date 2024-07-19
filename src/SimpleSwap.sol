// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";
import {console2} from "forge-std/console2.sol";

contract SimpleSwap {
    /**
     *  PERFORM A SIMPLE SWAP WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1 WETH.
     *  The challenge is to swap any amount of WETH for USDC token using the `swap` function
     *  from USDC/WETH pool.
     *
     * Hint: Check out this youtube video at timestamp(1:32:05) explaining the swap() function in UniswapV2Router
     * https://youtu.be/peMDeWcTLZ8?t=5525
     *
     */
    function performSwap(address pool, address weth, address usdc) public {
        /**
         *     swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data);
         *
         *     amount0Out: the amount of USDC to receive from swap.
         *     amount1Out: the amount of WETH to receive from swap.
         *     to: recipient address to receive the USDC tokens.
         *     data: leave it empty.
         */

        // your code start here

        // Initialize the Uniswap V2 Pair interface with the provided pool address
        IUniswapV2Pair pair = IUniswapV2Pair(pool);

        // Querying number of wEth and usdc owned in this contract.
        uint256 wEthAmountOwned = IUniswapV2Pair(weth).balanceOf(address(this));

        //Lets get 1000 USDC out of the pool.(For now atleast!)
        uint256 amount0Out = 1_000 * 1e6;

        //Transfering all the wEth tokens that we own to the pool contract. (Just for this assignment!!)
        IUniswapV2Pair(weth).transfer(address(pair), wEthAmountOwned);

        // Perform the swap
        pair.swap(amount0Out, 0, address(this), "");
    }
}
