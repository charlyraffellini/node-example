app.controller 'askController', ($scope, asks, NgTableParams, $filter, summaryMaker) ->
  $scope.asks = asks
  $scope.summary = summaryMaker.makeSummary $scope.asks

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
