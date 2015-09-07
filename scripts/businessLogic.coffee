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

app.factory 'PropostaConLimiteDiPrezzoDiVendita', (userApi, propostaConLimiteDiPrezzoDiVenditaApi) ->
  class PropostaConLimiteDiPrezzo
    perform: (elem) => #elem = {qty,price}
      userApi.get()
      .then (user) ->
        return window.alert 'Non ha disponibilità di lettere' if(user.wallet.shares < elem.shares)
        propostaConLimiteDiPrezzoDiVenditaApi.post(elem)


app.factory 'PropostaConLimiteDiPrezzoDiAquisito', (userApi, propostaConLimiteDiPrezzoDiAquisitoApi) ->
  class PropostaConLimiteDiPrezzo
    perform: (elem) => #elem = {qty,price}
      userApi.get()
      .then (user) ->
        return window.alert 'Non ha disponibilità liquide' if(user.wallet.cash < (elem.shares * elem.price)
        propostaConLimiteDiPrezzoDiAquisitoApi.post(elem)
