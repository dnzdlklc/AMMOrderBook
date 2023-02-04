// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract OrderBook {
    struct Order {
        uint256 price;
        uint256 amount;
    }

    struct Node {
        uint256 sum;
        uint256 minPrice;
        uint256 maxPrice;
    }

    uint256 public count;
    Order[] public orders;
    Node[] public tree;

    constructor() public {
        count = 0;
        tree.push(Node(0, 0, 0));
    }

    function insertOrder(uint256 price, uint256 amount) public {
        require(count < 2048, "Order book limit reached");
        orders.push(Order(price, amount));
        count++;
        updateTree(1, 0, count - 1, price, amount);
    }

    function updateTree(uint256 nodeIndex, uint256 left, uint256 right, uint256 price, uint256 amount) private {
        if (left == right) {
            tree[nodeIndex] = Node(amount, price, price);
            return;
        }

        uint256 mid = (left + right) / 2;
        if (count - 1 <= mid) {
            updateTree(nodeIndex * 2, left, mid, price, amount);
        } else {
            updateTree(nodeIndex * 2 + 1, mid + 1, right, price, amount);
        }

        tree[nodeIndex].sum = tree[nodeIndex * 2].sum + tree[nodeIndex * 2 + 1].sum;
        tree[nodeIndex].minPrice = min(tree[nodeIndex * 2].minPrice, tree[nodeIndex * 2 + 1].minPrice);
        tree[nodeIndex].maxPrice = max(tree[nodeIndex * 2].maxPrice, tree[nodeIndex * 2 + 1].maxPrice);
    }

    function removeOrder(uint256 orderId) public {
        uint256 price = orders[orderId].price;
        uint256 amount = orders[orderId].amount;
        updateTree(1, 0, count - 1, price, -amount);
        orders[orderId] = orders[count - 1];
        count--;
        orders.pop();
    }

    function getTotalAmount() public view returns (uint256) {
        return tree[1].sum;
    }

    function getMinPrice() public view returns (uint256) {
        return tree[1].minPrice;
    }

    function getMaxPrice() public view returns (uint256) {
        return tree[1].maxPrice;
    }
}
