# 
#rails g factory_girl:model City
# 

FactoryGirl.define do
  factory :city_fixed, class: 'City' do
  	name "test"
  end
    
  factory :city_sequence, class: 'City' do
  	sequence(:name) { |n| "test_#{n}" }
  end

  factory :city_names, class: 'City' do
  	sequence(:name) { |n| ["one_#{n}", "two_#{n}", "three_#{n}", "four", "five", "six"][n%3] }
  end

  factory :city_faker_names, class: 'City' do
  	name { Faker::Name.name }
  end

  factory :city, :parent => :city_faker_names do
  end

	# FactoryGirl.attributes_for(:city_transient, :male=>false)
	# => {}
	#FactoryGirl.build(:city_transient, :male=>false).attributes
	# => {"id"=>nil, "name"=>"Ms Test", "created_at"=>nil, "updated_at"=>nil}
  factory :city_transient, class: 'City' do
  	transient do
  		male true
  	end

  	after(:build) do |object, props|
  		object.name = props.male ? "Mr Test" : "Ms Test"
  	end
  end


	# FactoryGirl.attributes_for(:city_transient2, :male=>false)
	# => {:name=>"test"}
	#FactoryGirl.build(:city_transient2, :male=>false).attributes
	# => {"id"=>nil, "name"=>"Ms Test", "created_at"=>nil, "updated_at"=>nil}
  factory :city_transient2, class: 'City' do
  	name "test"
  	transient do
  		male true
  	end

  	after(:build) do |object, props|
  		object.name = props.male ? "Mr Test" : "Ms Test"
  	end
  end


	# > FactoryGirl.build(:city_ctor)
	# => #<City:0x00007fd788f4db68 id: nil, name: nil, created_at: nil, updated_at: nil>
	# > FactoryGirl.build(:city_ctor, name: "test")
	# => #<City:0x00007fd788f865d0 id: nil, name: "test", created_at: nil, updated_at: nil>
	# > FactoryGirl.build(:city_ctor).name
	# => nil
	# > FactoryGirl.build(:city_ctor, name: "test").name
	# => "test"
  factory :city_ctor, class: 'City' do
  	transient do
  		hash {}
  	end
  	initialize_with { City.new(hash) }
  end


end
