FactoryGirl.define do
  factory :thing_type do
    name { Faker::Company.industry }
    sequence(:description) {|n| n%5==0 ? nil : Faker::Lorem.paragraphs.join}
  end
end
