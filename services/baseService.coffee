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

  remove: (elem) ->
    _.pull @collection, elem

  removeAsync: (elem) ->
    @remove elem
    Promise.resolve()

  removeUserWillAsync: (userId) ->
    removed = null
    @collection = _.remove @collection, (elem) ->
      res = elem.userid != userId
      removed = elem if !res
      res

    Promise.resolve(removed)

  createAsync: (elem) ->
    @create elem
    Promise.resolve elem
