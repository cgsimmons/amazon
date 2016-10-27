FactoryGirl.define do
  factory :category do
    sequence(:name) { |n| "#{Faker::Company.name} #{n}" }
  end
end
