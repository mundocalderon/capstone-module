(function() {
  "use strict";

  angular
  .module("capstone.thingTypes")
  .service("capstone.thingTypes.currentThingTypeSubjects", CurrentThingTypeSubjects);

  CurrentThingTypeSubjects.$inject = ["$rootScope","$q",
                                      "$resource","capstone.geoloc.currentOrigin",
                                      "capstone.config.APP_CONFIG"];

  function CurrentThingTypeSubjects($rootScope, $q, $resource, currentOrigin, APP_CONFIG) {
    var subjectsResource = $resource(APP_CONFIG.server_url + "/api/subjects",
                                      {},
                                      { query: { cache:false, isArray:true } });
    var thingTypesResource = $resource(APP_CONFIG.server_url + "/api/thing_types",
                                      {},
                                      { query: { cache:false, isArray:true } });
    var thingTypeResource = $resource(APP_CONFIG.server_url + "/api/thing_types/:id",
                                      {},
                                      { query: { cache:false, isArray:true } });

    var service = this;
    service.version = 0;
    service.images = [];
    service.imageIdx = null;
    service.things = [];
    service.thingIdx = null;
    service.thingTypes = [];
    service.thingTypeIdx = null;
    service.refresh = refresh;
    service.isCurrentImageIndex = isCurrentImageIndex;
    service.isCurrentThingIndex = isCurrentThingIndex;
    service.isCurrentThingTypeIndex = isCurrentThingTypeIndex;

    //refresh();
    $rootScope.$watch(function(){ return currentOrigin.getVersion(); }, refresh);
    $rootScope.$watch(function(){ return service.thingTypeIdx; }, refresh);
    return;

    ////////////////
    function refresh() {
      var params=currentOrigin.getPosition();
      if (!params || !params.lng || !params.lat) {
        params=angular.copy(APP_CONFIG.default_position);
      } else {
        params["distance"]=true;
      }

      if (currentOrigin.getDistance() > 0) {
        params["miles"]=currentOrigin.getDistance();
      }
      params["order"]="ASC";
      console.log("in refresh",params);
      var r1 = refreshImages(params);
      params["subject"]="thing";
      var r2 = refreshThings(params);
      var r3 = refreshThingTypes();
      $q.all([r3,r2,r1]).then(
        function(){
          var thing_type = service.getCurrentThingType() ? service.getCurrentThingType() : service.setCurrentThingType(0);
          setCurrentThingsForCurrentThingType(thing_type);
        });
    }

    function refreshImages(params) {
      var result=subjectsResource.query(params);
      result.$promise.then(
        function(images){
          service.images=images;
          service.version += 1;
          service.imageIdx = null;
          console.log("refreshImages", service);
        });
      return result.$promise;
    }

    function refreshThingTypes() {
      var result=thingTypesResource.query();
      result.$promise.then(
        function(thing_types){
          service.thingTypes=thing_types;
          service.version += 1;
          if (!service.thingTypeIdx || service.thingTypeIdx > thing_types.length) {
            service.thingTypeIdx=0;
          }
          console.log("refreshThingTypes", service);
        });
      return result.$promise;
    }

    function refreshThings(params) {
      var result = subjectsResource.query(params);
      result.$promise.then(
        function(things){
          service.things=things;
          service.version += 1;
          if (!service.thingIdx || service.thingIdx > things.length) {
            service.thingIdx=0;
          }
          console.log("refreshThings", service);
        });
      return result.$promise;
    }

    function setCurrentThingsForCurrentThingType(thing_type) {
      var result = thingTypeResource.query({id:thing_type.id});
      result.$promise.then(function(thing_type_things){
        var current_things = service.things;
        service.things = current_things.filter(function(thing){
          return thing_type_things.find(function(ttt){
            return ttt.id === thing.thing_id;
          });
        });
      });
    } 
  
    function isCurrentImageIndex(index) {
      //console.log("isCurrentImageIndex", index, service.imageIdx === index);
      return service.imageIdx === index;
    }
    function isCurrentThingIndex(index) {
      //console.log("isCurrentThingIndex", index, service.thingIdx === index);
      return service.thingIdx === index;
    }
    function isCurrentThingTypeIndex(index) {
      return service.thingTypeIdx === index;
    }
  }

  CurrentThingTypeSubjects.prototype.getVersion = function() {
    return this.version;
  }
  CurrentThingTypeSubjects.prototype.getImages = function() {
    return this.images;
  }
  CurrentThingTypeSubjects.prototype.getThings = function() {
    return this.things;
  }
  CurrentThingTypeSubjects.prototype.getThingTypes = function() {
    return this.thingTypes;
  }
  CurrentThingTypeSubjects.prototype.getCurrentImageIndex = function() {
    return this.imageIdx;
  }
  CurrentThingTypeSubjects.prototype.getCurrentImage = function() {
    return this.images.length > 0 ? this.images[this.imageIdx] : null;
  }
  CurrentThingTypeSubjects.prototype.getCurrentThing = function() {
    return this.things.length > 0 ? this.things[this.thingIdx] : null;
  }
  CurrentThingTypeSubjects.prototype.getCurrentThingType = function() {
    return this.thingTypes.length > 0 ? this.thingTypes[this.thingTypeIdx] : null;
  }
  CurrentThingTypeSubjects.prototype.getCurrentImageId = function() {
    var currentImage = this.getCurrentImage();
    return currentImage ? currentImage.image_id : null;
  }
  CurrentThingTypeSubjects.prototype.getCurrentThingId = function() {
    var currentThing = this.getCurrentThing();
    return currentThing ? currentThing.thing_id : null;
  }

  CurrentThingTypeSubjects.prototype.setCurrentImage = function(index, skipThing) {
    if (index >= 0 && this.images.length > 0) {
      this.imageIdx = (index < this.images.length) ? index : 0;
    } else if (index < 0 && this.images.length > 0) {
      this.imageIdx = this.images.length - 1;
    } else {
      this.imageIdx = null;
    }

    if (!skipThing) {
      this.setCurrentThingForCurrentImage();
    }

    console.log("setCurrentImage", this.imageIdx, this.getCurrentImage());
    return this.getCurrentImage();
  }

  CurrentThingTypeSubjects.prototype.setCurrentThing = function(index, skipImage) {
    if (index >= 0 && this.things.length > 0) {
      this.thingIdx = (index < this.things.length) ? index : 0;
    } else if (index < 0 && this.things.length > 0) {
      this.thingIdx = this.things.length - 1;
    } else {
      this.thingIdx=null;
    }

    if (!skipImage) {
      this.setCurrentImageForCurrentThing();
    }

    console.log("setCurrentThing", this.thingIdx, this.getCurrentThing());
    return this.getCurrentThing();
  }

  CurrentThingTypeSubjects.prototype.setCurrentThingType = function(index) {
    if (index >= 0 && this.thingTypes.length > 0) {
      this.thingTypeIdx = (index < this.thingTypes.length) ? index : 0;
    } else if (index < 0 && this.thingTypes.length > 0) {
      this.thingTypeIdx = this.thingTypes.length - 1;
    } else {
      this.thingTypeIdx=null;
    }
    console.log("set current thing type", this.thingTypeIdx);
    return this.getCurrentThingType();
  }

  CurrentThingTypeSubjects.prototype.setCurrentThingForCurrentImage = function() {
    var image=this.getCurrentImage();
    if (!image || !image.thing_id) {
      this.thingIdx = null;
    } else {
      var thing=this.getCurrentThing();
      if (!thing || thing.thing_id !== image.thing_id) {
        this.thingIdx=null;
        for (var i=0; i<this.things.length; i++) {
          thing=this.things[i];
          if (image.thing_id === thing.thing_id) {
            this.setCurrentThing(i, true);
            break;
          }
        }
      }
    }
  }

  CurrentThingTypeSubjects.prototype.setCurrentImageForCurrentThing = function() {
    var image=this.getCurrentImage();
    var thing=this.getCurrentThing();
    if (!thing) {
      this.imageIdx=null;
    } else if ((thing && (!image || thing.thing_id !== image.thing_id)) || image.priority!==0) {
      for (var i=0; i<this.images.length; i++) {
        image=this.images[i];
        if (image.thing_id === thing.thing_id && image.priority===0) {
          this.setCurrentImage(i, true);
          break;
        }
      }
    }
  }

  CurrentThingTypeSubjects.prototype.setCurrentImageId = function(image_id, skipThing) {
    var found=this.getCurrentImageId() === image_id;
    if (image_id && !found) {
      for(var i=0; i<this.images.length; i++) {
        if (this.images[i].image_id === image_id) {
          this.setCurrentImage(i, skipThing);
          found=true;
          break;
        }
      }
    }
    if (!found) {
      this.setCurrentImage(null, true);
    }
  }
  CurrentThingTypeSubjects.prototype.setCurrentThingId = function(thing_id, skipImage) {
    var found=this.getCurrentThingId() === thing_id;
    if (thing_id && !found) {
      for (var i=0; i< this.things.length; i++) {
        if (this.things[i].thing_id === thing_id) {
          this.setCurrentThing(i, skipImage);
          found=true;
          break;
        }
      }
    }
    if (!found) {
      this.setCurrentThing(null, true);
    }
  }
  CurrentThingTypeSubjects.prototype.setCurrentSubjectId = function(thing_id, image_id) {
    console.log("setCurrentSubject", thing_id, image_id);
    this.setCurrentThingId(thing_id, true);
    this.setCurrentImageId(image_id, true);
  }


})();