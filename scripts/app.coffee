app = angular.module 'app',
['ngTable'
 'ui.router']

app.constant "API_URL", "http://localhost:8080/api"

app.config ($stateProvider, askApiProvider, bidApiProvider) ->
  askApi = askApiProvider.$get()
  bidApi = bidApiProvider.$get()

  $stateProvider
  .state "index",
    url: ""
    views:
      asks:
        templateUrl: "views/asks"
        controller: "askController"
        resolve:
          asks: -> askApi.get()
      bids:
        templateUrl: "views/bids"
        controller: "bidController"
        resolve:
          bids: -> bidApi.get()
