(function() {
    'use strict';

    angular
        .module('capstone.cities')
        .directive('capCities', CitiesDirective);

    CitiesDirective.$inject = ['capstone.APP_CONFIG'];

    function CitiesDirective(APP_CONFIG) {
        // Usage:
        //<cap-cities></cap-cities>
        // Creates:
        //
        var directive = {
        	templateUrl: APP_CONFIG.cities_html,
        	replace: true,
            bindToController: true,
            controller: "capstone.cities.CitiesController",
            controllerAs: 'citiesVM',
            link: link,
            restrict: 'E',
            scope: {}
        };
        return directive;

        function link(scope, element, attrs) {
        	console.log("FoosDirectiveLinkLog", scope);
        }
    }
})();