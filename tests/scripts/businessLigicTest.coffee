summaryMaker = null
collection = null

describe "SummaryMaker", ->
  beforeEach inject (_summaryMaker_) ->
    summaryMaker = _summaryMaker_

  describe "#makeSummary", ->
    describe 'for a simple collection', ->
      beforeEach ->
        collection =[
          qty: 410
          price: 4.9391
        ]

      it 'return a well formed summary', ->
        expect(summaryMaker.makeSummary(collection)).toEqual [
           price : 4.94
           numeroDiProposte : 1
           quantitaDiTitoli : 410
        ]

    describe 'for a complex collection', ->
      beforeEach ->
        collection = [
          qty: 100
          price: 4.9391
        ,
          qty: 200
          price: 4.9392
        ,
          qty: 500
          price: 4.8392
        ,
          qty: 500
          price: 4.8391
        ]

      it 'return a well formed summary', ->
        expect(summaryMaker.makeSummary(collection)).toEqual [
          price : 4.94
          numeroDiProposte : 2
          quantitaDiTitoli : 300
        ,
          price : 4.84
          numeroDiProposte : 2
          quantitaDiTitoli : 1000
        ]
