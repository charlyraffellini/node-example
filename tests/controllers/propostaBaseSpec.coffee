include = require 'include'
mockery = require 'mockery'
mock = require 'mock-require'

dataClone = (elem) ->
  JSON.parse JSON.stringify(elem)

userCollection = [
  id: "1"
  wallet:
    cash: 100.00
    shares: 100
,
  id: "2"
  wallet:
    cash: 50.00
    shares: 100
,
  id: "3"
  wallet:
    cash: 50.00
    shares: 100
,
  id: "4"
  wallet:
    cash: 50.00
    shares: 100
]

bidCollection = [
  "id": "1",
  "userid": "2",
  "qty": 10,
  "price": 2.0001
,
  "id": "2",
  "userid": "3",
  "qty": 10,
  "price": 1.999999
,
  "id": "3",
  "userid": "4",
  "qty": 10,
  "price": 5
]

askCollection = [
  "id": "1",
  "userid": "2",
  "qty": 10,
  "price": 2.0001
,
  "id": "2",
  "userid": "3",
  "qty": 10,
  "price": 1.999999
,
  "id": "3",
  "userid": "4",
  "qty": 10,
  "price": 5
]

propostaBase = null
bidService = null
userService = null
askService = null

describe "Proposta a un prezzo", ->
  beforeEach ->
    include("tests/specHelper").clearRequires()
    userService = new include('services/users')
    bidService = new include('services/bids')
    askService = new include('services/asks')
    bidService.collection = dataClone bidCollection
    askService.collection = dataClone askCollection
    userService.collection = dataClone userCollection
    PropostaBase = include('controllers/propostaBase')
    propostaBase = new PropostaBase()

  afterEach ->
    mockery.disable()

  describe "quando non c'e abbastanza a un prezzo", ->
    it "posso vendere tutto a un prezzo", ->
      user = userService.getById("1")
      lettereCherestano = propostaBase.vendereLettere(userService.getById("1"), 2, 100)
      lettereCherestano.should.be.exactly 80
      user.wallet.shares.should.be.exactly 80
      user.wallet.cash.should.be.exactly 140.00099
      (JSON.stringify bidService.getAll()).should.equal JSON.stringify [
        "id": "3",
        "userid": "4",
        "qty": 10,
        "price": 5
      ]

      (JSON.stringify userService.getAll()).should.equal JSON.stringify [
          id: "1"
          wallet:
            cash: 140.00099
            shares: 80
        ,
          id: "2"
          wallet:
            cash: 29.999
            shares: 110
        ,
          id: "3"
          wallet:
            cash: 30.00001
            shares: 110
        ,
          id: "4"
          wallet:
            cash: 50.00
            shares: 100
      ]

  describe "quando c'e abbastanza a un prezzo", ->
    it "posso vendere tutto a un prezzo", ->
      user = userService.getById("1")
      lettereCherestano = propostaBase.vendereLettere(userService.getById("1"), 2, 14)
      lettereCherestano.should.be.exactly 0
      user.wallet.shares.should.be.exactly 86
      user.wallet.cash.should.be.exactly 128.00099600000001
      (JSON.stringify bidService.getAll()).should.equal JSON.stringify [
        "id": "2",
        "userid": "3",
        "qty": 6,
        "price": 1.999999
      ,
        "id": "3",
        "userid": "4",
        "qty": 10,
        "price": 5
      ]

      (JSON.stringify userService.getAll()).should.equal JSON.stringify [
          id: "1"
          wallet:
            cash: 128.00099600000001
            shares: 86
        ,
          id: "2"
          wallet:
            cash: 29.999
            shares: 110
        ,
          id: "3"
          wallet:
            cash: 42.000004
            shares: 104
        ,
          id: "4"
          wallet:
            cash: 50.00
            shares: 100
      ]

  describe "quando non c'e abbastanza a un prezzo", ->
    it "posso aquisitare tutto a un prezzo", ->
      user = userService.getById("1")
      lettereCherestano = propostaBase.aquisitareLettere(userService.getById("1"), 2, 100)
      lettereCherestano.should.be.exactly 80
      user.wallet.shares.should.be.exactly 120
      user.wallet.cash.should.be.exactly 59.99901
      (JSON.stringify askService.getAll()).should.equal JSON.stringify [
        "id": "3",
        "userid": "4",
        "qty": 10,
        "price": 5
      ]

      (JSON.stringify userService.getAll()).should.equal JSON.stringify [
          id: "1"
          wallet:
            cash: 59.99901
            shares: 120
        ,
          id: "2"
          wallet:
            cash: 70.001
            shares: 90
        ,
          id: "3"
          wallet:
            cash: 69.99999
            shares: 90
        ,
          id: "4"
          wallet:
            cash: 50.00
            shares: 100
      ]
