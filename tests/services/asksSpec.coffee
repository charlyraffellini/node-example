include = require 'include'
should = require 'should'

asks = include 'services/asks'

ask = null

describe 'Ask service', ->
  describe '#create():', ->
    beforeEach ->
      ask =
        userId: 'an Id'
        qty: 1
        price: 1
      asks.create ask

    it 'can save a new ask', ->
      ask.should.have.property('id').which.is.a.String()

    it 'can get it by id', ->
      otherAsk = asks.getById ask.id
      otherAsk.should.be.equal ask
