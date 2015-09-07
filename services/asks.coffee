"use strict"

include = require 'include'
BaseService = require './baseService'

class AskService extends BaseService
  constructor: ->
    super("#{process.env.PWD}/mocks/ask.json")

  create: (ask) ->
    super ask
    include('config/socket.io').getIo()?.emit('new-ask', ask)

  removeUserWillAsync: (userId) ->
    super(userId)
    .then (data) ->
      include('config/socket.io').getIo()?.emit('removed-ask', data)
      data

module.exports = new AskService()
