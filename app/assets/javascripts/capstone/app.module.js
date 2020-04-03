(function() {
    'use strict';

    angular
        .module('capstone', [
            'ui.router',
            'capstone.config',
            'capstone.authn',
            'capstone.cities'
        ]);
})();