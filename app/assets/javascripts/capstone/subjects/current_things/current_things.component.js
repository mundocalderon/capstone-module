(function() {
  "use strict";

  angular
    .module("capstone.subjects")
    .component("capCurrentThings", {
      templateUrl: thingsTemplateUrl,
      controller: CurrentThingsController,
    });


  thingsTemplateUrl.$inject = ["capstone.config.APP_CONFIG"];
  function thingsTemplateUrl(APP_CONFIG) {
    return APP_CONFIG.current_things_html;
  }    

  CurrentThingsController.$inject = ["$scope",
                                     "capstone.subjects.currentSubjects"];
  function CurrentThingsController($scope,currentSubjects) {
    var vm=this;

    vm.$onInit = function() {
      console.log("CurrentThingsController",$scope);
    }
    return;
    //////////////
  }
})(); 