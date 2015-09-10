"use strict"

include = require 'include'
userService = include 'services/users'
bidService = include 'services/bids'
askService = include 'services/asks'

class PropostaBase
  _verificaDisponibilitaPerVendere: (user, offerta) ->
    throw new Error("Non c'e abaztanzza quantita di shares") if(user.wallet.shares < offerta.shares)

  _verificaDisponibilitaPerAcquistare: (user, offerta) ->
    throw new Error("Non c'e abaztanzza quantita di cash") if(user.wallet.cash < (offerta.shares * offerta.price))

  createOrReplaceUserProposta: (userId, offerta, elemService) ->
    elemService.removeUserWillAsync(userId)
    .then =>
      elem =
        userid: userId
        qty: offerta.shares
        price: offerta.price
      elemService.createAsync(elem)

  aquisitareLettere: (user, price, quantitaDiSharesCheRestano) ->
    console.log "user: #{JSON.stringify user}"
    console.log "price: #{price}"
    console.log "quantitaDiSharesCheRestano: #{quantitaDiSharesCheRestano}"
    while((ask = askService.getNextByPrice(price)) && quantitaDiSharesCheRestano > 0)
      console.log "ask: #{JSON.stringify ask}"
      differenceDiShares = quantitaDiSharesCheRestano - ask.qty
      if(differenceDiShares >= 0)
        transferedCash = ask.qty * ask.price
        @_verificaTrasferenza(transferedCash, user.wallet.cash)
        user.wallet.shares += ask.qty
        user.wallet.cash -= transferedCash
        userThatSell = userService.getById ask.userid
        userThatSell.wallet.cash += transferedCash
        userThatSell.wallet.shares -= ask.qty
        quantitaDiSharesCheRestano -= ask.qty
        askService.remove ask
      else
        transferedCash = quantitaDiSharesCheRestano * ask.price
        @_verificaTrasferenza(transferedCash, user.wallet.cash)
        user.wallet.shares += quantitaDiSharesCheRestano
        user.wallet.cash -= transferedCash
        userThatSell = userService.getById ask.userid
        userThatSell.wallet.cash += transferedCash
        userThatSell.wallet.shares -= quantitaDiSharesCheRestano
        ask.qty -= quantitaDiSharesCheRestano
        askService.update ask
        quantitaDiSharesCheRestano = 0
    quantitaDiSharesCheRestano

  _verificaTrasferenza: (transferedCash, soldi) ->
    throw "Non c'e abaztanzza quantita di cash" if (transferedCash > soldi)

  vendereLettere: (user, price, quantitaDiSharesCheRestano) ->
    console.log "user: #{JSON.stringify user}"
    console.log "price: #{price}"
    console.log "quantitaDiSharesCheRestano: #{quantitaDiSharesCheRestano}"
    while((bid = bidService.getNextByPrice(price)) && quantitaDiSharesCheRestano > 0)
      console.log "bid: #{JSON.stringify bid}"
      differenceDiShares = quantitaDiSharesCheRestano - bid.qty
      if(differenceDiShares >= 0)
        transferedCash = bid.qty * bid.price
        user.wallet.shares -= bid.qty
        user.wallet.cash += transferedCash
        userThatBuy = userService.getById bid.userid
        userThatBuy.wallet.cash -= transferedCash
        userThatBuy.wallet.shares += bid.qty
        quantitaDiSharesCheRestano -= bid.qty
        bidService.remove bid
      else
        transferedCash = quantitaDiSharesCheRestano * bid.price
        user.wallet.shares -= quantitaDiSharesCheRestano
        user.wallet.cash += transferedCash
        userThatBuy = userService.getById bid.userid
        userThatBuy.wallet.cash -= transferedCash
        userThatBuy.wallet.shares += quantitaDiSharesCheRestano
        bid.qty -= quantitaDiSharesCheRestano
        bidService.update bid
        quantitaDiSharesCheRestano = 0
    quantitaDiSharesCheRestano

module.exports = PropostaBase
