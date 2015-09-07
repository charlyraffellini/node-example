include = require 'include'
should = require 'should'
mockery = require 'mockery'

asks = include 'services/asks'

ask = null

describe 'Ask service', ->
  describe '#create():', ->
    beforeEach ->
      mockery.enable
        useCleanCache: true
        warnOnUnregistered: false
      mockery.resetCache()
      ask =
        userId: 'an Id'
        qty: 1
        price: 1
      asks.create ask

  afterEach ->
    mockery.disable()

    it 'can save a new ask', ->
      ask.should.have.property('id').which.is.a.String()

    it 'can get it by id', ->
      otherAsk = asks.getById ask.id
      otherAsk.should.be.equal ask
