(function() {
    'use strict';

    angular
        .module('capstone.cities')
        .controller('capstone.cities.CitiesController', CitiesController);

    CitiesController.$inject = ['capstone.cities.City'];

    function CitiesController(City) {
        var vm = this;
        vm.city;
        vm.cities;
        vm.edit = edit;
        vm.create = create;
        vm.update = update;
        vm.destroy = destroy;

        activate();
        return;
        ////////////////
        function activate() {
        	newCity();
            vm.cities = City.query();
        }

        function newCity() {
        	vm.city = new City();
        }

        function handleError(response){
        	console.log(response);
        }

        function edit(object){
            vm.city=object;
        }

        function create(){
            vm.city.$save()
            .then(function(response){
                console.log(response);
                vm.cities.push(vm.city);
                newCity();
            })
            .catch(handleError);
        }

        function update(){
            vm.city.$update()
            .then(function(response){

            })
            .catch(handleError);
        }

        function destroy(){
            vm.city.$delete()
            .then(function(resposne){
                removeElement(vm.cities, vm.city);
                //vm.cities = City.query();
                newCity();
            })
            .catch(handleError);
        }

        function removeElement(elements, element){
            for( var i=0; i<element.length; i++){
                if(elements[i].id == element.id){
                    elements.splice(i,1);
                    break;
                }
            }
        }

    }
})();