"use strict"

fs = require 'fs'
uuid = require 'node-uuid'
_ = require 'lodash'

module.exports = class BaseService
  constructor: (path) ->
    if path?
      text = fs.readFileSync(path,'utf8')
      @collection = JSON.parse text
    else
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
