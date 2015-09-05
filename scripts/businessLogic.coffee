toFixed2 = (elem) ->
  elem.price = parseFloat elem.price.toFixed(2)
  elem

app.factory "summaryMaker", () ->
  class SummaryMaker
    makeSummary: (collection) ->
      fixedCollection = _.map collection, toFixed2
      uniquePrices = _.chain(fixedCollection).pluck('price').unique().map((p) -> price: p ).value()
      pricesWithNumeroDiProposte = _.map uniquePrices,
      (p) =>
        p.numeroDiProposte = _.filter(fixedCollection, (e) -> e.price == p.price).length
        p
      pricesWithNumeroDiProposteEQuantitaDiTitoli = _.map pricesWithNumeroDiProposte,
      (p) =>
        p.quantitaDiTitoli = _.chain(fixedCollection).filter((e) -> e.price == p.price).sum('qty').value()
        p

      pricesWithNumeroDiProposteEQuantitaDiTitoli

  new SummaryMaker

app.factory 'PropostaConLimiteDiPrezzo', (USER_ID) ->
  console.log USER_ID
  class PropostaConLimiteDiPrezzo
    constructor: (@service) ->

    perform: (elem) => #elem = {qty,price}
      elem.userid = USER_ID
      @service.create elem
