"use strict"

include = require 'include'
userService = include 'services/users'
bidService = include 'services/bids'
askService = include 'services/asks'

class PropostaConLimiteDiPrezzo
  performOffertaDiVendita: (userId, offerta, res) -> #bid
    @_perform(userId, offerta, res, @_verificaDisponibilitaPerVendere, bidService)

  performOffertaDiAquisito: (userId, offerta, res) -> #ask
    @_perform(userId, offerta, res, @_verificaDisponibilitaPerAcquistare, askService)

  _perform: (userId, offerta, res, verificaDisponibilita, elemService) ->
    userService.getByIdAsync(userId)
    .then (user) =>
      verificaDisponibilita user, offerta
      user
    .then (user) =>
      @createOrreplaceUserProposta(userId, offerta, elemService)
      .then (elem) =>
          res.send 201, elem
    .catch (e) =>
      console.log e
      res.send(400, {error: e.message || e})

  createOrreplaceUserProposta: (userId, offerta, elemService) ->
    elemService.removeUserWillAsync(userId)
    .then =>
      elem =
        userid: userId
        qty: offerta.shares
        price: offerta.price
      elemService.createAsync(elem)

  _verificaDisponibilitaPerVendere: (user, offerta) ->
    throw new Error("Non c'e abaztanzza quantita di shares") if(user.wallet.shares < offerta.shares)

  _verificaDisponibilitaPerAcquistare: (user, offerta) ->
    throw new Error("Non c'e abaztanzza quantita di cash") if(user.wallet.cash < (offerta.shares * offerta.price))

module.exports = new PropostaConLimiteDiPrezzo()
