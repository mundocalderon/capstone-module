FactoryGirl.define do
  factory :image do
    sequence(:caption) { |n| n%2==0 ? Faker::BossaNova.song : nil }
    creator_id 1

    trait(:with_caption) do
      caption { Faker::BossaNova.song }
    end
    
  end
end
