# Calculator Module
#
# Microloan calculator

angular
        .module 'Calculator', ['ui.slider']
        

        # MAIN directive
        .directive 'calculator', ($q, $http) ->
          restrict: 'E'
          templateUrl: 'partials/calculator_element.html'
          controller: ($scope) ->
            
            $scope.output = {}

            requestOptions =
              headers:
                'Accept': 'application/json; charset=utf-8'
                'Content-Type': 'application/json'

            offer = $http.get "http://localhost:3000/offer",
              requestOptions

            constraints = $http.get "http://localhost:3000/constraints",
              requestOptions

            $q.all([ offer, constraints])
            .then (result) ->
              tmp = []
              angular.forEach result, (response, key, obj) ->
                if response.data.hasOwnProperty 'offer'
                  $scope.viewOffer = response.data.offer
                if response.data.hasOwnProperty 'constraints'
                  $scope.viewConstraints = response.data

                  $scope.output.amount=
                    current: parseInt response.data.constraints.amount_interval.default_value
                    min: parseInt response.data.constraints.amount_interval.min
                    max: parseInt response.data.constraints.amount_interval.max
                    step: parseInt response.data.constraints.amount_interval.step

                  $scope.output.term=
                    current: parseInt response.data.constraints.term_interval.default_value
                    min: parseInt response.data.constraints.term_interval.min
                    max: parseInt response.data.constraints.term_interval.max
                    step: parseInt response.data.constraints.term_interval.step


                  console.log $scope.viewConstraints # zmazat


        .filter 'timestamp', () ->
          return (input) ->
            now = new Date().getTime()
            (input * 24*60*60*1000) + now
