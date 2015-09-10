"use strict"
app.controller 'sellController', ($scope, PropostaConLimiteDiPrezzoDiVendita, PropostaAMercatoDiVendita, PropostaSenzaLimiteDiPrezzoDiVendita) ->
  $scope.propostaConLimiteDiPrezzo = new PropostaConLimiteDiPrezzoDiVendita()
  $scope.propostaAMercato = new PropostaAMercatoDiVendita()
  $scope.propostaSenzaLimiteDiPrezzo = new PropostaSenzaLimiteDiPrezzoDiVendita()

  $scope.performProposta = ->
    $scope.proposta.perform $scope.elem
