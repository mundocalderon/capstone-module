(function() {
    'use strict';

    angular
        .module('capstone.subjects')
        .factory('capstone.subjects.ImagesAuthz', ImagesAuthzFactory);

    ImagesAuthzFactory.$inject = ['capstone.authz.Authz', 'capstone.authz.BasePolicy'];
    function ImagesAuthzFactory(Authz, BasePolicy) {
        function ImagesAuthz() {
          BasePolicy.call(this, "Image");
        }
          //start with base class prototype definitions
        ImagesAuthz.prototype = Object.create(BasePolicy.prototype);
        ImagesAuthz.constructor = ImagesAuthz;

          //override and add additional methods
        ImagesAuthz.prototype.canCreate=function() {
          //console.log("ItemsAuthz.canCreate");
          return Authz.isAuthenticated();
        };

        return new ImagesAuthz();
    }

})();
