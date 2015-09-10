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

app.factory 'PropostaDiVendita', (userApi) ->
  class PropostaDiVendita
    perform: (elem) => #elem = {qty,price}
      userApi.get()
      .then (user) ->
        message = 'Non ha disponibilità di lettere'
        if(user.wallet.shares < elem.shares)
          window.alert(message)
          throw new Error(message)

app.factory 'PropostaDiAquisito', (userApi) ->
  class PropostaDiAquisito
    perform: (elem) => #elem = {qty,price}
      userApi.get()
      .then (user) ->
        message = 'Non ha disponibilità liquide'
        if(user.wallet.cash < (elem.shares * elem.price))
          window.alert(message)
          throw new Error(message)

app.factory 'PropostaConLimiteDiPrezzoDiVendita', (PropostaDiVendita, propostaConLimiteDiPrezzoApi) ->
  class PropostaConLimiteDiPrezzoDiVendita extends PropostaDiVendita
    perform: (elem) => #elem = {qty,price}
      super(elem)
      .then () =>
        propostaConLimiteDiPrezzoApi.postVendita(elem)

app.factory 'PropostaConLimiteDiPrezzoDiAquisito', (PropostaDiAquisito, propostaConLimiteDiPrezzoApi) ->
  class PropostaConLimiteDiPrezzoDiAquisito extends PropostaDiAquisito
    perform: (elem) => #elem = {qty,price}
      super(elem)
      .then () =>
        propostaConLimiteDiPrezzoApi.postAquisito(elem)

app.factory 'PropostaAMercatoDiVendita', (PropostaDiVendita, propostaAMercatoApi) ->
  class PropostaAMercatoDiVendita extends PropostaDiVendita
    perform: (elem) => #elem = {qty,price}
      super(elem)
      .then () =>
        propostaAMercatoApi.postVendita(elem)

app.factory 'PropostaAMercatoDiAquisito', (PropostaDiAquisito, propostaAMercatoApi) ->
  class PropostaAMercatoDiAquisito extends PropostaDiAquisito
    perform: (elem) => #elem = {qty,price}
      super(elem)
      .then () =>
        propostaAMercatoApi.postAquisito(elem)

app.factory 'PropostaSenzaLimiteDiPrezzoDiVendita', (PropostaDiVendita, propostaSenzaLimiteDiPrezzoApi) ->
  class PropostaAMercatoDiVendita extends PropostaDiVendita
    perform: (elem) => #elem = {qty,price}
      super(elem)
      .then () =>
        propostaSenzaLimiteDiPrezzoApi.postVendita(elem)

app.factory 'PropostaSenzaLimiteDiPrezzoDiAquisito', (PropostaDiAquisito, propostaSenzaLimiteDiPrezzoApi) ->
  class PropostaAMercatoDiAquisito extends PropostaDiAquisito
    perform: (elem) => #elem = {qty,price}
      super(elem)
      .then () =>
        propostaSenzaLimiteDiPrezzoApi.postAquisito(elem)
