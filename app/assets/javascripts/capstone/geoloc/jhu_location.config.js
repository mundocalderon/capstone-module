(function() {
  "use strict";

  angular
    .module("capstone.geoloc")
    .config(JhuLocationOverride);

  JhuLocationOverride.$inject=["capstone.geoloc.myLocationProvider"];
  function JhuLocationOverride(myLocationProvider) {
    myLocationProvider.usePositionOverride({
      longitude:-76.6200464, 
      latitude: 39.3304957      
    });
  }
})(); 