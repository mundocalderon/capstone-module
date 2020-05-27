class Image < ActiveRecord::Base
  include Protectable
  attr_accessor :image_content

  has_many :thing_images, inverse_of: :image, dependent: :destroy
  has_many :things, through: :thing_images

	# Adds reader and writer methods for manipulating a value object: 
	# composed_of :address adds address and address=(new_address) methods.

	# The first item is the attribute name in the ActiveRecord model, 
	# and the second is the name of the attribute in the ValueObject 
	# (the writer uses it to read from the VO).

	# Furthermore, the order in which mapping pairs are specified should 
	# be the same as the order the attributes are specified in the 
	# ValueObject’s initialize method (for the reader to be able to 
	# instantiate a VO with the record’s values).
  composed_of :position, class_name: "Point", allow_nil: true, mapping: [%w(lng lng), %w(lat lat)]
  
  #Geokit macro
  acts_as_mappable

  scope :included, ->(images) { 
    where(id: images)
  }

  scope :excluded, ->(images) {
    where.not(id: images)
  }

  def to_lat_lng
  	Geokit::LatLng.new(lat,lng)
  end

  def basename
  	caption || "image-#{id}"
  end
end

Point.class_eval do
	def to_lat_lng
		Geokit::LatLng.new(*latlng)
	end
end