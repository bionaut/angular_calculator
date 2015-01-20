# Calculator Module
# Microloan calculator

angular
        .module 'Calculator', ['jk.slider']
        

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
                
                # offer
                if response.data.hasOwnProperty 'offer'
                  
                  # format output for sidebar fees
                  angular.forEach response.data.offer.extension_fees, (value, key) ->
                    tmp.push
                      days: key
                      price: value
                  $scope.output.fees = tmp

                  # format output for sidebar
                  $scope.output.sidebar =
                    new_interest_before_discount: parseInt response.data.offer.new_interest_before_discount
                    interest_rate:                parseInt response.data.offer.interest_rate
                    annual_percentage_rate:       parseInt response.data.offer.annual_percentage_rate


                # constraints
                if response.data.hasOwnProperty 'constraints'
                  $scope.viewConstraints = response.data

                  $scope.output.amount=
                    current:    parseInt response.data.constraints.amount_interval.default_value
                    min:        parseInt response.data.constraints.amount_interval.min
                    max:        parseInt response.data.constraints.amount_interval.max
                    step:       parseInt response.data.constraints.amount_interval.step
                    limits:     response.data.constraints.loan_limits

                  $scope.output.term=
                    current:    parseInt response.data.constraints.term_interval.default_value
                    min:        parseInt response.data.constraints.term_interval.min
                    max:        parseInt response.data.constraints.term_interval.max
                    step:       parseInt response.data.constraints.term_interval.step
                    # limits:   response.data.constraints.loan_limits


        .filter 'timestamp', () ->
          return (input) ->
            now = new Date().getTime()
            (input * 24*60*60*1000) + now
