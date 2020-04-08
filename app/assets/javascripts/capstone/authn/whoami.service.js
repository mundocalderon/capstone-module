(function() {
    'use strict';

    angular
        .module('capstone.authn')
        .factory('capstone.authn.whoAmI', WhoAmIFactory);

    WhoAmIFactory.$inject = ['$resource', 'capstone.config.APP_CONFIG'];

    function WhoAmIFactory($resource, APP_CONFIG) {
        return $resource(APP_CONFIG.server_url + "/authn/whoami");;
    }
})();