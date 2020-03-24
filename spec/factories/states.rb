# rails g factory_girl:model State
FactoryGirl.define do
  factory :state, class: 'State' do
    
  end

	factory :state_team, class: 'State' do
  	name { Faker::Team.name.titleize }
  end
end
