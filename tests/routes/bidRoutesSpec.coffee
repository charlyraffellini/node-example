include = require 'include'
app = include('app').getApp
request = require 'supertest'
express = require('express')

bid = null

describe 'Posting', ->
  beforeEach ->
    bid =
      userId: 'an Id'
      qty: 1
      price: 1

  it 'to /api/bids', (done) ->
    request(app).post('/api/bids')
    .send bid
    .expect(201)
    .end (err, res) ->
      res.body.should.have.property('id').which.is.a.String()
      if err
        return done(err)
      done()
