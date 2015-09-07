"use strict"

Promise = require 'bluebird'
fs = require 'fs'
uuid = require 'node-uuid'
_ = require 'lodash'
json = require 'comment-json'

module.exports = class BaseService
  constructor: (path) ->
    if path?
      text = fs.readFileSync(path,'utf8')
      @collection = json.parse text
    else
      @collection = []

  create: (elem) ->
    elem.id = uuid.v4()
    @collection.push elem

  get: (example) ->
    _.find @collection, example

  getById: (id) ->
    _.find @collection, id: id

  getAll: ->
    @collection

  getByIdAsync: (id) ->
    user = @getById id
    Promise.resolve user

  removeUserWillAsync: (userId) ->
    @collection = _.remove @collection, (elem) -> elem.userid == userId
    Promise.resolve()

  createAsync: (elem) ->
    @create elem
    Promise.resolve elem
