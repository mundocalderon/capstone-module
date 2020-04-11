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

      // vm.$onInit = function () {
      //   console.log("ThingSelectorController", $scope);
      //   if(!$stateParams.id) {
      //     vm.items = Thing.query();
      //   }
      // }

      vm.$onInit = function() {
        console.log("ThingSelectorController",$scope);
        $scope.$watch( function(){ return Authn.getCurrentUser(); }, 
                       function(){ if (!$stateParams.id) {vm.items = Thing.query(); }}
                      );
      }


      return;
      /////////////////////////
    }

    ThingEditorController.$inject = ['$scope',
                                      '$stateParams',
                                      '$state',
                                      'capstone.subjects.Thing'];
    function ThingEditorController($scope,$stateParams,$state,Thing){
      var vm = this;
      vm.create = create;
      vm.clear = clear;
      vm.update = update;
      vm.remove = remove;

      vm.$onInit = function() {
        console.log("ThingEditorController", $scope);
        if ($stateParams.id) {
          vm.item = Thing.get({id:$stateParams.id});
        }else{
          newResource();
        }
      }
      return;


      function newResource(){
        vm.item = new Thing();
        return vm.item;
      }

      function clear(){
        newResource();
        $state.go(".", {id:null});
      }

      function create(){
        $scope.thingform.$setPristine();
        vm.item.errors = null;
        vm.item.$save().then(
          function(){
            $state.go(".", {id: vm.item.id});
          },
          handleError);
      }

      function update() {
        $scope.thingform.$setPristine();
        vm.item.errors = null;
        vm.item.$update().then(
          function(){
            console.log("update complete", vm.item);
            $state.reload();
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
      }
    }

})();