(function() {
    'use strict';

    angular
        .module('capstone.subjects')
        .factory('capstone.subjects.ImageThing', ImageThing);

    ImageThing.$inject = ['$resource', 'capstone.config.APP_CONFIG'];

    /* @ngInject */
    function ImageThing($resource, APP_CONFIG) {
    	return $resource(APP_CONFIG.server_url + '/api/images/:image_id/thing_images');
    }
})();