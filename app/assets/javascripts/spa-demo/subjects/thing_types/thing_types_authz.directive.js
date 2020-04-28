(function() {
  "use strict";

  angular
    .module("spa-demo.subjects")
    .directive("sdThingTypesAuthz", ThingTypesAuthzDirective);

  ThingTypesAuthzDirective.$inject = [];

  function ThingTypesAuthzDirective() {
    var directive = {
        bindToController: true,
        controller: ThingTypesAuthzController,
        controllerAs: "vm",
        restrict: "A",
        link: link
    };
    return directive;

    function link(scope, element, attrs) {
      console.log("ThingTypesAuthzDirective", scope);
    }
  }

  ThingTypesAuthzController.$inject = ["$scope", 
                                  "spa-demo.subjects.ThingTypesAuthz"];
  function ThingTypesAuthzController($scope, ThingTypesAuthz) {
    var vm = this;
    vm.authz={};
    vm.authz.canUpdateItem = canUpdateItem;
    vm.newItem=newItem;

    activate();
    return;
    ////////////
    function activate() {
      vm.newItem(null);
    }

    function newItem(item) {
      ThingTypesAuthz.getAuthorizedUser().then(
        function(user){ authzUserItem(item, user); },
        function(user){ authzUserItem(item, user); });
    }

    function authzUserItem(item, user) {
      console.log("new Item/Authz", item, user);

      vm.authz.authenticated = ThingTypesAuthz.isAuthenticated();
      vm.authz.canQuery      = ThingTypesAuthz.canQuery();
      if (item && item.$promise) {
        vm.authz.canUpdate      = false;
        item.$promise.then(function(){ checkAccess(item); });
      } else {
        checkAccess(item);
      }      
    }

    function checkAccess(item) {
      vm.authz.canUpdate     = ThingTypesAuthz.canUpdate(item);
      console.log("checkAccess", item, vm.authz);
    }

    function canUpdateItem(item) {
      console.log("IN the directive calling canUpdateItem", item)
      return ThingTypesAuthz.canUpdate(item);
    }    
  }
})();
