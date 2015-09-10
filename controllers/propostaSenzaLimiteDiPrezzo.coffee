"use strict"

include = require 'include'
userService = include 'services/users'
bidService = include 'services/bids'
askService = include 'services/asks'
PropostaBase = require "./propostaBase"

class PropostaSenzaLimiteDiPrezzo extends PropostaBase
  performOffertaDiVendita: (userId, offerta, res) ->
    user = userService.getById(userId)
    return res.send 400, "Non c'e abaztanzza quantita di shares" if @_verificaDisponibilitaPerVendere(user, offerta)
    prezzo = offerta.price
    lettereCheRestano = offerta.shares
    while(lettereCheRestano > 0 && prezzo > 0)
       lettereCheRestano = @vendereLettere(user, prezzo, lettereCheRestano)
       prezzo -= 0.01
    res.send 201

  performOffertaDiAquisito: (userId, offerta, res) ->
    user = userService.getById(userId)
    return res.send 400, "Non c'e abaztanzza quantita di cash" if @_verificaDisponibilitaPerAcquistare(user, offerta)
    prezzo = offerta.price
    lettereCheRestano = offerta.shares
    maximumPrice = askService.maximumPrice()
    console.log maximumPrice
    while(lettereCheRestano > 0 && prezzo < maximumPrice)
       lettereCheRestano = @aquisitareLettere(user, prezzo, lettereCheRestano)
       prezzo += 0.01
    res.send 201

module.exports = new PropostaSenzaLimiteDiPrezzo()
