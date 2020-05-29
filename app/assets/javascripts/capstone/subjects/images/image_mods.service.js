(function() {
  "use strict";

  angular
    .module("capstone.subjects")
    .factory("capstone.subjects.ImageMod", ImageMod);

  ImageMod.$inject = ["$resource", "capstone.config.APP_CONFIG"];

  function ImageMod($resource, APP_CONFIG) {
    return $resource(APP_CONFIG.server_url + "/api/mod_index", { }, { filter: { method: 'POST', miles:'@miles', isArray:true}});
  }

})(); 