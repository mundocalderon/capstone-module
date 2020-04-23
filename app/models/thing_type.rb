class ThingType < ActiveRecord::Base
	has_many :things#, inverse_of: :thing_type
end
