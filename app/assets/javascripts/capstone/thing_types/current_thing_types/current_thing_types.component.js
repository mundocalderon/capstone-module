(function() {
  "use strict";

  angular
    .module("capstone.thingTypes")
    .component("capCurrentThingTypes", {
      templateUrl: thingTypesTemplateUrl,
      controller: CurrentThingTypesController,
    });


  thingTypesTemplateUrl.$inject = ["capstone.config.APP_CONFIG"];
  function thingTypesTemplateUrl(APP_CONFIG) {
    return APP_CONFIG.current_thing_types_html;
  }    

  CurrentThingTypesController.$inject = ["$scope",
                                     "capstone.thingTypes.currentThingTypeSubjects"];
  function CurrentThingTypesController($scope,currentThingTypeSubjects) {
    var vm=this;
    vm.thingTypeClicked = thingTypeClicked;
    vm.isCurrentThingType = currentThingTypeSubjects.isCurrentThingTypeIndex;

    vm.$onInit = function() {
      console.log("CurrentThingTypesController",$scope);
    }
    vm.$postLink = function() {
      $scope.$watch(
        function() { return currentThingTypeSubjects.getThingTypes(); }, 
        function(thing_types) { vm.thing_types = thing_types; }
      );
    }     
    return;
    //////////////

    function thingTypeClicked(index) {
      console.log("thing type clicked", index);
      currentThingTypeSubjects.setCurrentThingType(index);
    }  
  }

})();