"use strict"

include = require 'include'
userService = include 'services/users'
bidService = include 'services/bids'
askService = include 'services/asks'
PropostaBase = require "./propostaBase"

class PropostaAMercato extends PropostaBase
  performOffertaDiVendita: (userId, offerta, res) ->
    user = userService.getById(userId)
    return res.send 400, "Non c'e abaztanzza quantita di shares" if @_verificaDisponibilitaPerVendere(user, offerta)
    sharesCheRestano = @vendereLettere(user, offerta.price, offerta.shares)
    @createOrReplaceUserProposta(userId, {price: offerta.price, shares: sharesCheRestano}, askService) if(sharesCheRestano > 0)
    res.send 201

  performOffertaDiAquisito: (userId, offerta, res) ->
    user = userService.getById(userId)
    return res.send 400, "Non c'e abaztanzza quantita di cash" if @_verificaDisponibilitaPerAcquistare(user, offerta)
    sharesCheRestano = @aquisitareLettere(user, offerta.price, offerta.shares)
    @createOrReplaceUserProposta(userId, {price: offerta.price, shares: sharesCheRestano}, bidService) if(sharesCheRestano > 0)
    res.send 201

module.exports = new PropostaAMercato()
