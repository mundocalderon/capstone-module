(function() {
  "use strict";

  angular
    .module("capstone.subjects")
    .component("capCurrentThings", {
      templateUrl: thingsTemplateUrl,
      controller: CurrentThingsController,
    })
    .component("capCurrentThingInfo", {
      templateUrl: thingInfoTemplateUrl,
      controller: CurrentThingInfoController,
    });


  thingsTemplateUrl.$inject = ["capstone.config.APP_CONFIG"];
  function thingsTemplateUrl(APP_CONFIG) {
    return APP_CONFIG.current_things_html;
  }    
  thingInfoTemplateUrl.$inject = ["capstone.config.APP_CONFIG"];
  function thingInfoTemplateUrl(APP_CONFIG) {
    return APP_CONFIG.current_thing_info_html;
  }  
  CurrentThingsController.$inject = ["$scope",
                                     "capstone.subjects.currentSubjects"];
  function CurrentThingsController($scope,currentSubjects) {
    var vm=this;
    vm.thingClicked = thingClicked;
    vm.isCurrentThing = currentSubjects.isCurrentThingIndex;

    vm.$onInit = function() {
      console.log("CurrentThingsController",$scope);
    }
    vm.$postLink = function() {
      $scope.$watch(
        function() { return currentSubjects.getThings(); }, 
        function(things) { vm.things = things; }
      );
    }     
    return;
    //////////////

    function thingClicked(index) {
      currentSubjects.setCurrentThing(index);
    }  
  }


  CurrentThingInfoController.$inject = ["$scope",
                                        "capstone.subjects.currentSubjects",
                                        "capstone.subjects.Thing",
                                        "capstone.authz.Authz"];
  function CurrentThingInfoController($scope,currentSubjects, Thing, Authz) {
    var vm=this;
    vm.nextThing = currentSubjects.nextThing;
    vm.previousThing = currentSubjects.previousThing;

    vm.$onInit = function() {
      console.log("CurrentThingInfoController",$scope);
    }
    vm.$postLink = function() {
      $scope.$watch(
        function() { return currentSubjects.getCurrentThing(); }, 
        newThing 
      );
      $scope.$watch(
        function() { return Authz.getAuthorizedUserId(); },
        function() { newThing(currentSubjects.getCurrentThing()); }
      );        
    }    
    return;
    //////////////
    function newThing(link) {
      vm.link = link; 
      vm.thing = null;
      if (link && link.thing_id) {
        vm.thing=Thing.get({id:link.thing_id});
      }
    }







  }
})();