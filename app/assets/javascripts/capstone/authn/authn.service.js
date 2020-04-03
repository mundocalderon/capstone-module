(function() {
    'use strict';

    angular
        .module('capstone.authn')
        .service('capstone.authn.Authn', Authn);

    Authn.$inject = ['$auth'];

    /* @ngInject */
    function Authn($auth) {
        var service = this;
        service.signup = signup

        return;
        ////////////////

        function signup(registration) {
          return $auth.submitRegistration(registration);
        }
    }
})();