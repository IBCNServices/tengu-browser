###!

###

'use strict'

angular.module('neo4jApp.controllers')
  .controller 'TenguCtrl', [
    '$scope'
    'GeniAuthService'
    'Frame'
    'Settings'
    ($scope, GeniAuthService, Frame, Settings) ->
      $scope.static_is_authenticated = GeniAuthService.hasValidAuthorization()

      $scope.authenticate = () ->
        $scope.frame.resetError()
        Frame.createOne({input:"#{Settings.cmdchar}server connect"})

      $scope.bundle = (bundle) ->
        $scope.frame.resetError()
        Frame.create {input: "#{Settings.cmdchar}tengu bundle #{bundle}"}
      
  ]