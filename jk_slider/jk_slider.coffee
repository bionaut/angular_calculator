######################################
# jkSlider Module  ###################
######################################
# Universal multifunctional slider ###
######################################



angular
        .module 'jk.slider', []
        .directive 'jkSlider', () ->
          
          scope:
            min: '='
            max: '='
            step: '='
            current: '='
            limits: '=?'
            inout: '=?'
            # barTooltip: '=?'

          restrict: 'E'
          templateUrl: "vendor/jk_slider/jk_slider.html"
          replace: true

          controller: ($scope) ->

            s = $scope
            
            s.add = (step) ->
              s.current += step
              if s.current > s.max
                s.current = s.max

            s.subtract = (step) ->
              s.current -= step
              if s.current < s.min
                s.current = s.min


            s.$watch 'current', (n) ->
              jednoPercento = (s.max - s.min) / 100
              console.log  s.current/jednoPercento

              


            # if anfular.isObject($scope.barTooltip)
            # $scope.barTooltip = (params) ->
              # if angular.isObject(params)
                # console.log 'je to objekt'
            
            
            