app.controller 'askController', ($scope, asks, api, NgTableParams, $filter) ->
  $scope.asks = asks
  $scope.tableParams = new NgTableParams
    page: 1
    count: 10
  ,
    total: $scope.asks.length
    getData: ($defer, params) ->
      # use built-in angular filter
      orderedData = if params.sorting() then $filter('orderBy')($scope.asks, params.orderBy()) else $scope.asks
      params.total orderedData.length
      # set total for recalc pagination
      $defer.resolve $scope.asks = orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count())

  $scope.$watchCollection 'asks', (newValue, oldValue) ->
    if (newValue != oldValue)
      $scope.tableParams.reload();
