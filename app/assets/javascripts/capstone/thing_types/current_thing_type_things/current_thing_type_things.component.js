(function() {
  "use strict";

  angular
  .module("capstone.thingTypes")
  .component("capCurrentThingTypeThings", {
    templateUrl: thingsTemplateUrl,
    controller: CurrentThingsController
  })
  ;

  thingsTemplateUrl.$inject = ["capstone.config.APP_CONFIG"];
  function thingsTemplateUrl(APP_CONFIG) {
    return APP_CONFIG.current_thing_type_things_html;
  }

  CurrentThingsController.$inject = ["$scope",
                                     "capstone.thingTypes.currentThingTypeSubjects"];
  function CurrentThingsController($scope,currentThingTypeSubjects) {
    var vm=this;
    vm.thingClicked = thingClicked;
    vm.isCurrentThing = currentThingTypeSubjects.isCurrentThingIndex;

    vm.$onInit = function() {
      console.log("CurrentThingsController",$scope);
    }
    vm.$postLink = function() {
      $scope.$watch(
        function() { return currentThingTypeSubjects.getThings(); },
        function(things) { vm.things = things; }
        );
    }
    return;
    //////////////
    function thingClicked(index) {
      currentThingTypeSubjects.setCurrentThing(index);
    }
  }
})();