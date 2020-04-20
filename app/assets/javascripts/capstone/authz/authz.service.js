(function() {
    'use strict';

    angular
        .module('capstone.authz')
        .service('capstone.authz.Authz', Authz);

    Authz.$inject = ['$rootScope', '$q', 'capstone.authn.Authn', 'capstone.authn.whoAmI'];

    function Authz($rootScope, $q, Authn, whoAmI) {
        var service = this;
        
        return;
        ////////////////

    }
})();