(function() {
  "use strict";

  angular
    .module("capstone.layout")
    .component("capTabs", {
      templateUrl: tabsTemplateUrl,
      controller: TabsController,
      transclude: true,
      //bindings: {},
    });


  tabsTemplateUrl.$inject = ["capstone.config.APP_CONFIG"];
  function tabsTemplateUrl(APP_CONFIG) {
    return APP_CONFIG.tabs_html;
  }    

  TabsController.$inject = ["$scope"];
  function TabsController($scope) {
    var vm=this;

    vm.$onInit = function() {
      console.log("TabsController",$scope);
    }
    return;
    //////////////
  }
})(); 