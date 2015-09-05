"use strict"

include = require 'include'
BaseService = require './baseService'
io = include('config/socket.io').getIo()

class AskService extends BaseService
  constructor: ->
    super("#{process.env.PWD}/mocks/ask.json")

  create: (ask) ->
    super ask
    include('config/socket.io').getIo().emit('new-ask', ask)

module.exports = new AskService()
