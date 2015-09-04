"use strict"
app.controller 'bidController', ($scope, bids, NgTableParams, $filter, bidApi, summaryMaker, PropostaConLimiteDiPrezzo) ->
  $scope.elem = {}
  $scope.bids = bids
  $scope.summary = summaryMaker.makeSummary $scope.bids
  $scope.propostaConLimiteDiPrezzo = new PropostaConLimiteDiPrezzo(bidApi)

  $scope.performProposta = ->
    $scope.proposta.perform $scope.elem

  $scope.tableParams = new NgTableParams
    page: 1
    count: 10
  ,
    total: $scope.summary.length
    getData: ($defer, params) ->

      orderedData = if params.sorting() then $filter('orderBy')($scope.summary, params.orderBy()) else $scope.summary
      params.total orderedData.length
      # set total for recalc pagination
      $defer.resolve $scope.summary = orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count())

  $scope.$watchCollection 'bids', (newValue, oldValue) ->
    if (newValue != oldValue)
      $scope.summary = summaryMaker.makeSummary $scope.bids
      $scope.tableParams.reload();
