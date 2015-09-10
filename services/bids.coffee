"use strict"

include = require 'include'
SecurityService = require './securityService'


class BidService extends SecurityService
  constructor: ->
    super("#{process.env.PWD}/mocks/bid.json")

  create: (bid) ->
    super bid, "bid"

  removeUserWillAsync: (userId) ->
    super userId, "bid"

  remove: (bid) ->
    super bid, "bid"

  update: (bid) ->
    super(bid, "bid")
    
module.exports = new BidService()
