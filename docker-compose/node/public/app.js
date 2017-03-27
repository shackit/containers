var app = angular.module('flapperNews', []);

app.controller('MainCtrl', [
  '$scope',
    function($scope){

      $scope.txt = 'Docker Demo';

    }
  ]
);
