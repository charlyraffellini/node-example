router = require('express').Router()
include = require 'include'

asks = include 'services/asks'
bids = include 'services/bids'

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


module.exports = router
