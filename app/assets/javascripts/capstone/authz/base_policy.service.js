(function() {
    'use strict';

    angular
        .module('capstone.authz')
        .factory('capstone.authz.BasePolicy', BasePolicyFactory);

    BasePolicyFactory.$inject = ['capstone.authz.Authz'];
    function BasePolicyFactory(Authz) {
      function BasePolicy(resourceName){
        this.resourceName = resourceName;
        return;
      }

      BasePolicy.prototype.getAuthorizedUserId = function(){
        return Authz.getAuthorizedUserId();
      };
      //returns a promise of the new user being resolved
      BasePolicy.prototype.getAuthorizedUser = function(){
        return Authz.getAuthorizedUser();
      }

      BasePolicy.prototype.isAuthenticated = function() { 
        return Authz.isAuthenticated();
      }

      BasePolicy.prototype.canCreate = function() {
        return Authz.isOriginator(this.resourceName);
      }

      BasePolicy.prototype.canQuery = function() {
        return true;
      }

      BasePolicy.prototype.canUpdate = function(item) {
        if(!item) {
          return false;
        } else { 
          return !item.id ? this.canCreate() : Authz.isOrganizer(item);
        }
      }

      BasePolicy.prototype.canDelete = function(item) {
        return (item && item.id && (this.canUpdate(item) || Authz.isAdmin())) == true;
      };

      BasePolicy.prototype.canGetDetails = function(item) {
        if(!item) {
          return false;
        } else {
          return !item.id ? this.canCreate() : (Authz.isMember(item) || Authz.isAdmin());
        }
      }
      
      return BasePolicy;
    };
})();