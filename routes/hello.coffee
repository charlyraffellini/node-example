router = require('express').Router()
include = require 'include'

asks = include 'services/asks'

router.get '/hello', (req, res) -> res.json message: 'hello world'

router.post '/ask', (req, res) ->
  ask = req.body
  asks.create ask
  res.send 201, ask

module.exports = router
