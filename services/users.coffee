"use strict"

include = require 'include'
BaseService = require './baseService'

class UserService extends BaseService
  constructor: ->
    super("#{process.env.PWD}/mocks/users.json")

  updateWallet: (userId, wallet) ->
    user = @get id: userId
    user.wallet = wallet

module.exports = new UserService()
