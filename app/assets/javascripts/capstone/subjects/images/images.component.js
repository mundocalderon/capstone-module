(function() {
  "use strict";

  angular
    .module("capstone.subjects")
    .component("capImageSelector", {
      templateUrl: imageSelectorTemplateUrl,
      controller: ImageSelectorController,
      bindings: {
        authz: "<"
      },
    })
    .component("capImageEditor", {
      templateUrl: imageEditorTemplateUrl,
      controller: ImageEditorController,
      bindings: {
        authz: "<"
      },
    });


  imageSelectorTemplateUrl.$inject = ["capstone.config.APP_CONFIG"];
  function imageSelectorTemplateUrl(APP_CONFIG) {
    return APP_CONFIG.image_selector_html;
  }
  imageEditorTemplateUrl.$inject = ["capstone.config.APP_CONFIG"];
  function imageEditorTemplateUrl(APP_CONFIG) {
    return APP_CONFIG.image_editor_html;
  }     

  ImageSelectorController.$inject = ["$scope",
                                     "$stateParams",
                                     "capstone.subjects.Image"];
  function ImageSelectorController($scope, $stateParams, Image) {
    var vm=this;

    vm.$onInit = function() {
      console.log("ImageSelectorController",$scope);
      if (!$stateParams.id) {
        vm.items = Image.query();
      }
    }
    return;
    //////////////
  }

  ImageEditorController.$inject = ["$scope", "$q",
                                     "$state","$stateParams",
                                     "capstone.subjects.Image",
                                     "capstone.subjects.ImageThing",
                                     "capstone.subjects.ImageLinkableThing",
                                     ];
  function ImageEditorController($scope, $q, $state, $stateParams, Image, ImageThing, ImageLinkableThing) {
    var vm=this;
    vm.create = create;
    vm.clear = clear;
    vm.update = update;
    vm.remove = remove;
    vm.linkThings = linkThings;

    vm.$onInit = function() {
      console.log("ImageEditorController",$scope);
      if ($stateParams.id) {
        $scope.$watch(function(){ return vm.authz.authenticated }, function(){ reload($stateParams.id); }); 
      }else{
        newResource();
      }
    }
    return;
    //////////////

    function newResource() {
      vm.item = new Image();
      return vm.item;
    }

    function reload(imageId) {
      var itemId = imageId ? imageId : vm.item.id;
      console.log("re/loading image", itemId);
      vm.item = Image.get({id:itemId});
      vm.things = ImageThing.query({image_id:itemId});
      vm.linkable_things = ImageLinkableThing.query({image_id:itemId});
      $q.all([vm.item.$promise, vm.things.$promise]).catch(handleError);
    }

    function clear() {
      newResource();
      $state.go(".", {id:null});
    }

    function create() {
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
      linkThings(update);
    }

    function linkThings(parentPromise) {
      var promises=[];
      if (parentPromise) { promises.push(parentPromise); }
      angular.forEach(vm.selected_linkables, function(linkable){
        var resource=ImageThing.save({image_id:vm.item.id}, {thing_id:linkable});
        promises.push(resource.$promise);
      });

      vm.selected_linkables=[];
      console.log("waiting for promises", promises);
      $q.all(promises).then(
        function(response){
          console.log("promise.all response", response); 
          $scope.imageform.$setPristine();
          reload(); 
        },
        handleError);    
    }

    function remove() {
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
      if (response.data) {
        vm.item["errors"]=response.data.errors;          
      } 
      if (!vm.item.errors) {
        vm.item["errors"]={}
        vm.item["errors"]["full_messages"]=[response]; 
      }
      $scope.imageform.$setPristine();      
    }    
  }

})();