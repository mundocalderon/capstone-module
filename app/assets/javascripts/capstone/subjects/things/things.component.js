(function() {
    'use strict';

    angular
        .module('capstone.subjects')
        .component('capThingSelector', {
            templateUrl: thingSelectorTemplateUrl,
            controller: ThingSelectorController,
            bindings: {
              authz: "<"
            },
        })
        .component('capThingEditor', {
            templateUrl: thingEditorTemplateUrl,
            controller: ThingEditorController,
            bindings: {
              authz: "<"
            },
        });

    thingSelectorTemplateUrl.$inject = ["capstone.config.APP_CONFIG"];
    function thingSelectorTemplateUrl(APP_CONFIG){
      return APP_CONFIG.thing_selector_html;
    }

    thingEditorTemplateUrl.$inject = ["capstone.config.APP_CONFIG"];
    function thingEditorTemplateUrl(APP_CONFIG){
      return APP_CONFIG.thing_editor_html;
    }

    ThingSelectorController.$inject = ['$scope',
                                        '$stateParams',
                                        'capstone.subjects.Thing',
                                        'capstone.authn.Authn'];
    function ThingSelectorController($scope, $stateParams, Thing, Authn) {
      var vm=this;

      vm.$onInit = function() {
        console.log("ThingSelectorController",$scope);
        $scope.$watch( function(){ return Authn.getCurrentUser(); }, 
                       function(){ if (!$stateParams.id) {vm.items = Thing.query(); }}
                      );
      }


      return;
      /////////////////////////
    }

    ThingEditorController.$inject = ['$scope', '$q',
                                      '$state','$stateParams',
                                      'capstone.subjects.Thing',
                                      'capstone.subjects.ThingImage'];
    function ThingEditorController($scope, $q, $state, $stateParams,Thing, ThingImage){
      var vm = this;
      vm.create = create;
      vm.clear = clear;
      vm.update = update;
      vm.remove = remove;
      vm.haveDirtyLinks = haveDirtyLinks;
      vm.updateImageLinks = updateImageLinks;

      vm.$onInit = function() {
        console.log("ThingEditorController", $scope);
        if ($stateParams.id) {
          $scope.$watch(function(){ return vm.authz.authenticated }, function(){ reload($stateParams.id); });
        }else{
          newResource();
        }
      }
      return;


      function newResource(){
        vm.item = new Thing();
        return vm.item;
      }

      function reload(thingId) {
        var itemId = thingId ? thingId : vm.item.id;      
        console.log("re/loading thing", itemId);
        vm.images = ThingImage.query({thing_id:itemId});
        vm.item = Thing.get({id:itemId});
        vm.images.$promise.then(
          function(){
            angular.forEach(vm.images, function(ti){
              ti.originalPriority = ti.priority;            
            });                     
          });
        $q.all([vm.item.$promise,vm.images.$promise]).catch(handleError);
      }

    function haveDirtyLinks() {
      for (var i=0; vm.images && i<vm.images.length; i++) {
        var ti=vm.images[i];
        if (ti.toRemove || ti.originalPriority != ti.priority) {
          return true;
        }        
      }
      return false;
    } 

      function clear(){
        newResource();
        $state.go(".", {id:null});
      }

      function create(){
        vm.item.errors = null;
        vm.item.$save().then(
          function(){
            $state.go(".", {id: vm.item.id});
          },
          handleError);
      }

      function update() {
        vm.item.errors = null;
        var update=vm.item.$update();
        updateImageLinks(update);
      }

      function updateImageLinks(promise) {
        console.log("updating links to images");
        var promises = [];
        if (promise) { promises.push(promise); }
        angular.forEach(vm.images, function(ti){
          if (ti.toRemove) {
            promises.push(ti.$remove());
          } else if (ti.originalPriority != ti.priority) {          
            promises.push(ti.$update());
          }
        });

        console.log("waiting for promises", promises);
        $q.all(promises).then(
          function(response){
            console.log("promise.all response", response); 
            //update button will be disabled when not $dirty
            $scope.thingform.$setPristine();
            reload(); 
          }, 
          handleError);    
      }

      function remove(){
        vm.item.errors = null;
        vm.item.$delete().then(
          function(){
            console.log("remove complete", vm.item);
            clear();
          },
          handleError);
      }

      function handleError(response) {
        console.log("error", response);
        if(response.data){
          vm.item["errors"] = response.data.errors;
        }
        if(!vm.item.errors) {
          vm.item["errors"]={}
          vm.item["errors"]["full_messages"]=[response];
        }
        $scope.thingform.$setPristine();
      }
    }

})();