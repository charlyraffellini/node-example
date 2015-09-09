"use strict"

include = require 'include'
userService = include 'services/users'
bidService = include 'services/bids'
askService = include 'services/asks'
propostaConLimiteDiPrezzo = require './propostaConLimiteDiPrezzo'

class PropostaAMercato
  performOffertaDiVendita: (userId, offerta, res) ->
    user = userService.getById(userId)
    return res.send 400, "Non c'e abaztanzza quantita di shares" if @_verificaDisponibilitaDiVendita(user, offerta)
    sharesCheRestano = @vendereLettere(user, offerta.price, offerta.shares)
    propostaConLimiteDiPrezzo.createOrreplaceUserProposta(userId, {price: offerta.price shares: sharesCheRestano}, askService) if sharesCheRestano > 0
    res.send 201

  vendereLettere: (user, price, quantitaDiSharesCheRestano) ->
    while((bid = bidService.getNextByPrice(price)) && quantitaDiSharesCheRestano > 0)
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

module.exports = new PropostaAMercato()
