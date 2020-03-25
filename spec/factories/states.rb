# rails g factory_girl:model State
FactoryGirl.define do
  factory :state, :parent => :state_team do
    
  end

	factory :state_team, class: 'State' do
  	name { Faker::Team.name.titleize }
  end
end
