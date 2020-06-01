(function() {
  "use strict";

  angular
    .module("capstone.subjects")
    .component("capCurrentImages", {
      templateUrl: imagesTemplateUrl,
      controller: CurrentImagesController,
    });


  imagesTemplateUrl.$inject = ["capstone.config.APP_CONFIG"];
  function imagesTemplateUrl(APP_CONFIG) {
    return APP_CONFIG.current_images_html;
  }    

  CurrentImagesController.$inject = ["$scope",
                                     "capstone.subjects.currentSubjects"];
  function CurrentImagesController($scope, currentSubjects) {
    var vm=this;
    vm.imageClicked = imageClicked;
    vm.isCurrentImage = currentSubjects.isCurrentImageIndex;

    vm.$onInit = function() {
      console.log("CurrentImagesController",$scope);
    }
    vm.$postLink = function() {
      $scope.$watch(
        function() { return currentSubjects.getImages(); }, 
        function(images) { vm.images = images; }
      );
    } 
    return;
    //////////////
    
    function imageClicked(index) {
      currentSubjects.setCurrentImage(index);
    }
  }
})();