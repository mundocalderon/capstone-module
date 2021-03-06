(function() {
    'use strict';

    angular
        .module('capstone.geoloc')
        .service('capstone.geoloc.geocoder', Geocoder);

    Geocoder.$inject = ['$resource', "capstone.config.APP_CONFIG"];

    /* @ngInject */
    function Geocoder($resource, APP_CONFIG) {
    		var addresses = $resource(APP_CONFIG.server_url + "/api/geocoder/addresses", {}, { 
    			get: {cache: true}
    		});
    		var positions = $resource(APP_CONFIG.server_url + "/api/geocoder/positions", {}, {
    			get: {cache: true}
    		});
        var service = this;
        service.getLocationByAddress = getLocationByAddress;
        service.getLocationByPosition = getLocationByPosition;

        return;

        ////////////////

        function getLocationByAddress(address) {
        	var result = addresses.get({address: address});
        	// console.log("locateByAddress=", result)
        	return result;
        }

        function getLocationByPosition(position) {
        	var result = positions.get({lng: position.lng, lat:position.lat});
        	// console.log("locateByPosition=", result )
        	return result;
        }
    }
})();