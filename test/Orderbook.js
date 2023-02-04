const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("OrderBook contract", () => {
  let orderBook;

  beforeEach(async () => {
    orderBook = await ethers.getContractAt("OrderBook", await ethers.provider.getSignerAddress());
  });

  it("should insert an order correctly", async () => {
    await orderBook.insertOrder(true, 100, 10);
    const [price, amount] = await orderBook.getBestPrice(true);
    expect(price).to.equal(100);
    expect(amount).to.equal(10);
  });

  it("should remove an order correctly", async () => {
    await orderBook.insertOrder(true, 100, 10);
    await orderBook.removeOrder(true, 100, 5);
    const [price, amount] = await orderBook.getBestPrice(true);
    expect(price).to.equal(100);
    expect(amount).to.equal(5);
  });

  it("should remove a price point correctly", async () => {
    await orderBook.insertOrder(true, 100, 10);
    await orderBook.removeOrder(true, 100, 10);
    const [price, amount] = await orderBook.getBestPrice(true);
    expect(price).to.equal(0);
    expect(amount).to.equal(0);
  });

  it("should get the correct order amount", async () => {
    await orderBook.insertOrder(true, 100, 10);
    const amount = await orderBook.getOrderAmount(true, 100);
    expect(amount).to.equal(10);
  });

  it("should get the correct price point", async () => {
    await orderBook.insertOrder(true, 100, 10);
    await orderBook.insertOrder(false, 100, 5);
    const [buyAmount, sellAmount] = await orderBook.getPricePoint(100);
    expect(buyAmount).to.equal(10);
    expect(sellAmount).to.equal(5);
  });
});
