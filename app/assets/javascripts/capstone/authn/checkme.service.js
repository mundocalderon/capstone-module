(function() {
    'use strict';

    angular
        .module('capstone.authn')
        .factory('capstone.authn.checkMe', CheckMeFactory);

    CheckMeFactory.$inject = ['$resource', 'capstone.config.APP_CONFIG'];

    function CheckMeFactory($resource, APP_CONFIG) {
        return $resource(APP_CONFIG.server_url + "/authn/checkme");;
    }
})();