(function() {
  "use strict";

  angular
    .module("capstone.subjects")
    .factory("capstone.subjects.Thing", ThingFactory);

  ThingFactory.$inject = ["$resource", "capstone.config.APP_CONFIG"];
  function ThingFactory($resource, APP_CONFIG) {
    var service = $resource(APP_CONFIG.server_url + "/api/things/:id",
      { id: '@id' },
      {
        update: {method: "PUT", transformRequest: buildNestedBody },
        save:   {method: "POST", transformRequest: buildNestedBody }
      });
    return service;
  }

  //rails wants at least one parameter of the document filled in
  //all of our fields are optional
  //ngResource is not passing a null field by default, we have to force it
  function checkEmptyPayload(data) {
    if (!data['name']) {
      data['name']=null;
    } 
    return angular.toJson(data);
  }

  function buildNestedBody(data) {
    return angular.toJson({thing: data})
  } 

})(); 
