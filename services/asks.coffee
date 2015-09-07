"use strict"

include = require 'include'
BaseService = require './baseService'

class AskService extends BaseService
  constructor: ->
    super("#{process.env.PWD}/mocks/ask.json")

  create: (ask) ->
    super ask
    include('config/socket.io').getIo()?.emit('new-ask', ask)

module.exports = new AskService()
