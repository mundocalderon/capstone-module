FactoryGirl.define do
  factory :image do
    sequence(:caption) { |n| n%2==0 ? Faker::Lorem.sentence : nil }
    creator_id 1

    trait(:with_caption) do
      caption { Faker::Lorem.sentence }
    end
    
  end
end
