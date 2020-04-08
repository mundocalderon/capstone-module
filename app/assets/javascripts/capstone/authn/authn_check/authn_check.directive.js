(function() {
    'use strict';

    angular
        .module('capstone.authn')
        .directive('capAuthnCheck', AuthnCheck);

    AuthnCheck.$inject = [];

    /* @ngInject */
    function AuthnCheck(APP_CONFIG) {
        var directive = {
            bindToController: true,
            controller: AuthnCheckController,
            controllerAs: 'idVM',
            link: link,
            restrict: 'A',
            scope: false
        };
        return directive;

        function link(scope, element, attrs) {
          console.log("AuthnCheck", scope)
        }
    }

    /* @ngInject */
    AuthnCheckController.$inject = ["$auth", "capstone.authn.whoAmI", "capstone.authn.checkMe"];
    function AuthnCheckController($auth, whoAmI, checkMe) {
      var vm = this;
      vm.client = {}
      vm.server = {}
      vm.getClientUser = getClientUser;
      vm.whoAmI = getServerUser;
      vm.checkMe = checkServerUser;

      return;
      ///////////////////
      function getClientUser(){
        vm.client.currentUser = $auth.user;

      }

      function getServerUser(){
        vm.server.whoAmI = null;
        whoAmI.get().$promise.then(
          function(value){ vm.server.whoAmI = value; },
          function(value){ vm.server.whoAmI = value; }
        );
      }

      function checkServerUser(){
        vm.server.checkMe = null;
        checkMe.get().$promise.then(
          function(value){ vm.server.checkMe = value; },
          function(value){ vm.server.checkMe = value; }
        );
      }
    }
})();