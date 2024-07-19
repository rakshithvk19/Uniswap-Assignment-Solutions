// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";

contract ExactSwap {
    /**
     *  PERFORM AN SIMPLE SWAP WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1 WETH.
     *  The challenge is to swap an exact amount of WETH for 1337 USDC token using the `swap` function
     *  from USDC/WETH pool.
     *
     */
    function performExactSwap(address pool, address weth, address usdc) public {
        /**
         *     swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data);
         *
         *     amount0Out: the amount of USDC to receive from swap.
         *     amount1Out: the amount of WETH to receive from swap.
         *     to: recipient address to receive the USDC tokens.
         *     data: leave it empty.
         */

        // your code start here

        IUniswapV2Pair pair = IUniswapV2Pair(pool);
        (uint256 usdcReserve, uint256 wethReserve,) = pair.getReserves();

        uint256 wethAmountIn = getWethAmountIn(1337 * 1e6, usdcReserve, wethReserve);

        //Transfering the wEth tokens that we own to the pool contract based on calculateAmount1In() calculations.
        IUniswapV2Pair(weth).transfer(address(pair), wethAmountIn);

        pair.swap(1337 * 1e6, 0, address(this), "");
    }

    function getWethAmountIn(uint256 usdcAmountOut, uint256 reserveOut, uint256 reserveIn)
        internal
        pure
        returns (uint256 amountIn)
    {
        uint256 numerator = reserveIn * usdcAmountOut * 1000;
        uint256 denominator = ((reserveOut - usdcAmountOut) * 997);

        amountIn = ((numerator / denominator) + 1);
    }
}
