app = angular.module 'app',
['ngTable'
 'ui.router']

app.constant "API_URL", "http://localhost:8080/api"

app.factory "api", ($http, API_URL) ->
  class Service
    getAsks: ->
      @_extractData $http.get("#{API_URL}/asks")

    getBids: ->
      @_extractData $http.get("#{API_URL}/bids")

    _extractData: (result) ->
      result
      .then (data) =>
        data.data

  new Service()

app.config ($stateProvider, apiProvider) ->
  api = apiProvider.$get()

  $stateProvider
  .state "index",
    url: ""
    views:
      asks:
        templateUrl: "views/asks"
        controller: "askController"
        resolve:
          asks: -> api.getAsks()
      bids:
        templateUrl: "views/bids"
        controller: "bidController"
        resolve:
          bids: -> api.getBids()
