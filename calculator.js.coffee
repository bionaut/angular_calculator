# Calculator Module
#
# Microloan calculator
#

angular
        .module 'Calculator', []

        # CalculatorService
        .factory 'calculatorService', () ->
          loan=
            amount: 7400
            deadline: 30
          
          # return
          loan
          
        
        # MAIN directive
        .directive 'calculator', (calculatorService) ->
          restrict: 'E'
          templateUrl: 'partials/calculator_element.html'
          controller: ($scope) ->
            $scope.service = calculatorService
          

        # range slider
        .directive 'rangeSlider', (calculatorService) ->
          restrict: 'E'
          templateUrl: 'partials/calculator_range_slider.html'
          scope:{
            min: '='
            max: '='
            step: '='
            target: '='
          }
          controller: ($scope) ->
            console.log $scope.target




        # SLIDER directive
        .directive 'calculatorSlider', () ->
          restrict: 'E'
          replace: true
          link: (s,e,a) ->
            $(e).noUiSlider
              start: [ 4000 ]
              range:
                'min': [  2000 ]
                'max': [ 10000 ]


        .filter 'timestamp', () ->
          return (input) ->
            now = new Date().getTime()
            (input * 24*60*60*1000) + now

            