"use strict"
app.factory "BaseApi", () ->
  class BaseApi
    _extractData: (result) ->
      result
      .then (data) =>
        data.data

app.factory "askApi", ($http, API_URL, BaseApi) ->
  class AskApi extends BaseApi
    get: ->
      @_extractData $http.get("#{API_URL}/asks")

    create: (ask) ->
      @_extractData $http.post("#{API_URL}/asks", ask)

  new AskApi()

app.factory "bidApi", ($http, API_URL, BaseApi) ->
    class BidApi extends BaseApi
      get: ->
        @_extractData $http.get("#{API_URL}/bids")

      create: (bid) ->
        @_extractData $http.post("#{API_URL}/bids", bid)

    new BidApi()

app.factory "userApi", ($http, API_URL, BaseApi) ->
    class UserApi extends BaseApi
      get: ->
        @_extractData $http.get("#{API_URL}/user/me")

    new UserApi()

app.factory "propostaConLimiteDiPrezzoApi", ($http, API_URL, BaseApi) ->
  class PropostaConLimiteDiPrezzoApi extends BaseApi
    postVendita: (proposta) ->
      @_extractData $http.post("#{API_URL}/conLimiteDiPrezzo/vendita", proposta)

    postAquisito: (proposta) ->
      @_extractData $http.post("#{API_URL}/conLimiteDiPrezzo/aquisito", proposta)

  new PropostaConLimiteDiPrezzoApi()

app.factory "propostaAMercatoApi", ($http, API_URL, BaseApi) ->
  class PropostaAMercatoApi extends BaseApi
    postVendita: (proposta) ->
      @_extractData $http.post("#{API_URL}/propostaAMercato/vendita", proposta)

    postAquisito: (proposta) ->
      @_extractData $http.post("#{API_URL}/propostaAMercato/aquisito", proposta)

  new PropostaAMercatoApi()

app.factory "propostaSenzaLimiteDiPrezzoApi", ($http, API_URL, BaseApi) ->
  class PropostaAMercatoApi extends BaseApi
    postVendita: (proposta) ->
      @_extractData $http.post("#{API_URL}/propostaSenzaLimiteDiPrezzo/vendita", proposta)

    postAquisito: (proposta) ->
      @_extractData $http.post("#{API_URL}/propostaSenzaLimiteDiPrezzo/aquisito", proposta)

  new PropostaAMercatoApi()
