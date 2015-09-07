include = require 'include'
request = require 'supertest'
express = require 'express'
mockery = require 'mockery'

bid = null

describe 'Posting', ->
  beforeEach ->
    bid =
      userId: 'an Id'
      qty: 1
      price: 1
    include("tests/specHelper").clearRequiresAndLogin()

  it 'to /api/bids', (done) ->
    app = include('app').getApp
    request(app).post('/api/bids')
    .send bid
    .expect(201)
    .end (err, res) ->
      res.body.should.have.property('id').which.is.a.String()
      if err
        return done(err)
      done()
