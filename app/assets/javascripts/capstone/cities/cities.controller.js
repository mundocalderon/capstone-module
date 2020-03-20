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

        activate();
        return;
        ////////////////
        function activate() {
        	newCity();
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