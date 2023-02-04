// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./PriceMatchingEngine.sol";
import "./SegmentedSegmentTree.sol";

contract OrderBook {
    PriceMatchingEngine public priceMatchingEngine;
    SegmentedSegmentTree public segmentedSegmentTree;

    constructor() public {
        priceMatchingEngine = new PriceMatchingEngine();
        segmentedSegmentTree = new SegmentedSegmentTree();
    }

    function insertOrder(bool isBuy, uint256 price, uint256 amount) public {
        segmentedSegmentTree.insertOrder(isBuy, price, amount);
        priceMatchingEngine.insertPricePoint(price, isBuy ? amount : 0, isBuy ? 0 : amount);
    }

    function removeOrder(bool isBuy, uint256 price, uint256 amount) public {
        segmentedSegmentTree.removeOrder(isBuy, price, amount);
        uint256 buyAmount, sellAmount;
        (buyAmount, sellAmount) = priceMatchingEngine.getPricePoint(price);
        if (isBuy) {
            buyAmount -= amount;
        } else {
            sellAmount -= amount;
        }
        if (buyAmount == 0 && sellAmount == 0) {
            priceMatchingEngine.removePricePoint(price);
        } else {
            priceMatchingEngine.updatePricePoint(price, buyAmount, sellAmount);
        }
    }

    function getOrderAmount(bool isBuy, uint256 price) public view returns (uint256) {
        return segmentedSegmentTree.getOrderAmount(isBuy, price);
    }

    function getBestPrice(bool isBuy) public view returns (uint256, uint256) {
        uint256 price, amount;
        (price, amount) = segmentedSegmentTree.getBestPrice(isBuy);
        return (price, amount);
    }

    function getPricePoint(uint256 price) public view returns (uint256, uint256) {
        return priceMatchingEngine.getPricePoint(price);
    }
}
