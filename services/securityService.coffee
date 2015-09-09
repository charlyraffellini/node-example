"use strict"

include = require 'include'
BaseService = require './baseService'
_ = require 'lodash'
Promise = require 'bluebird'

class SecurityService extends BaseService
  constructor:  (path)->
    super(path)

  create: (elem, message) ->
    super elem
    include('config/socket.io').getIo()?.emit("new-#{message}", elem)

  removeUserWillAsync: (userId, message) ->
    super(userId)
    .then (data) ->
      include('config/socket.io').getIo()?.emit("removed-#{message}", data)
      data

  getByPriceAsync: (price) =>
    elems = @getByPrice price
    Promise.resolve elems

  getNextByPrice: (price) =>
    elem = _.find @getAll(), (e) => @_areEqualPrices(price, e.price)
    return undefined if _.isEmpty(elem)
    elem

  removeManyAsync: (elems) ->
    removes = _.map elems, (e) => @removeAsync e
    Promise.all(removes)
    .then ->
      elems

  getByPrice: (price) ->
    _.filter @getAll(), (e) => @_areEqualPrices(price, e.price)

  update: (elem, message) ->
    include('config/socket.io').getIo()?.emit("updated-#{message}", data)

  _areEqualPrices: (price, otherPrice) ->
    Math.abs(price - otherPrice) <= 0.01

module.exports = SecurityService
