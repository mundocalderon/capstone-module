(function() {
    'use strict';

    angular
        .module('capstone.authn')
        .component('capSignup', {
          templateUrl: templateUrl,
          controller: SignupController,
        });

    templateUrl.$inject = ["capstone.config.APP_CONFIG"];
    function templateUrl(APP_CONFIG){
      return APP_CONFIG.authn_signup_html;
    }

    SignupController.$inject = ['$scope', "$state", "capstone.authn.Authn", 'capstone.layout.DataUtils', 'capstone.subjects.Image'];

    /* @ngInject */
    function SignupController($scope, $state, Authn, DataUtils, Image) {
      var vm=this;

      vm.signupForm = {}
      vm.signup = signup;
      vm.setImageContent = setImageContent

      vm.$onInit = function(){
        console.log("SignupController", $scope);
      }
      return;

      function setImageContent(dataUri) {
        console.log("setImageContent", dataUri ? dataUri.length : null);      
        vm.image_content = DataUtils.getContentFromDataUri(dataUri);
      } 

      function signup() {
        console.log("signup ...");
        $scope.signup_form.$setPristine();
        Authn.signup(vm.signupForm).then(
          function(response){
            vm.id = response.data.data.id;
            console.log("signup complete", response.data, vm);
            vm.image = new Image();
            vm.image.caption = "user_image_"+vm.id;
            vm.image.image_content = vm.image_content
            vm.image.$save().then( 
              function(){
                console.log(" did my image save?", vm.image, vm.image_content);
              },
              function(){"looks like something went wrong", vm.image, vm.image_content}
              );
            $state.go("home", {}, {reload:true});
          },
          function(response){
            vm.signupForm["errors"]=response.data.errors;
            console.log("signup failure", response, vm);
          }
        )//.catch(function(response){ console.log("signup failure", response, vm) });
      }
    }
})();