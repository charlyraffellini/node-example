'use strict'

import _ from 'lodash';

export function createBid(bid, bids, asks, users){
  let buyer = findUser(bid.userid, users);
  asks.sort(isPriceHigher)
  .forEach(function(a){
    if(bid.qty <= 0 || isPriceHigher(a,bid)) return;
    let seller = findUser(a.userid, users);
    buyAsk(a, bid, buyer, seller);
  });

  removeWhenQuantityIsZero(asks);

  if(bid.qty > 0) bids.push(bid);

  let maximumCashThanTheBuyerPays = bid.price * bid.qty;
  reduceCash(buyer, maximumCashThanTheBuyerPays);
}

export function createAsk(ask, bids, asks, users){
  let seller = findUser(ask.userid, users);
  bids.sort(isPriceLower)
  .forEach(function(b){
    if(ask.qty <= 0 || isPriceLower(b,ask)) return;
    let buyer = findUser(b.userid, users);
    sellBid(b, ask, buyer, seller);
  });

  removeWhenQuantityIsZero(bids);
  if(ask.qty > 0) asks.push(ask);

  reduceShares(seller, ask.qty);
}



function sellBid(bid, ask, buyer, seller){
  let qty = ask.qty > bid.qty ? bid.qty : ask.qty;
  let totalValue = bid.price * qty;

  doTransaction(qty, totalValue, seller, buyer);

  reduceAskAndBidInAQuantity(ask,bid,qty);
}

function buyAsk(ask, bid, buyer, seller){
  let qty = bid.qty > ask.qty ? ask.qty : bid.qty;
  let totalValue = bid.price * qty;

  doTransaction(qty, totalValue, seller, buyer);

  reduceAskAndBidInAQuantity(ask,bid,qty)
}

function doTransaction(shares, cash, seller, buyer){
  addShares(buyer, shares);
  reduceCash(buyer, cash);

  reduceShares(seller, shares);
  addCash(seller, cash);
}



function addShares(buyer, qty){
  buyer.wallet.shares  += qty;
}

function reduceCash(buyer, cash){
  buyer.wallet.cash -= cash;
}

function reduceShares(seller, qty){
  seller.wallet.shares -= qty;
}

function addCash(seller, cash){
  seller.wallet.cash += cash;
}

function isPriceLower(x, y){
  return x.price < y.price
}

function isPriceHigher(x, y){
  return x.price > y.price
}

function findUser(userid, users){
  return users.find( u => u.id === userid);
}

function removeWhenQuantityIsZero(elems){
  _.remove(elems, (e) => e.qty == 0);
}

function reduceAskAndBidInAQuantity(ask, bid, qty){
  ask.qty -= qty;
  bid.qty -= qty;
}
