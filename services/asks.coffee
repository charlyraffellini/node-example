"use strict"

_ = require 'lodash'
include = require 'include'
SecurityService = require './securityService'

class AskService extends SecurityService
  constructor: ->
    super("#{process.env.PWD}/mocks/ask.json")

  create: (bid) ->
    super bid, "ask"

  removeUserWillAsync: (userId) ->
    super userId, "ask"

  update: (ask) ->
    super(ask, "ask")

  remove: (ask) ->
    super ask, "ask"

  maximumPrice: ->
    _.chain(@collection)
    .pluck('price')
    .max()
    .value()

module.exports = new AskService()
