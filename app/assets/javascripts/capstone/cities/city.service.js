(function() {
    'use strict';

    angular
        .module('capstone.cities')
        .factory('capstone.cities.City', CityFactory);

    CityFactory.$inject = ['$resource', 'capstone.APP_CONFIG'];

    /* @ngInject */
    function serviceFactory($resource, APP_CONFIG) {
    	return $resource(APP_CONFIG.server_url + "/api/cities/:id",
    		{ id: '@id'},
    		{ update: { method: "PUT" }
    	});
    }
})();