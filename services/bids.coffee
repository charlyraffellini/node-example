"use strict"

include = require 'include'
BaseService = require './baseService'

class BidService extends BaseService
  constructor: ->
    super("#{process.env.PWD}/mocks/bid.json")

  create: (bid) ->
    super bid
    include('config/socket.io').getIo()?.emit('new-bid', bid)

  removeUserWillAsync: (userId) ->
    super(userId)
    .then (data) ->
      include('config/socket.io').getIo()?.emit('removed-bid', data)
      data

module.exports = new BidService()
