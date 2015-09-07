app.controller 'askController', ($scope, asks, NgTableParams, $filter, askApi, summaryMaker, PropostaConLimiteDiPrezzoDiAquisito, socket) ->
  $scope.elem = {}
  $scope.asks = asks
  $scope.summary = summaryMaker.makeSummary $scope.asks
  $scope.propostaConLimiteDiPrezzo = new PropostaConLimiteDiPrezzoDiAquisito()

  $scope.performProposta = ->
    $scope.proposta.perform $scope.elem

  $scope.tableParams = new NgTableParams
    page: 1
    count: 10
  ,
    total: $scope.summary.length
    getData: ($defer, params) ->
      # use built-in angular filter
      orderedData = if params.sorting() then $filter('orderBy')($scope.summary, params.orderBy()) else $scope.summary
      params.total orderedData.length
      # set total for recalc pagination
      $defer.resolve $scope.summary = orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count())

  $scope.$watchCollection 'asks', (newValue, oldValue) ->
    if (newValue != oldValue)
      $scope.summary = summaryMaker.makeSummary $scope.asks
      $scope.tableParams.reload();

  socket.on('new-ask', (data) ->
    newAsk = data
    $scope.asks.push(newAsk))

  socket.on 'removed-ask', (data) ->
    removerdAsk = data
    if !!data
      index = _.findLastIndex($scope.asks, (e) -> e.id == removerdAsk.id)
      _.pullAt($scope.asks, index)
