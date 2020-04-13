(function() {
    'use strict';

    angular
        .module('capstone.subjects')
        .factory('capstone.subjects.ImageLinkableThing', ImageLinkableThing);

    ImageLinkableThing.$inject = ['$resource', 'capstone.config.APP_CONFIG'];
    function ImageLinkableThing($resource, APP_CONFIG) {
    	return $resource(APP_CONFIG.server_url + "/api/images/:image_id/linkable_things");
    }
    
})();