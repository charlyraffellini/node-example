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

  new AskApi()

app.factory "bidApi", ($http, API_URL, BaseApi) ->
    class BidApi extends BaseApi
      get: ->
        @_extractData $http.get("#{API_URL}/bids")

    new BidApi()
