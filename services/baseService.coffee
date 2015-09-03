"use strict"

uuid = require 'node-uuid'
_ = require 'lodash'

module.exports = class BaseService
  constructor: ->
     @collection = []

  create: (ask) ->
    ask.id = uuid.v4()
    @collection.push ask

  get: (example) ->
    _.find @collection, example

  getById: (id) ->
    _.find @collection, id: id

  getAll: ->
    @collection
