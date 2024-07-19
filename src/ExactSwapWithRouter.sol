// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IERC20.sol";

contract ExactSwapWithRouter {
    /**
     *  PERFORM AN EXACT SWAP WITH ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1 WETH.
     *  The challenge is to swap an exact amount of WETH for 1337 USDC token using UniswapV2 router.
     *
     */
    address public immutable router;

    constructor(address _router) {
        router = _router;
    }

    function performExactSwapWithRouter(address weth, address usdc, uint256 deadline) public {
        // your code start here

        // Step 1: Define the exact amount of USDC we want to receive
        uint256 amountOut = 1337 * 10 ** 6; // 1337 USDC

        // Step 2: Calculate the maximum amount of WETH we're willing to spend
        uint256 amountInMax = 1 ether; // 1 WETH (assuming 18 decimals)

        // Step 3: Create the path array
        address[] memory path = new address[](2);
        path[0] = weth;
        path[1] = usdc;

        // Step 4: Approve the router to spend WETH
        IERC20(weth).approve(router, amountInMax);

        // Step 5: Perform the swap
        IUniswapV2Router(router).swapTokensForExactTokens(
            amountOut,
            amountInMax,
            path,
            address(this), // Recipient is this contract
            deadline
        );
    }
}

interface IUniswapV2Router {
    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}
