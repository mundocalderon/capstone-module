(function() {
  "use strict";

  angular
    .module("spa-demo.subjects")
    .factory("spa-demo.subjects.ThingTypeThing", ThingTypeThingFactory);

  ThingTypeThingFactory.$inject = ["$resource","spa-demo.config.APP_CONFIG"];
  function ThingTypeThingFactory($resource, APP_CONFIG) {
    return $resource(APP_CONFIG.server_url + "/api/thing_types/:id/typed_things");
  }
})();