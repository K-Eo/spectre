FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "spectre#{n}@mail.com" }
    password "password"
    password_confirmation "password"
    confirmed_at Date.today
  end

  factory :company do
    sequence(:name) { |n| "company_#{n}" }
  end
end
