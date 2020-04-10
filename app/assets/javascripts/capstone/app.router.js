(function() {
  "use strict";

  angular
    .module("capstone")
    .config(RouterFunction);


  RouterFunction.$inject = ["$stateProvider",
                            "$urlRouterProvider", 
                            "capstone.config.APP_CONFIG"];

  function RouterFunction($stateProvider, $urlRouterProvider, APP_CONFIG) {
    $stateProvider
    .state("home",{
      url: "/",
      templateUrl: APP_CONFIG.main_page_html,
      // controller: ,
      // controllerAs: ,
    })
    .state("accountSignup",{
      url: "/signup",
      templateUrl: APP_CONFIG.signup_page_html
    })
    .state("authn",{
      url: "/authn",
      templateUrl: APP_CONFIG.authn_page_html
    })
    .state("images",{
      url: "/images/:id",
      templateUrl: APP_CONFIG.images_page_html
    }); 

    //$urlRouterProvider.otherwise("/"); eliminate default route
  }
})();