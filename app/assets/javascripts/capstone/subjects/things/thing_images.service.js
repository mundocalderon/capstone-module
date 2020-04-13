(function() {
    'use strict';

    angular
        .module('capstone.subjects')
        .factory('capstone.subjects.ThingImage', ThingImage);

    ThingImage.$inject = ['$resource', 'capstone.config.APP_CONFIG'];

    /* @ngInject */
    function ThingImage($resource, APP_CONFIG) {
    	return $resource(APP_CONFIG.server_url + '/api/things/:thing_id/thing_images/:id',
    		{ thing_id: '@thing_id',
    			id: '@id'},
    		{ update: {method: "PUT"}
    	});
    }
    
})();