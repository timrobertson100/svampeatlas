'use strict';

angular.module('svampeatlasApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('demos', {

        url: '/demos',
        templateUrl: 'app/demos/demos.html',
        controller: 'DemosCtrl'
      });
  });