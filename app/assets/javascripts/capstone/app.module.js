(function() {
    'use strict';

    angular
        .module('capstone', [
            'ui.router',
            'capstone.config',
            'capstone.authn',
            'capstone.authz',
            'capstone.layout',
            'capstone.cities',
            'capstone.subjects'
        ]);
})();