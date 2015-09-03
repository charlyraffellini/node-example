router = require('express').Router()
include = require 'include'

asks = include 'services/asks'
bids = include 'services/bids'

router.post '/ask', (req, res) ->
  ask = req.body
  asks.create ask
  res.status(201).send ask

router.post '/bid', (req, res) ->
  bid = req.body
  bids.create bid
  res.status(201).send bid

module.exports = router
