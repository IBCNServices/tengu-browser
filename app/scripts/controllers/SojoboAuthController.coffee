###!

###

'use strict'

angular.module('neo4jApp.controllers')
  .controller 'SojoboAuthCtrl', [
    '$scope'
    'CurrentUser'
    'Frame'
    'Settings'
    '$http'
    '$timeout'
    ($scope, CurrentUser, Frame, Settings, $http, $timeout) ->
      $scope.username = ''
      $scope.password = ''
      $scope.static_user = ''

      $scope.$watch 'frame.response', (resp) ->
        return unless resp
        if resp.authenticated?
          $scope.static_is_authenticated = resp.authenticated
          if $scope.static_is_authenticated
            $scope.static_user = CurrentUser.getToken('profile').name

        if resp.userinfo?
          $scope.user_info = resp.userinfo
          $scope.models = []
          for ctrl in $scope.user_info.controllers
            console.log ctrl
            if ctrl.models?
              for model in ctrl.models
                console.log model
                $scope.models.push {
                  name       : model.name
                  controller : ctrl.name
                  access     : model.access
                  type       : ctrl.type
                }

      $scope.signin = () ->
        if not $scope.username? || not $scope.username.length
          $scope.frame.addErrorText 'You have to enter a username to sign in. '
        if not $scope.password? || not $scope.password.length
          $scope.frame.addErrorText 'You have to enter a password. We do not check the password strength.'
        return if $scope.frame.getDetailedErrorText().length

        CurrentUser.login($scope.username, $scope.password)
        .then( ->
          $scope.static_user = $scope.username
          $scope.static_is_authenticated = CurrentUser.isAuthenticated()
          $scope.frame.resetError()

          Frame.createOne({input:"#{Settings.initCmd}"})
          $scope.focusEditor()
        , (r) ->
          $scope.frame.addErrorText "Something went wrong while login in to the Sojobo: " + r
        )

      $scope.changePassword = () ->
        if not $scope.password? || not $scope.password.length
          $scope.frame.addErrorText 'You have to enter a password. We do not check the password strength.'
        return if $scope.frame.getDetailedErrorText().length

        url = Settings.endpoint.tengu + "/users/" + $scope.static_user
        basicAuth = CurrentUser.getToken('token')

        req = {
          "method"  : "PUT"
          "url"     : url
          "headers"  : {
            "Content-Type"  : "application/json"
            "api-key"       : Settings.apiKey
            "Authorization" : "Basic " + basicAuth
          }
          "data"    : {
            "password"    : $scope.password
          }
        }

        $http(req).then(
          (response) ->
            CurrentUser.login($scope.static_user, $scope.password)
            .then( ->
              $scope.static_is_authenticated = CurrentUser.isAuthenticated()
              $scope.frame.resetError()
            , (r)->
              $scope.frame.addErrorText "Something went wrong while login in to the Sojobo: " + r
            )
          , (r) ->
            console.log(r)
            $scope.frame.setError "There was an error in creating the Model: " + r.data
        )

  ]
