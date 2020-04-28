(function() {
  "use strict";

  angular
    .module("spa-demo.subjects")
    .factory("spa-demo.subjects.ThingTypifyThing", ThingTypifyThing);

  ThingTypifyThing.$inject = ["$resource","spa-demo.config.APP_CONFIG"];
  function ThingTypifyThing($resource, APP_CONFIG) {
    return $resource(APP_CONFIG.server_url + "/api/things/:thing_id/typify_things");
  }
})();