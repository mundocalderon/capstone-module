(function() {
    'use strict';

    angular
        .module('capstone.layout')
        .component('capImageLoader', {
        		templateUrl: templateUrl,
            bindings: {
            	resultDataUri: "&"
            },
            controller: ImageLoaderController,
            transclude: true
        });

    templateUrl.$inject = ["capstone.config.APP_CONFIG"];
    function templateUrl(APP_CONFIG){
    	return APP_CONFIG.image_loader_html;
    }

    ImageLoaderController.$inject = ['$scope'];
    function ImageLoaderController($scope) {
    	var vm=this;
    	vm.debug = debug;

    	vm.$onInit = function(){
    		console.log("ImageLoaderController", $scope);
    		$scope.$watch(function(){ return vm.dataUri },
    									function(){ vm.resultDataUri({dataUri: vm.dataUri}) });

    	}
    	return;

    	function debug() {
    		console.log("ImageLoaderController", $scope);
    	}
    }
})();