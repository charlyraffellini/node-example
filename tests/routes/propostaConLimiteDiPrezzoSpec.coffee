"use strict"
mockery = require 'mockery'
include = require 'include'
request = require 'supertest'
express = require 'express'
simple = require 'simple-mock'
simple.Promise = require 'bluebird'
passportStub = require 'passport-stub'
mock = require 'mock-require'

app = null
bid = null

describe 'Posting', ->
  beforeEach ->
    include("tests/specHelper").clearRequires()
    userServiceMock = getByIdAsync: simple.stub().resolveWith({wallet: {shares: 1000, cash: 2000}})
    mock('../../services/users', userServiceMock)
    include("tests/specHelper").login()
    app = include('app').getApp

  afterEach ->
    mockery.disable()

  it 'POST /api/conLimiteDiPrezzo/vendita', (done) ->
    request(app).post('/api/conLimiteDiPrezzo/vendita')
    .send {shares: 999, price: 1}
    .expect(201)
    .end (err, res) ->
      if err
        return done(err)
      res.body.should.have.property('id').which.is.a.String()
      res.body.should.have.property('qty').which.is.a.Number()
      res.body.should.have.property('price').which.is.a.Number()
      done()

  it 'POST /api/conLimiteDiPrezzo/aquisito', (done) ->
    request(app).post('/api/conLimiteDiPrezzo/aquisito')
    .send {shares: 999, price: 2}
    .expect(201)
    .end (err, res) ->
      if err
        return done(err)
      res.body.should.have.property('id').which.is.a.String()
      res.body.should.have.property('qty').which.is.a.Number()
      res.body.should.have.property('price').which.is.a.Number()
      done()

  it 'POST /api/conLimiteDiPrezzo/vendita should fail if try to ofer more shares than the user have', (done) ->
    request(app).post('/api/conLimiteDiPrezzo/vendita')
    .send {shares: 1001, price: 1}
    .expect(400)
    .end (err, res) ->
      if err
        return done(err)
      res.body.should.have.property('error', "Non c'e abaztanzza quantita di shares")
      done()

  it 'POST /api/conLimiteDiPrezzo/aquisito should fail if try to ofer more cash than the user have', (done) ->
    request(app).post('/api/conLimiteDiPrezzo/aquisito')
    .send {shares: 1001, price: 2}
    .expect(400)
    .end (err, res) ->
      if err
        return done(err)
      res.body.should.have.property('error', "Non c'e abaztanzza quantita di cash")
      done()
