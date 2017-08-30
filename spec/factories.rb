FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "spectre#{n}@mail.com" }
    password "password"
    password_confirmation "password"
    confirmed_at Date.today

    after(:build) do |user, evaluator|
      if !evaluator.tenant.nil?
        user.tenant_id = evaluator.tenant.id
      end
    end
  end

  factory :device_email do
    sequence(:email) { |n| "device_email#{n}@mail.com" }
  end

  factory :tenant do
    sequence(:name) { |n| "Spectre#{n}" }
    organization { "#{name.downcase}" }
  end

  factory :terminal do
    sequence(:name) { |n| "terminal#{n}" }
  end

  factory :device do
    sequence(:imei) { |n| "#{n}" }
    os "Android"
    sequence(:phone) { |n| "1234-44#{n}"}
    owner "Spectre"
    model "Moto G"
    current false

    trait :with_pairing_token do
      pairing_token nil
    end
  end
end
