###!

###

'use strict';

# Requires jQuery
angular.module('neo4jApp.directives')
  .directive('tenguBundle', ['$rootScope', 'Frame','Settings', ($rootScope, Frame, Settings) ->
    restrict: 'A'
    link: (scope, element, attrs) ->

      bundle = attrs.tenguBundle
      command = "tengu model create"

      if bundle
        element.on 'click', (e) ->
          e.preventDefault()
          bundle = bundle.toLowerCase().trim()
          Frame.create(input: "#{Settings.cmdchar}#{command} --bundle #{bundle}")
          $rootScope.$apply() unless $rootScope.$$phase

  ])
