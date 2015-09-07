include = require 'include'
request = require 'supertest'
express = require 'express'
# mockery = require 'mockery'

ask = null

describe 'Posting', ->
  beforeEach ->
    ask =
      userId: 'an Id'
      qty: 1
      price: 1
    include("tests/specHelper").clearRequiresAndLogin()

  it 'to /api/asks', (done) ->
    app = include('app').getApp
    request(app)
    .post('/api/asks')
    .send ask
    .expect(201)
    .end (err, res) ->
      res.body.should.have.property('id').which.is.a.String()
      if err
        return done(err)
      done()
