(function() {
  "use strict";

  angular
    .module("spa-demo.subjects")
    .component("sdThingTypeSelector", {
      templateUrl: thingTypeSelectorTemplateUrl,
      controller: ThingTypeSelectorController,
      bindings: {
        authz: "<"
      },
      require: {
        thingTypesAuthz: "^sdThingTypesAuthz"
      }
    })
    ;

  
  thingTypeSelectorTemplateUrl.$inject = ["spa-demo.config.APP_CONFIG"];
  function thingTypeSelectorTemplateUrl(APP_CONFIG) {
    return APP_CONFIG.thing_type_selector_html;
  }    

  ThingTypeSelectorController.$inject = ["$scope", "$state",
                                     "$stateParams",
                                     "spa-demo.authz.Authz",
                                     "spa-demo.subjects.ThingType",
                                     "spa-demo.subjects.ThingTypeThing"];
  function ThingTypeSelectorController($scope, $state, $stateParams, Authz, ThingType, ThingTypeThing) {
    var vm=this;
    vm.clear = clear;

    vm.$onInit = function() {
      console.log("ThingTypeSelectorController",$scope);
      $scope.$watch(function(){ return Authz.getAuthorizedUserId(); }, 
                    function(){ 
                      if (!$stateParams.id) {
                        vm.items = ThingType.query();
                      } else if ($stateParams.id) {
                        vm.item = ThingType.get($stateParams);
                        vm.things = ThingTypeThing.query($stateParams);
                        vm.thingTypesAuthz.newItem(vm.item);        
                      }
                    });
    }
    return;
    //////////////

    function clear(){
      $state.go(".",{id: null});    
    }
  }

})();
