"use strict"

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

module.exports = new AskService()
