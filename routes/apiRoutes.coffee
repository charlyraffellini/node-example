router = require('express').Router()
include = require 'include'

asks = include 'services/asks'
bids = include 'services/bids'
users = include 'services/users'
propostaConLimiteDiPrezzoController = include 'controllers/propostaConLimiteDiPrezzo'
propostaAMercato = include 'controllers/propostaAMercato'

router.get '/asks', (req, res) ->
  allAsks = asks.getAll()
  res.status(200).send allAsks

router.get '/bids', (req, res) ->
  allBids = bids.getAll()
  res.status(200).send allBids

router.post '/asks', (req, res) ->
  ask = req.body
  asks.create ask
  res.status(201).send ask

router.post '/bids', (req, res) ->
  bid = req.body
  bids.create bid
  res.status(201).send bid

router.get '/user/me', (req, res) ->
  user = users.get username: req.user.username
  res.status(200).send user

router.post '/conLimiteDiPrezzo/vendita', (req, res) ->
  propostaConLimiteDiPrezzoController.performOffertaDiVendita(req.user.id, req.body, res)

router.post '/conLimiteDiPrezzo/aquisito', (req, res) ->
  propostaConLimiteDiPrezzoController.performOffertaDiAquisito(req.user.id, req.body, res)

router.post '/propostaAMercato/vendita', (req, res) ->
  propostaAMercato.performOffertaDiVendita(req.user.id, req.body, res)
module.exports = router
