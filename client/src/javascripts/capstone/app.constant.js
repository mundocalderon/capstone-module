(function() {
    'use strict';

    angular
        .module('capstone')
        .constant("capstone.APP_CONFIG", {
        	server_url: "http://localhost:3000",
        	main_page_html: "capstone/pages/main.html",
        	cities_html: "capstone/cities/cities.html"     	

        });
})();