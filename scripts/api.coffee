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

app.factory "propostaConLimiteDiPrezzoDiVenditaApi", ($http, API_URL, BaseApi) ->
  class PropostaConLimiteDiPrezzoDiVenditaApi extends BaseApi
    post: (proposta) ->
      @_extractData $http.post("#{API_URL}/conLimiteDiPrezzo/vendita", proposta)

  new PropostaConLimiteDiPrezzoDiVenditaApi()

app.factory "propostaConLimiteDiPrezzoDiAquisitoApi", ($http, API_URL, BaseApi) ->
  class PropostaConLimiteDiPrezzoDiAquisitoApi extends BaseApi
    post: (proposta) ->
      @_extractData $http.post("#{API_URL}/conLimiteDiPrezzo/aquisito", proposta)

  new PropostaConLimiteDiPrezzoDiAquisitoApi()
