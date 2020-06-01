(function() {
  "use strict";

  angular
    .module("capstone.subjects")
    .component("capCurrentSubjectsMap", {
      template: "<div id='map'></div>",
      controller: CurrentSubjectsMapController,
      bindings: {
        zoom: "@"
      }      
    });

  CurrentSubjectsMapController.$inject = ["$scope", "$q", "$element",
                                          "capstone.geoloc.currentOrigin",
                                          "capstone.geoloc.myLocation",
                                          "capstone.geoloc.Map",
                                          "capstone.subjects.currentSubjects",
                                          "capstone.config.APP_CONFIG"];
  function CurrentSubjectsMapController($scope, $q, $element, 
                                        currentOrigin, myLocation, Map, currentSubjects, 
                                        APP_CONFIG) {
    var vm=this;

    vm.$onInit = function() {
      console.log("CurrentSubjectsMapController",$scope);
    }
    vm.$postLink = function() {
      
    }

    return;
    //////////////
    function getLocation() {
      //...
    }

    function initializeMap(element, position) {
      //...
    }

    function displaySubjects(){
      //...
    }

    function displaySubject(ti) {
      //...
    }
  }

  CurrentSubjectsMapController.prototype.updateOrigin = function() {
    //...
  }

  CurrentSubjectsMapController.prototype.setActiveMarker = function(thing_id, image_id) {
    //...
  }

  CurrentSubjectsMapController.prototype.originInfoWindow = function(location) {
    //...
  }
  CurrentSubjectsMapController.prototype.thingInfoWindow = function(ti) {
    //...
  }
  CurrentSubjectsMapController.prototype.imageInfoWindow = function(ti) {
    //...
  }


})(); 