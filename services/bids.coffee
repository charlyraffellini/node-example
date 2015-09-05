"use strict"

include = require 'include'
BaseService = require './baseService'

class BidService extends BaseService
  constructor: ->
    super("#{process.env.PWD}/mocks/bid.json")

  create: (bid) ->
    super bid
    include('config/socket.io').getIo().emit('new-bid', bid)

module.exports = new BidService()
