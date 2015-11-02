'use strict'

import _ from 'lodash';

export function createBid(bid, bids, asks, users){
  let buyer = users.find( u => u.id === bid.userid);
  asks.sort( (x, y) => x.price > y.price )
  .forEach(function(a){
    if(bid.qty <= 0 || a.price > bid.price) return;
    let seller = users.find( u => u.id === a.userid);
    buyAsk(a, bid, buyer, seller);
  });

  _.remove(asks, (a) => a.qty == 0);

  if(bid.qty > 0) bids.push(bid);

  let maximumCashThanTheBuyerPays = bid.price * bid.qty;
  reduceCash(buyer, maximumCashThanTheBuyerPays);
}






function buyAsk(ask, bid, buyer, seller){
  let qty = bid.qty > ask.qty ? ask.qty : bid.qty;

  let totalValue = ask.price * qty;

  addShares(buyer, qty);
  reduceCash(buyer, totalValue);

  reduceShares(seller, qty);
  addCash(seller, totalValue);

  ask.qty -= qty;
  bid.qty -= qty;
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
