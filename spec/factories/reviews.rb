FactoryGirl.define do
  factory :review do
    star_count {1 + rand(4)}
    body Faker::Hipster.paragraph
    product
    user
  end
end
