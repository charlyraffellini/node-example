include = require 'include'
app = include('/app').getApp
request = require 'supertest'
express = require('express')

ask = null

describe 'Posting', ->
  beforeEach ->
    ask =
      userId: 'an Id'
      qty: 1
      price: 1

  it 'to /api/asks', (done) ->
    request(app).post('/api/asks')
    .send ask
    .expect(201)
    .end (err, res) ->
      console.log res.body
      res.body.should.have.property('id').which.is.a.String()
      if err
        return done(err)
      done()
