// Generated by CoffeeScript 1.8.0
(function() {
  angular.module('Calculator', ['ui.slider']).directive('calculator', function($q, $http) {
    return {
      restrict: 'E',
      templateUrl: 'partials/calculator_element.html',
      controller: function($scope) {
        var constraints, offer, requestOptions;
        $scope.output = {};
        requestOptions = {
          headers: {
            'Accept': 'application/json; charset=utf-8',
            'Content-Type': 'application/json'
          }
        };
        offer = $http.get("http://localhost:3000/offer", requestOptions);
        constraints = $http.get("http://localhost:3000/constraints", requestOptions);
        return $q.all([offer, constraints]).then(function(result) {
          var tmp;
          tmp = [];
          return angular.forEach(result, function(response, key, obj) {
            if (response.data.hasOwnProperty('offer')) {
              $scope.viewOffer = response.data.offer;
            }
            if (response.data.hasOwnProperty('constraints')) {
              $scope.viewConstraints = response.data;
              $scope.output.amount = {
                current: parseInt(response.data.constraints.amount_interval.default_value),
                min: parseInt(response.data.constraints.amount_interval.min),
                max: parseInt(response.data.constraints.amount_interval.max),
                step: parseInt(response.data.constraints.amount_interval.step)
              };
              $scope.output.term = {
                current: parseInt(response.data.constraints.term_interval.default_value),
                min: parseInt(response.data.constraints.term_interval.min),
                max: parseInt(response.data.constraints.term_interval.max),
                step: parseInt(response.data.constraints.term_interval.step)
              };
              return console.log($scope.viewConstraints);
            }
          });
        });
      }
    };
  }).filter('timestamp', function() {
    return function(input) {
      var now;
      now = new Date().getTime();
      return (input * 24 * 60 * 60 * 1000) + now;
    };
  });

}).call(this);
