(function() {
    'use strict';

    angular
        .module('capstone', [
            'ui.router',
            'ngFileUpload',
            'uiCropper',  
            'capstone.config',
            'capstone.authn',
            'capstone.authz',
            'capstone.geoloc',
            'capstone.layout',
            'capstone.cities',
            'capstone.subjects'
        ]);
})();