FactoryGirl.define do
  factory :thing do
    name { Faker::Commerce.product_name }
    sequence(:description) { |n| n%2==0 ? Faker::Lorem.paragraphs.join : nil }
    notes { Faker::Lorem.sentence }

    trait(:with_description) do
      description { Faker::BossaNova.song }
    end

    trait :with_image do
      transient do
        image_count 1
      end
      after(:build) do |thing, props|
        thing.thing_images << FactoryGirl.build_list(:thing_image, props.image_count, :thing=>thing)
      end
    end
  end
end
