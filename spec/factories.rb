FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "spectre#{n}@mail.com" }
    first_name "foo"
    last_name "bar"
    password "password"
    password_confirmation "password"
    lat Faker::Address.latitude
    lng Faker::Address.longitude
    confirmed_at Date.today
  end

  factory :company do
    sequence(:name) { |n| "company_#{n}" }
  end
end
