"use strict"

include = require 'include'
userService = include 'services/users'
bidService = include 'services/bids'
askService = include 'services/asks'
PropostaBase = require "./propostaBase"

class PropostaConLimiteDiPrezzo extends PropostaBase
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
      @createOrReplaceUserProposta(userId, offerta, elemService)
      .then (elem) =>
          res.send 201, elem
    .catch (e) =>
      console.log e
      res.send(400, {error: e.message || e})

module.exports = new PropostaConLimiteDiPrezzo()
