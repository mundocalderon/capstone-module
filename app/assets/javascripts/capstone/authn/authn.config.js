(function() {
    'use strict';

    angular
        .module('capstone.authn')
        .config(AuthnConfig);

    AuthnConfig.$inject = ["$authProvider", "capstone.config.APP_CONFIG"];

    function AuthnConfig($authProvider, APP_CONFIG) {
      $authProvider.configure({
        apiUrl: APP_CONFIG.server_url,
        validateOnPageLoad: false
      });
    }
})();