// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract PriceMatchingEngine {
    struct PricePoint {
        uint256 price;
        uint256 buyAmount;
        uint256 sellAmount;
    }

    PricePoint[] public pricePoints;

function insertPricePoint(uint256 price, uint256 buyAmount, uint256 sellAmount) public {
    pricePoints.push(PricePoint(price, buyAmount, sellAmount));
    uint256 index = pricePoints.length - 1;
    uint256 parentIndex = (index - 1) / 2;

    while (index > 0) {
        uint256 parentPrice = pricePoints[parentIndex].price;
        if (pricePoints[index].price >= parentPrice) {
            break;
        }
         PricePoint storage temp = pricePoints[index];
        pricePoints[index] = pricePoints[parentIndex];
        pricePoints[parentIndex] = temp;
        index = parentIndex;
        parentIndex = (index - 1) / 2;
    }
}


function updatePricePoint(uint256 price, uint256 buyAmount, uint256 sellAmount) public {
    uint256 index = 0;
    while (index < pricePoints.length && pricePoints[index].price != price) {
        index++;
    }
    pricePoints[index].buyAmount = buyAmount;
    pricePoints[index].sellAmount = sellAmount;

    uint256 leftChildIndex = 2 * index + 1;
    uint256 rightChildIndex = 2 * index + 2;

    while (leftChildIndex < pricePoints.length || rightChildIndex < pricePoints.length) {
        uint256 minChildIndex;
        if (leftChildIndex < pricePoints.length && rightChildIndex < pricePoints.length) {
            minChildIndex = pricePoints[leftChildIndex].price < pricePoints[rightChildIndex].price ? leftChildIndex : rightChildIndex;
        } else if (leftChildIndex < pricePoints.length) {
            minChildIndex = leftChildIndex;
        } else {
            minChildIndex = rightChildIndex;
        }
        if (pricePoints[index].price <= pricePoints[minChildIndex].price) {
            break;
        }
        PricePoint storage temp = pricePoints[index];
        pricePoints[index] = pricePoints[minChildIndex];
        pricePoints[minChildIndex] = temp;
        index = minChildIndex;
        leftChildIndex = 2 * index + 1;
        rightChildIndex = 2 * index + 2;
    }
}


function removePricePoint(uint256 price) public {
        uint256 index = 0;
        while (index < pricePoints.length && pricePoints[index].price != price) {
            index++;
        }
        PricePoint storage temp = pricePoints[pricePoints.length - 1];
        pricePoints[index].price = temp.price;
        pricePoints[index].buyAmount = temp.buyAmount;
        pricePoints[index].sellAmount = temp.sellAmount;
        pricePoints.pop();

        uint256 leftChildIndex = 2 * index + 1;
        uint256 rightChildIndex = 2 * index + 2;

        while ((leftChildIndex < pricePoints.length && pricePoints[index].price > pricePoints[leftChildIndex].price) ||
               (rightChildIndex < pricePoints.length && pricePoints[index].price > pricePoints[rightChildIndex].price)) {
            uint256 minChildIndex;
            if (rightChildIndex >= pricePoints.length || pricePoints[leftChildIndex].price < pricePoints[rightChildIndex].price) {
                minChildIndex = leftChildIndex;
            } else {
                minChildIndex = rightChildIndex;
            }
            temp = pricePoints[minChildIndex];
            pricePoints[minChildIndex].price = pricePoints[index].price;
            pricePoints[minChildIndex].buyAmount = pricePoints[index].buyAmount;
            pricePoints[minChildIndex].sellAmount = pricePoints[index].sellAmount;
            pricePoints[index].price = temp.price;
            pricePoints[index].buyAmount = temp.buyAmount;
            pricePoints[index].sellAmount = temp.sellAmount;
            index = minChildIndex;
            leftChildIndex = 2 * index + 1;
            rightChildIndex = 2 * index + 2;
        }
    }


    function getPricePoint(uint256 price) public view returns (uint256, uint256) {
    uint256 index = 0;
    while (index < pricePoints.length && pricePoints[index].price != price) {
        index++;
    }
    return (pricePoints[index].buyAmount, pricePoints[index].sellAmount);
}

}
