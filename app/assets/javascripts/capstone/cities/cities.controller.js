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

        function edit(object, index){

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

        function read(){

        }

        function update(){

        }

        function destroy(){

        }

        function removeElements(elements, element){

        }

    }
})();