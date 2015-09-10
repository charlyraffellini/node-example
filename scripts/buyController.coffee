app.controller 'buyController', ($scope, PropostaConLimiteDiPrezzoDiAquisito, PropostaAMercatoDiAquisito, PropostaSenzaLimiteDiPrezzoDiAquisito) ->

  $scope.propostaConLimiteDiPrezzo = new PropostaConLimiteDiPrezzoDiAquisito()
  $scope.propostaAMercato = new PropostaAMercatoDiAquisito()
  $scope.propostaSenzaLimiteDiPrezzo = new PropostaSenzaLimiteDiPrezzoDiAquisito()

  $scope.performProposta = ->
    $scope.proposta.perform $scope.elem
