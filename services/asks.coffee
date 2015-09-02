uuid = require 'node-uuid'
_ = require 'lodash'

asks = []

module.exports.create = (ask) ->
  ask.id = uuid.v4()
  asks.push ask

module.exports.get = (example) ->
  _.find asks, example

module.exports.getById = (id) ->
  _.find asks, id: id
