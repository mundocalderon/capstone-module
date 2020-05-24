(function() {
    'use strict';

    angular
        .module('capstone.geoloc')
        .service('capstone.geoloc.geocoder', Geocoder);

    Geocoder.$inject = ['$resource', "capstone.config.APP_CONFIG"];

    /* @ngInject */
    function Geocoder($resource, APP_CONFIG) {
        var service = this;
        service.getLocationByAddress = getLocationByAddress;
        service.getLocationByPosition = getLocationByPosition;

        return;

        ////////////////

        function getLocationByAddress(address) {
        	console.log("locateByAddress=", result)
        }

        function getLocationByPosition(position) {
        	console.log("locateByPosition", this, position )
        }
    }
})();