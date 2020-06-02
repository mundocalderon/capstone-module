class ThingTypesController < ApplicationController
	def index
		@thing_types = ThingType.all
	end

	def show
		@thing_type = ThingType.find(params[:id])
		@things = thing_type.things
	end
end
